import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { serveStatic } from 'hono/cloudflare-workers'
import { sign, verify } from 'hono/jwt'
import { getCookie, setCookie } from 'hono/cookie'

type Bindings = {
  DB: D1Database
  JWT_SECRET: string
}

const app = new Hono<{ Bindings: Bindings }>()

// Utility functions
async function hashPassword(password: string): Promise<string> {
  const encoder = new TextEncoder()
  const data = encoder.encode(password)
  const hash = await crypto.subtle.digest('SHA-256', data)
  return Array.from(new Uint8Array(hash))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('')
}

async function createSession(db: D1Database, userId: number, jwtSecret: string): Promise<string> {
  const token = await sign({ userId, exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 7 }, jwtSecret)
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString()
  
  await db.prepare('INSERT INTO sessions (user_id, token, expires_at) VALUES (?, ?, ?)')
    .bind(userId, token, expiresAt)
    .run()
  
  return token
}

async function getUser(c: any): Promise<any> {
  const token = getCookie(c, 'auth_token')
  if (!token) return null
  
  try {
    const payload = await verify(token, c.env.JWT_SECRET)
    const user = await c.env.DB.prepare('SELECT id, email, name, plan, credits FROM users WHERE id = ?')
      .bind(payload.userId)
      .first()
    return user
  } catch {
    return null
  }
}

// Middleware for authentication
async function authMiddleware(c: any, next: any) {
  const user = await getUser(c)
  if (!user) {
    return c.json({ error: '로그인이 필요합니다.' }, 401)
  }
  c.set('user', user)
  await next()
}

// Enable CORS for API routes
app.use('/api/*', cors())

// Serve static files
app.use('/static/*', serveStatic({ root: './public' }))

// API Routes
app.get('/api/health', (c) => {
  return c.json({ status: 'ok', message: 'AI Fortune Telling Platform' })
})

// Auth APIs
app.post('/api/auth/register', async (c) => {
  try {
    const { email, password, name, phone, birthDate, gender } = await c.req.json()
    
    if (!email || !password || !name) {
      return c.json({ error: '필수 정보를 입력해주세요.' }, 400)
    }

    // Check if user exists
    const existing = await c.env.DB.prepare('SELECT id FROM users WHERE email = ?')
      .bind(email)
      .first()
    
    if (existing) {
      return c.json({ error: '이미 가입된 이메일입니다.' }, 400)
    }

    // Hash password
    const passwordHash = await hashPassword(password)

    // Create user
    const result = await c.env.DB.prepare(
      'INSERT INTO users (email, password_hash, name, phone, birth_date, gender) VALUES (?, ?, ?, ?, ?, ?)'
    ).bind(email, passwordHash, name, phone || null, birthDate || null, gender || null).run()

    const userId = result.meta.last_row_id as number

    // Create session
    const token = await createSession(c.env.DB, userId, c.env.JWT_SECRET)
    
    setCookie(c, 'auth_token', token, {
      httpOnly: true,
      secure: true,
      sameSite: 'Lax',
      maxAge: 7 * 24 * 60 * 60
    })

    return c.json({ 
      success: true, 
      user: { id: userId, email, name, plan: 'free', credits: 3 }
    })
  } catch (error) {
    console.error('Register error:', error)
    return c.json({ error: '회원가입 중 오류가 발생했습니다.' }, 500)
  }
})

app.post('/api/auth/login', async (c) => {
  try {
    const { email, password } = await c.req.json()
    
    if (!email || !password) {
      return c.json({ error: '이메일과 비밀번호를 입력해주세요.' }, 400)
    }

    const passwordHash = await hashPassword(password)

    const user = await c.env.DB.prepare(
      'SELECT id, email, name, plan, credits FROM users WHERE email = ? AND password_hash = ?'
    ).bind(email, passwordHash).first()

    if (!user) {
      return c.json({ error: '이메일 또는 비밀번호가 올바르지 않습니다.' }, 401)
    }

    const token = await createSession(c.env.DB, user.id as number, c.env.JWT_SECRET)
    
    setCookie(c, 'auth_token', token, {
      httpOnly: true,
      secure: true,
      sameSite: 'Lax',
      maxAge: 7 * 24 * 60 * 60
    })

    return c.json({ success: true, user })
  } catch (error) {
    console.error('Login error:', error)
    return c.json({ error: '로그인 중 오류가 발생했습니다.' }, 500)
  }
})

app.post('/api/auth/logout', async (c) => {
  const token = getCookie(c, 'auth_token')
  if (token) {
    await c.env.DB.prepare('DELETE FROM sessions WHERE token = ?').bind(token).run()
  }
  setCookie(c, 'auth_token', '', { maxAge: 0 })
  return c.json({ success: true })
})

app.get('/api/auth/me', async (c) => {
  const user = await getUser(c)
  if (!user) {
    return c.json({ error: '로그인이 필요합니다.' }, 401)
  }
  return c.json({ user })
})

// User Profile API
app.get('/api/user/profile', authMiddleware, async (c) => {
  const user = c.get('user')
  return c.json({ user })
})

app.put('/api/user/profile', authMiddleware, async (c) => {
  const user = c.get('user')
  const { name, phone, birthDate } = await c.req.json()
  
  await c.env.DB.prepare(
    'UPDATE users SET name = ?, phone = ?, birth_date = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?'
  ).bind(name, phone, birthDate, user.id).run()

  return c.json({ success: true })
})

// Reading History API
app.get('/api/user/readings', authMiddleware, async (c) => {
  const user = c.get('user')
  const { results } = await c.env.DB.prepare(
    'SELECT * FROM readings WHERE user_id = ? ORDER BY created_at DESC LIMIT 50'
  ).bind(user.id).all()
  
  return c.json({ readings: results })
})

// Credits API
app.post('/api/user/credits/purchase', authMiddleware, async (c) => {
  const user = c.get('user')
  const { credits, amount } = await c.req.json()
  
  // Create payment record
  await c.env.DB.prepare(
    'INSERT INTO payments (user_id, amount, credits, payment_method, status) VALUES (?, ?, ?, ?, ?)'
  ).bind(user.id, amount, credits, 'card', 'completed').run()
  
  // Add credits
  await c.env.DB.prepare(
    'UPDATE users SET credits = credits + ? WHERE id = ?'
  ).bind(credits, user.id).run()
  
  return c.json({ success: true, credits })
})

app.post('/api/user/plan/upgrade', authMiddleware, async (c) => {
  const user = c.get('user')
  const { plan, amount } = await c.req.json()
  
  // Create payment record
  await c.env.DB.prepare(
    'INSERT INTO payments (user_id, amount, plan, payment_method, status) VALUES (?, ?, ?, ?, ?)'
  ).bind(user.id, amount, plan, 'card', 'completed').run()
  
  // Update plan
  await c.env.DB.prepare(
    'UPDATE users SET plan = ? WHERE id = ?'
  ).bind(plan, user.id).run()
  
  return c.json({ success: true, plan })
})

// AI Face Reading API (with credit check)
app.post('/api/face-reading', async (c) => {
  try {
    // Check if user is logged in
    const user = await getUser(c)
    if (!user) {
      return c.json({ error: '로그인이 필요한 서비스입니다. 회원가입하고 무료 3회 체험하세요!' }, 401)
    }

    // Check credits
    if (user.credits < 1 && user.plan === 'free') {
      return c.json({ error: '크레딧이 부족합니다. 요금제를 업그레이드하거나 크레딧을 구매해주세요.' }, 403)
    }

    const formData = await c.req.formData()
    const image = formData.get('image')
    
    if (!image) {
      return c.json({ error: '이미지를 업로드해주세요.' }, 400)
    }

    // Validate file type
    if (image instanceof File) {
      const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
      if (!allowedTypes.includes(image.type)) {
        return c.json({ error: 'JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다.' }, 400)
      }

      // Validate file size (max 10MB)
      const maxSize = 10 * 1024 * 1024 // 10MB
      if (image.size > maxSize) {
        return c.json({ error: '이미지 크기는 10MB 이하여야 합니다.' }, 400)
      }

      console.log(`Face image uploaded: ${image.name}, ${image.size} bytes, ${image.type}`)
    }

    // Simulate AI analysis
    const celebrities = [
      { name: '아이유', similarity: 92, fortune: '부귀영화' },
      { name: '손예진', similarity: 88, fortune: '좋은 인연' },
      { name: '전지현', similarity: 85, fortune: '성공운' }
    ]

    const analysis = {
      faceShape: '계란형',
      features: {
        eyes: '큰 눈으로 총명함과 예술적 재능이 있습니다',
        nose: '곧은 콧대로 강한 의지와 리더십을 보여줍니다',
        mouth: '미소가 아름답고 대인관계가 원만합니다',
        forehead: '넓은 이마로 지혜롭고 통찰력이 뛰어납니다'
      },
      fortune: {
        wealth: '재물운이 매우 좋으며, 특히 30대 후반에 큰 기회가 찾아옵니다',
        love: '진실한 사랑을 만날 운명입니다. 운명적 만남이 가까이 있습니다',
        career: '현재 직장에서 승진운이 보이며, 리더십을 발휘할 기회가 옵니다',
        health: '전반적으로 건강하나, 스트레스 관리에 신경 쓰세요'
      },
      celebrities: celebrities,
      luckyColor: '보라색',
      luckyNumber: 7,
      luckyDay: '수요일'
    }

    return c.json(analysis)
  } catch (error) {
    return c.json({ error: '분석 중 오류가 발생했습니다.' }, 500)
  }
})

// AI Palm Reading API
app.post('/api/palm-reading', async (c) => {
  try {
    const formData = await c.req.formData()
    const image = formData.get('image')
    
    if (!image) {
      return c.json({ error: '손바닥 이미지를 업로드해주세요.' }, 400)
    }

    // Validate file type
    if (image instanceof File) {
      const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
      if (!allowedTypes.includes(image.type)) {
        return c.json({ error: 'JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다.' }, 400)
      }

      // Validate file size (max 10MB)
      const maxSize = 10 * 1024 * 1024 // 10MB
      if (image.size > maxSize) {
        return c.json({ error: '이미지 크기는 10MB 이하여야 합니다.' }, 400)
      }

      console.log(`Palm image uploaded: ${image.name}, ${image.size} bytes, ${image.type}`)
    }

    const analysis = {
      handShape: '물형',
      lines: {
        lifeLine: '생명선이 길고 뚜렷하여 건강하고 장수할 운명입니다',
        heartLine: '감정선이 안정적이며 행복한 연애와 결혼생활을 약속합니다',
        headLine: '두뇌선이 직선적이고 강하여 논리적 사고가 뛰어납니다',
        fateLine: '운명선이 뚜렷하여 자신만의 길을 개척해 나갈 것입니다'
      },
      fortune: {
        wealth: '재물선이 좋아 노후 걱정 없이 살 수 있습니다',
        love: '애정선이 깊어 평생 좋은 인연과 함께 할 것입니다',
        career: '사업선이 강하여 자수성가할 가능성이 높습니다',
        health: '건강선이 양호하나 40대 이후 건강관리 필요'
      },
      specialMarks: [
        '재물운을 상징하는 별 표시가 있습니다',
        '지혜를 나타내는 삼각형 문양이 보입니다'
      ],
      luckyAge: [28, 35, 42, 56]
    }

    return c.json(analysis)
  } catch (error) {
    return c.json({ error: '분석 중 오류가 발생했습니다.' }, 500)
  }
})

// Saju (Four Pillars) API
app.post('/api/saju', async (c) => {
  try {
    const { year, month, day, hour, gender } = await c.req.json()
    
    if (!year || !month || !day) {
      return c.json({ error: '생년월일을 입력해주세요.' }, 400)
    }

    const analysis = {
      fourPillars: {
        year: '壬寅 (임인)',
        month: '癸未 (계미)',
        day: '甲申 (갑신)',
        hour: hour ? '丙辰 (병진)' : '시간 미입력'
      },
      elements: {
        primary: '木 (나무)',
        secondary: '水 (물)',
        lucky: '火 (불)',
        unlucky: '金 (쇠)'
      },
      personality: {
        strengths: ['창의적', '리더십', '추진력', '친화력'],
        weaknesses: ['급한 성격', '독단적', '계획성 부족'],
        suitable: '예술, 교육, 경영, 방송'
      },
      fortune: {
        this_year: '올해는 새로운 기회가 많이 찾아오는 해입니다. 특히 상반기에 중요한 결정을 내리게 될 것입니다.',
        next_5_years: '향후 5년간 운세가 상승하며, 특히 재물운과 명예운이 좋습니다.',
        life_turning_points: [30, 38, 45, 52, 60]
      },
      compatibility: {
        best_match: ['토끼띠', '말띠', '개띠'],
        good_match: ['양띠', '돼지띠'],
        caution_match: ['원숭이띠', '뱀띠']
      },
      advice: '현재의 노력이 빛을 발할 시기입니다. 자신감을 가지고 새로운 도전을 해보세요.'
    }

    return c.json(analysis)
  } catch (error) {
    return c.json({ error: '분석 중 오류가 발생했습니다.' }, 500)
  }
})

// Tarot Reading API
app.post('/api/tarot', async (c) => {
  try {
    const { question, spread } = await c.req.json()
    
    const cards = [
      { name: '마법사', position: 'past', meaning: '과거에 자신의 능력을 발휘할 기회가 있었습니다' },
      { name: '여황제', position: 'present', meaning: '현재 풍요로움과 창조성이 넘치는 시기입니다' },
      { name: '황제', position: 'future', meaning: '미래에 권위와 안정을 얻게 될 것입니다' }
    ]

    return c.json({
      question: question || '오늘의 운세',
      spread: spread || 'three-card',
      cards: cards,
      overall: '전반적으로 긍정적인 흐름이 보입니다. 과거의 경험을 바탕으로 현재를 즐기고 미래를 준비하세요.'
    })
  } catch (error) {
    return c.json({ error: '타로 리딩 중 오류가 발생했습니다.' }, 500)
  }
})

// Zodiac/Astrology API
app.get('/api/zodiac/:sign', (c) => {
  const sign = c.req.param('sign')
  
  const zodiacData = {
    overall: '오늘은 전반적으로 좋은 날입니다. 새로운 기회를 잡을 준비를 하세요.',
    love: '사랑운이 상승하고 있습니다. 좋은 만남이 예상됩니다.',
    career: '직장에서 인정받을 일이 생길 것입니다.',
    wealth: '작은 재물운이 있으나 충동구매는 자제하세요.',
    health: '건강 상태가 양호합니다. 규칙적인 운동을 추천합니다.',
    luckyColor: '파란색',
    luckyNumber: 3,
    compatibility: ['물병자리', '쌍둥이자리']
  }

  return c.json({ sign, today: zodiacData })
})

// Main Page
app.get('/', (c) => {
  return c.html(`
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>운세의 신 - AI 기반 종합 운세 플랫폼</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
        <style>
            * {
                font-family: 'Noto Sans KR', sans-serif;
            }
            .gradient-bg {
                background: linear-gradient(135deg, #ff6b35 0%, #f7931e 50%, #ff9a56 100%);
            }
            .glass-effect {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            }
            .service-card {
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                cursor: pointer;
                border: 2px solid transparent;
            }
            .service-card:hover {
                transform: translateY(-8px) scale(1.02);
                box-shadow: 0 25px 50px rgba(255, 107, 53, 0.3);
                border-color: rgba(255, 107, 53, 0.3);
            }
            .fade-in {
                animation: fadeIn 0.6s ease-in;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(5px);
            }
            .modal.active {
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .modal-content {
                background: white;
                padding: 2rem;
                border-radius: 20px;
                max-width: 600px;
                width: 90%;
                max-height: 90vh;
                overflow-y: auto;
                animation: slideUp 0.3s ease-out;
                position: relative;
                user-select: text;
                -webkit-user-select: text;
                -moz-user-select: text;
                -ms-user-select: text;
            }
            .modal-content::-webkit-scrollbar {
                width: 8px;
            }
            .modal-content::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 10px;
            }
            .modal-content::-webkit-scrollbar-thumb {
                background: #ff6b35;
                border-radius: 10px;
            }
            .modal-content::-webkit-scrollbar-thumb:hover {
                background: #f7931e;
            }
            @keyframes slideUp {
                from { transform: translateY(50px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
            }
            .result-section {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                border-radius: 15px;
                padding: 1.5rem;
                margin: 1rem 0;
            }
            .celeb-card {
                background: white;
                border-radius: 10px;
                padding: 1rem;
                margin: 0.5rem 0;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
        </style>
    </head>
    <body class="gradient-bg min-h-screen">
        <!-- Header -->
        <header class="py-6 px-4">
            <div class="max-w-6xl mx-auto flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-moon text-white text-3xl"></i>
                    <h1 class="text-white text-2xl font-bold">운세의 신</h1>
                </div>
                <div class="flex items-center space-x-4">
                    <div id="userMenu" class="hidden text-white">
                        <span class="bg-white/20 px-4 py-2 rounded-lg">
                            <i class="fas fa-coins"></i> <span id="creditDisplay">3</span>회
                        </span>
                        <button onclick="openModal('profile')" class="ml-2 bg-white/20 px-4 py-2 rounded-lg hover:bg-white/30">
                            <i class="fas fa-user"></i> <span id="userName">마이페이지</span>
                        </button>
                    </div>
                    <div id="authButtons" class="flex space-x-2">
                        <button onclick="openModal('login')" class="text-white bg-white/20 px-4 py-2 rounded-lg hover:bg-white/30">
                            로그인
                        </button>
                        <button onclick="openModal('register')" class="text-white bg-orange-500 px-4 py-2 rounded-lg hover:bg-orange-600">
                            회원가입
                        </button>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="max-w-4xl mx-auto px-4 pb-12">
            <!-- Hero Section -->
            <div class="glass-effect rounded-3xl p-10 mb-6 fade-in text-center">
                <h2 class="text-5xl font-bold text-gray-800 mb-6" style="font-family: 'Noto Sans KR', sans-serif;">
                    당신의 운명을 만나보세요
                </h2>
                <p class="text-gray-700 text-lg mb-6">
                    전통 철학과 AI 기술이 만난 프리미엄 운세 서비스
                </p>
                <div class="bg-orange-50 border-2 border-orange-300 rounded-2xl p-5 mb-6 inline-block shadow-sm">
                    <p class="text-orange-800 font-bold text-xl mb-2">
                        🎁 지금 회원가입하고 <span class="text-3xl text-orange-600">무료 3회</span> 체험하세요!
                    </p>
                    <p class="text-orange-700 text-sm">
                        프리미엄 회원은 무제한 이용 가능 ✨
                    </p>
                </div>
                <div class="flex justify-center gap-8 text-base text-orange-700">
                    <span class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-orange-500"></i> AI 관상 분석
                    </span>
                    <span class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-orange-500"></i> 셀럽 닮은꼴
                    </span>
                    <span class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-orange-500"></i> 정통 사주
                    </span>
                </div>
            </div>

            <!-- Service Cards -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <!-- Face Reading -->
                <div class="service-card glass-effect rounded-3xl p-8 fade-in text-center" onclick="openModal('face')">
                    <div class="text-7xl mb-6">📸</div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">AI 관상</h3>
                    <p class="text-gray-600 text-sm mb-4 leading-relaxed">
                        얼굴 사진으로 운세 분석<br/>+ 셀럽 닮은꼴 찾기
                    </p>
                    <div class="mt-4 pt-4 border-t border-orange-200">
                        <span class="text-orange-600 text-sm font-semibold">
                            📷 사진 촬영
                        </span>
                    </div>
                </div>

                <!-- Palm Reading -->
                <div class="service-card glass-effect rounded-3xl p-8 fade-in text-center" onclick="openModal('palm')" style="animation-delay: 0.1s">
                    <div class="text-7xl mb-6">🤚</div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">AI 수상</h3>
                    <p class="text-gray-600 text-sm mb-4 leading-relaxed">
                        손바닥 사진으로<br/>손금 운세 해석
                    </p>
                    <div class="mt-4 pt-4 border-t border-orange-200">
                        <span class="text-orange-600 text-sm font-semibold">
                            🖐️ 손바닥 촬영
                        </span>
                    </div>
                </div>

                <!-- Saju -->
                <div class="service-card glass-effect rounded-3xl p-8 fade-in text-center" onclick="openModal('saju')" style="animation-delay: 0.2s">
                    <div class="text-7xl mb-6">🔮</div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">사주팔자</h3>
                    <p class="text-gray-600 text-sm mb-4 leading-relaxed">
                        생년월일시로<br/>정통 사주 풀이
                    </p>
                    <div class="mt-4 pt-4 border-t border-orange-200">
                        <span class="text-orange-600 text-sm font-semibold">
                            📅 생년월일 입력
                        </span>
                    </div>
                </div>

                <!-- Tarot -->
                <div class="service-card glass-effect rounded-3xl p-8 fade-in text-center" onclick="openModal('tarot')" style="animation-delay: 0.3s">
                    <div class="text-7xl mb-6">🃏</div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">타로 & 별자리</h3>
                    <p class="text-gray-600 text-sm mb-4 leading-relaxed">
                        디지털 타로카드와<br/>12궁도 운세
                    </p>
                    <div class="mt-4 pt-4 border-t border-orange-200">
                        <span class="text-orange-600 text-sm font-semibold">
                            🌟 카드 선택
                        </span>
                    </div>
                </div>
            </div>

            <!-- Features -->
            <div class="glass-effect rounded-3xl p-10 fade-in">
                <h3 class="text-3xl font-bold text-gray-800 mb-8 text-center">왜 운세의 신인가요?</h3>
                <div class="grid md:grid-cols-3 gap-8">
                    <div class="text-center">
                        <div class="text-6xl mb-4">🎯</div>
                        <h4 class="font-bold text-gray-800 text-lg mb-3">정확한 AI 분석</h4>
                        <p class="text-gray-600 text-sm leading-relaxed">최신 AI 기술로 정밀한 관상·수상 분석</p>
                    </div>
                    <div class="text-center">
                        <div class="text-6xl mb-4">⭐</div>
                        <h4 class="font-bold text-gray-800 text-lg mb-3">빠른 결과물</h4>
                        <p class="text-gray-600 text-sm leading-relaxed">유명 연예인과 얼굴 비교 분석</p>
                    </div>
                    <div class="text-center">
                        <div class="text-6xl mb-4">🔒</div>
                        <h4 class="font-bold text-gray-800 text-lg mb-3">안전한 서비스</h4>
                        <p class="text-gray-600 text-sm leading-relaxed">개인정보 보호와 보안 최우선</p>
                    </div>
                </div>
            </div>
        </main>

        <!-- Face Reading Modal -->
        <div id="faceModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">📸 AI 관상 분석</h3>
                    <button onclick="closeModal('face')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div id="faceContent">
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">얼굴 사진 업로드</label>
                        <input type="file" id="faceImage" accept="image/jpeg,image/jpg,image/png,image/webp" class="w-full p-3 border-2 border-orange-200 rounded-lg" onchange="previewImage('face')">
                        <p class="text-xs text-gray-500 mt-2">* JPG, PNG, WEBP 형식, 최대 10MB</p>
                        <div id="facePreview" class="mt-4 hidden">
                            <img id="facePreviewImg" class="max-w-full rounded-lg" />
                        </div>
                    </div>
                    <button onclick="analyzeFace()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition">
                        <i class="fas fa-magic mr-2"></i>AI 관상 분석 시작
                    </button>
                </div>
                <div id="faceResult" class="hidden"></div>
            </div>
        </div>

        <!-- Palm Reading Modal -->
        <div id="palmModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🤚 AI 수상 분석</h3>
                    <button onclick="closeModal('palm')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div id="palmContent">
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">손바닥 사진 업로드</label>
                        <input type="file" id="palmImage" accept="image/jpeg,image/jpg,image/png,image/webp" class="w-full p-3 border-2 border-orange-200 rounded-lg" onchange="previewImage('palm')">
                        <p class="text-xs text-gray-500 mt-2">* JPG, PNG, WEBP 형식, 최대 10MB</p>
                        <div id="palmPreview" class="mt-4 hidden">
                            <img id="palmPreviewImg" class="max-w-full rounded-lg" />
                        </div>
                    </div>
                    <button onclick="analyzePalm()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition">
                        <i class="fas fa-hand-sparkles mr-2"></i>AI 수상 분석 시작
                    </button>
                </div>
                <div id="palmResult" class="hidden"></div>
            </div>
        </div>

        <!-- Saju Modal -->
        <div id="sajuModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🔮 사주팔자 분석</h3>
                    <button onclick="closeModal('saju')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div id="sajuContent">
                    <div class="space-y-4 mb-6">
                        <div>
                            <label class="block text-gray-700 font-semibold mb-2">생년월일</label>
                            <input type="date" id="sajuBirthdate" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                        </div>
                        <div>
                            <label class="block text-gray-700 font-semibold mb-2">출생 시간 (선택)</label>
                            <input type="time" id="sajuBirthtime" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                        </div>
                        <div>
                            <label class="block text-gray-700 font-semibold mb-2">성별</label>
                            <select id="sajuGender" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                                <option value="female">여성</option>
                                <option value="male">남성</option>
                            </select>
                        </div>
                    </div>
                    <button onclick="analyzeSaju()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition">
                        <i class="fas fa-yin-yang mr-2"></i>사주팔자 분석 시작
                    </button>
                </div>
                <div id="sajuResult" class="hidden"></div>
            </div>
        </div>

        <!-- Tarot Modal -->
        <div id="tarotModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🃏 타로 & 별자리</h3>
                    <button onclick="closeModal('tarot')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div id="tarotContent">
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">질문하기 (선택)</label>
                        <textarea id="tarotQuestion" rows="3" class="w-full p-3 border-2 border-orange-200 rounded-lg" placeholder="오늘의 운세가 궁금해요..."></textarea>
                    </div>
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">별자리 선택</label>
                        <select id="zodiacSign" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                            <option value="aries">양자리</option>
                            <option value="taurus">황소자리</option>
                            <option value="gemini">쌍둥이자리</option>
                            <option value="cancer">게자리</option>
                            <option value="leo">사자자리</option>
                            <option value="virgo">처녀자리</option>
                            <option value="libra">천칭자리</option>
                            <option value="scorpio">전갈자리</option>
                            <option value="sagittarius">사수자리</option>
                            <option value="capricorn">염소자리</option>
                            <option value="aquarius">물병자리</option>
                            <option value="pisces">물고기자리</option>
                        </select>
                    </div>
                    <button onclick="analyzeTarot()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700 transition">
                        <i class="fas fa-magic mr-2"></i>타로 & 별자리 운세 보기
                    </button>
                </div>
                <div id="tarotResult" class="hidden"></div>
            </div>
        </div>

        <!-- Login Modal -->
        <div id="loginModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🔐 로그인</h3>
                    <button onclick="closeModal('login')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div class="space-y-4">
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">이메일</label>
                        <input type="email" id="loginEmail" class="w-full p-3 border-2 border-orange-200 rounded-lg" placeholder="email@example.com">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">비밀번호</label>
                        <input type="password" id="loginPassword" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                    </div>
                    <button onclick="login()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700">
                        로그인
                    </button>
                    <p class="text-center text-sm text-gray-600">
                        계정이 없으신가요? <button onclick="closeModal('login'); openModal('register');" class="text-orange-600 font-semibold">회원가입</button>
                    </p>
                </div>
            </div>
        </div>

        <!-- Register Modal -->
        <div id="registerModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">🎁 회원가입</h3>
                    <button onclick="closeModal('register')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div class="bg-orange-100 p-4 rounded-lg mb-4">
                    <p class="text-orange-800 font-semibold text-center">
                        🎉 회원가입하고 무료 3회 체험하세요!
                    </p>
                </div>
                <div class="space-y-4">
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">이름</label>
                        <input type="text" id="regName" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">이메일</label>
                        <input type="email" id="regEmail" class="w-full p-3 border-2 border-orange-200 rounded-lg" placeholder="email@example.com">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">비밀번호</label>
                        <input type="password" id="regPassword" class="w-full p-3 border-2 border-orange-200 rounded-lg">
                    </div>
                    <button onclick="register()" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700">
                        회원가입
                    </button>
                    <p class="text-center text-sm text-gray-600">
                        이미 계정이 있으신가요? <button onclick="closeModal('register'); openModal('login');" class="text-orange-600 font-semibold">로그인</button>
                    </p>
                </div>
            </div>
        </div>

        <!-- Profile/Pricing Modal -->
        <div id="profileModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">👤 마이페이지</h3>
                    <button onclick="closeModal('profile')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div class="space-y-4">
                    <div class="bg-orange-100 p-4 rounded-lg">
                        <p class="font-bold text-orange-800">현재 요금제: <span id="currentPlan">무료 체험</span></p>
                        <p class="text-orange-700">남은 크레딧: <span id="currentCredits">3</span>회</p>
                    </div>
                    <button onclick="openModal('pricing')" class="w-full bg-orange-600 text-white py-3 rounded-lg font-semibold hover:bg-orange-700">
                        💎 요금제 업그레이드
                    </button>
                    <button onclick="logout()" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300">
                        로그아웃
                    </button>
                </div>
            </div>
        </div>

        <!-- Pricing Modal -->
        <div id="pricingModal" class="modal">
            <div class="modal-content">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-orange-800">💎 요금제 안내</h3>
                    <button onclick="closeModal('pricing')" class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                <div class="space-y-4">
                    <div class="border-2 border-gray-300 rounded-lg p-4">
                        <h4 class="font-bold text-lg mb-2">🆓 무료 체험</h4>
                        <p class="text-3xl font-bold text-orange-600 mb-2">0원</p>
                        <ul class="text-sm space-y-1 text-gray-600">
                            <li>✓ 3회 무료 체험</li>
                            <li>✓ 모든 운세 서비스 이용</li>
                        </ul>
                    </div>
                    <div class="border-2 border-orange-300 bg-orange-50 rounded-lg p-4">
                        <h4 class="font-bold text-lg mb-2">⭐ 스탠다드</h4>
                        <p class="text-3xl font-bold text-orange-600 mb-2">9,900원<span class="text-sm">/월</span></p>
                        <ul class="text-sm space-y-1 text-gray-600">
                            <li>✓ 월 30회 이용</li>
                            <li>✓ 모든 운세 서비스</li>
                            <li>✓ 히스토리 저장</li>
                        </ul>
                        <button class="w-full mt-3 bg-orange-600 text-white py-2 rounded-lg hover:bg-orange-700">
                            구독하기
                        </button>
                    </div>
                    <div class="border-2 border-orange-500 bg-orange-100 rounded-lg p-4">
                        <div class="bg-orange-600 text-white px-3 py-1 rounded-full inline-block text-xs mb-2">추천</div>
                        <h4 class="font-bold text-lg mb-2">💎 프리미엄</h4>
                        <p class="text-3xl font-bold text-orange-600 mb-2">19,900원<span class="text-sm">/월</span></p>
                        <ul class="text-sm space-y-1 text-gray-600">
                            <li>✓ 무제한 이용</li>
                            <li>✓ 모든 운세 서비스</li>
                            <li>✓ 히스토리 무제한 저장</li>
                            <li>✓ 전문가 상담 1회</li>
                        </ul>
                        <button class="w-full mt-3 bg-orange-600 text-white py-2 rounded-lg hover:bg-orange-700">
                            구독하기
                        </button>
                    </div>
                    <div class="border-2 border-orange-600 bg-orange-50 rounded-lg p-4">
                        <h4 class="font-bold text-lg mb-2">👑 VIP</h4>
                        <p class="text-3xl font-bold text-orange-600 mb-2">39,900원<span class="text-sm">/월</span></p>
                        <ul class="text-sm space-y-1 text-gray-600">
                            <li>✓ 무제한 이용</li>
                            <li>✓ 우선 분석 처리</li>
                            <li>✓ 전문가 상담 3회</li>
                            <li>✓ 맞춤형 운세 리포트</li>
                        </ul>
                        <button class="w-full mt-3 bg-orange-600 text-white py-2 rounded-lg hover:bg-orange-700">
                            구독하기
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/axios@1.6.0/dist/axios.min.js"></script>
        <script>
            function openModal(type) {
                document.getElementById(type + 'Modal').classList.add('active');
            }

            function closeModal(type) {
                document.getElementById(type + 'Modal').classList.remove('active');
                // Reset form
                document.getElementById(type + 'Result').classList.add('hidden');
                document.getElementById(type + 'Content').classList.remove('hidden');
            }

            function previewImage(type) {
                const input = document.getElementById(type + 'Image');
                const preview = document.getElementById(type + 'Preview');
                const previewImg = document.getElementById(type + 'PreviewImg');

                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        previewImg.src = e.target.result;
                        preview.classList.remove('hidden');
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }

            async function analyzeFace() {
                // Check credits first
                if (!checkCredits()) {
                    return;
                }

                const imageInput = document.getElementById('faceImage');
                if (!imageInput.files || !imageInput.files[0]) {
                    alert('얼굴 사진을 업로드해주세요.');
                    return;
                }

                // Validate file type
                const file = imageInput.files[0];
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
                if (!allowedTypes.includes(file.type)) {
                    alert('JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다.');
                    return;
                }

                // Validate file size (max 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('이미지 크기는 10MB 이하여야 합니다.');
                    return;
                }

                const formData = new FormData();
                formData.append('image', file);

                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>분석 중...';
                button.disabled = true;

                try {
                    const response = await axios.post('/api/face-reading', formData, {
                        headers: {
                            'Content-Type': 'multipart/form-data'
                        }
                    });
                    const data = response.data;

                    let celebsHtml = data.celebrities.map(celeb => \`
                        <div class="celeb-card">
                            <div>
                                <div class="font-bold text-orange-800">\${celeb.name}</div>
                                <div class="text-sm text-gray-600">\${celeb.fortune}</div>
                            </div>
                            <div class="text-orange-600 font-bold">\${celeb.similarity}%</div>
                        </div>
                    \`).join('');

                    document.getElementById('faceResult').innerHTML = \`
                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">✨ 셀럽 닮은꼴 분석</h4>
                            \${celebsHtml}
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">👤 관상 분석</h4>
                            <p class="mb-3"><strong>얼굴형:</strong> \${data.faceShape}</p>
                            <div class="space-y-2">
                                <p><strong>👁️ 눈:</strong> \${data.features.eyes}</p>
                                <p><strong>👃 코:</strong> \${data.features.nose}</p>
                                <p><strong>👄 입:</strong> \${data.features.mouth}</p>
                                <p><strong>🧠 이마:</strong> \${data.features.forehead}</p>
                            </div>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🔮 운세</h4>
                            <p class="mb-2"><strong>💰 재물운:</strong> \${data.fortune.wealth}</p>
                            <p class="mb-2"><strong>💕 애정운:</strong> \${data.fortune.love}</p>
                            <p class="mb-2"><strong>💼 사업운:</strong> \${data.fortune.career}</p>
                            <p class="mb-2"><strong>🏥 건강운:</strong> \${data.fortune.health}</p>
                            <hr class="my-4">
                            <p><strong>🎨 행운의 색:</strong> \${data.luckyColor}</p>
                            <p><strong>🔢 행운의 숫자:</strong> \${data.luckyNumber}</p>
                            <p><strong>📅 행운의 요일:</strong> \${data.luckyDay}</p>
                        </div>

                        <button onclick="closeModal('face')" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition mt-4">
                            닫기
                        </button>
                    \`;
                    
                    // Use credit on success
                    useCredit();
                    
                    document.getElementById('faceContent').classList.add('hidden');
                    document.getElementById('faceResult').classList.remove('hidden');
                } catch (error) {
                    console.error('Face reading error:', error);
                    if (error.response && error.response.data && error.response.data.error) {
                        alert(error.response.data.error);
                    } else {
                        alert('분석 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                } finally {
                    // Restore button state
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }

            async function analyzePalm() {
                // Check credits first
                if (!checkCredits()) {
                    return;
                }

                const imageInput = document.getElementById('palmImage');
                if (!imageInput.files || !imageInput.files[0]) {
                    alert('손바닥 사진을 업로드해주세요.');
                    return;
                }

                // Validate file type
                const file = imageInput.files[0];
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
                if (!allowedTypes.includes(file.type)) {
                    alert('JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다.');
                    return;
                }

                // Validate file size (max 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('이미지 크기는 10MB 이하여야 합니다.');
                    return;
                }

                const formData = new FormData();
                formData.append('image', file);

                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>분석 중...';
                button.disabled = true;

                try {
                    const response = await axios.post('/api/palm-reading', formData, {
                        headers: {
                            'Content-Type': 'multipart/form-data'
                        }
                    });
                    const data = response.data;

                    let specialMarksHtml = data.specialMarks.map(mark => \`
                        <li class="flex items-start">
                            <i class="fas fa-star text-orange-600 mr-2 mt-1"></i>
                            <span>\${mark}</span>
                        </li>
                    \`).join('');

                    document.getElementById('palmResult').innerHTML = \`
                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🤚 수상 분석</h4>
                            <p class="mb-3"><strong>손 모양:</strong> \${data.handShape}</p>
                            <div class="space-y-2">
                                <p><strong>🌱 생명선:</strong> \${data.lines.lifeLine}</p>
                                <p><strong>💗 감정선:</strong> \${data.lines.heartLine}</p>
                                <p><strong>🧠 두뇌선:</strong> \${data.lines.headLine}</p>
                                <p><strong>✨ 운명선:</strong> \${data.lines.fateLine}</p>
                            </div>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🔮 운세</h4>
                            <p class="mb-2"><strong>💰 재물운:</strong> \${data.fortune.wealth}</p>
                            <p class="mb-2"><strong>💕 애정운:</strong> \${data.fortune.love}</p>
                            <p class="mb-2"><strong>💼 사업운:</strong> \${data.fortune.career}</p>
                            <p class="mb-2"><strong>🏥 건강운:</strong> \${data.fortune.health}</p>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">⭐ 특별한 표시</h4>
                            <ul class="space-y-2">
                                \${specialMarksHtml}
                            </ul>
                            <hr class="my-4">
                            <p><strong>🎂 행운의 나이:</strong> \${data.luckyAge.join('세, ')}세</p>
                        </div>

                        <button onclick="closeModal('palm')" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition mt-4">
                            닫기
                        </button>
                    \`;
                    
                    document.getElementById('palmContent').classList.add('hidden');
                    document.getElementById('palmResult').classList.remove('hidden');
                } catch (error) {
                    console.error('Palm reading error:', error);
                    if (error.response && error.response.data && error.response.data.error) {
                        alert(error.response.data.error);
                    } else {
                        alert('분석 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                } finally {
                    // Restore button state
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }

            async function analyzeSaju() {
                // Check credits first
                if (!checkCredits()) {
                    return;
                }

                const birthdate = document.getElementById('sajuBirthdate').value;
                const birthtime = document.getElementById('sajuBirthtime').value;
                const gender = document.getElementById('sajuGender').value;

                if (!birthdate) {
                    alert('생년월일을 입력해주세요.');
                    return;
                }

                const [year, month, day] = birthdate.split('-');

                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>분석 중...';
                button.disabled = true;

                try {
                    const response = await axios.post('/api/saju', {
                        year: parseInt(year),
                        month: parseInt(month),
                        day: parseInt(day),
                        hour: birthtime || null,
                        gender: gender
                    });
                    const data = response.data;

                    let strengthsHtml = data.personality.strengths.map(s => \`<span class="bg-orange-100 text-orange-800 px-3 py-1 rounded-full text-sm">\${s}</span>\`).join(' ');
                    let bestMatchHtml = data.compatibility.best_match.map(s => \`<span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm">\${s}</span>\`).join(' ');

                    document.getElementById('sajuResult').innerHTML = \`
                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🔮 사주팔자</h4>
                            <div class="grid grid-cols-2 gap-3">
                                <p><strong>년주:</strong> \${data.fourPillars.year}</p>
                                <p><strong>월주:</strong> \${data.fourPillars.month}</p>
                                <p><strong>일주:</strong> \${data.fourPillars.day}</p>
                                <p><strong>시주:</strong> \${data.fourPillars.hour}</p>
                            </div>
                            <hr class="my-4">
                            <p><strong>🌳 주요 오행:</strong> \${data.elements.primary}</p>
                            <p><strong>💧 보조 오행:</strong> \${data.elements.secondary}</p>
                            <p><strong>✨ 행운의 오행:</strong> \${data.elements.lucky}</p>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">👤 성격 분석</h4>
                            <p class="mb-3"><strong>장점:</strong></p>
                            <div class="flex flex-wrap gap-2 mb-4">
                                \${strengthsHtml}
                            </div>
                            <p><strong>💼 적합한 직업:</strong> \${data.personality.suitable}</p>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">📅 운세</h4>
                            <p class="mb-3"><strong>올해 운세:</strong><br/>\${data.fortune.this_year}</p>
                            <p class="mb-3"><strong>향후 5년:</strong><br/>\${data.fortune.next_5_years}</p>
                            <p><strong>🎯 인생 전환기:</strong> \${data.fortune.life_turning_points.join('세, ')}세</p>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">💑 궁합</h4>
                            <p class="mb-2"><strong>최고의 궁합:</strong></p>
                            <div class="flex flex-wrap gap-2 mb-3">
                                \${bestMatchHtml}
                            </div>
                            <hr class="my-3">
                            <p class="text-orange-700 font-semibold">💡 조언: \${data.advice}</p>
                        </div>

                        <button onclick="closeModal('saju')" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition mt-4">
                            닫기
                        </button>
                    \`;
                    
                    document.getElementById('sajuContent').classList.add('hidden');
                    document.getElementById('sajuResult').classList.remove('hidden');
                } catch (error) {
                    console.error('Saju analysis error:', error);
                    if (error.response && error.response.data && error.response.data.error) {
                        alert(error.response.data.error);
                    } else {
                        alert('분석 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                } finally {
                    // Restore button state
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }

            async function analyzeTarot() {
                // Check credits first
                if (!checkCredits()) {
                    return;
                }

                const question = document.getElementById('tarotQuestion').value;
                const zodiacSign = document.getElementById('zodiacSign').value;

                // Show loading state
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>분석 중...';
                button.disabled = true;

                try {
                    const [tarotResponse, zodiacResponse] = await Promise.all([
                        axios.post('/api/tarot', { question: question, spread: 'three-card' }),
                        axios.get(\`/api/zodiac/\${zodiacSign}\`)
                    ]);

                    const tarotData = tarotResponse.data;
                    const zodiacData = zodiacResponse.data;

                    let cardsHtml = tarotData.cards.map(card => \`
                        <div class="bg-white p-4 rounded-lg mb-3">
                            <div class="font-bold text-orange-800 mb-2">🃏 \${card.name} (\${card.position})</div>
                            <p class="text-gray-700 text-sm">\${card.meaning}</p>
                        </div>
                    \`).join('');

                    document.getElementById('tarotResult').innerHTML = \`
                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">🃏 타로 리딩</h4>
                            <p class="mb-4"><strong>질문:</strong> \${tarotData.question}</p>
                            \${cardsHtml}
                            <div class="bg-orange-100 p-4 rounded-lg mt-4">
                                <p class="text-orange-800 font-semibold">💫 종합 해석</p>
                                <p class="text-gray-700 mt-2">\${tarotData.overall}</p>
                            </div>
                        </div>

                        <div class="result-section">
                            <h4 class="text-xl font-bold text-orange-800 mb-4">⭐ \${zodiacData.sign} 별자리 운세</h4>
                            <p class="mb-2"><strong>📝 종합운:</strong> \${zodiacData.today.overall}</p>
                            <p class="mb-2"><strong>💕 애정운:</strong> \${zodiacData.today.love}</p>
                            <p class="mb-2"><strong>💼 직장운:</strong> \${zodiacData.today.career}</p>
                            <p class="mb-2"><strong>💰 재물운:</strong> \${zodiacData.today.wealth}</p>
                            <p class="mb-2"><strong>🏥 건강운:</strong> \${zodiacData.today.health}</p>
                            <hr class="my-4">
                            <p><strong>🎨 행운의 색:</strong> \${zodiacData.today.luckyColor}</p>
                            <p><strong>🔢 행운의 숫자:</strong> \${zodiacData.today.luckyNumber}</p>
                        </div>

                        <button onclick="closeModal('tarot')" class="w-full bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition mt-4">
                            닫기
                        </button>
                    \`;
                    
                    document.getElementById('tarotContent').classList.add('hidden');
                    document.getElementById('tarotResult').classList.remove('hidden');
                } catch (error) {
                    console.error('Tarot analysis error:', error);
                    if (error.response && error.response.data && error.response.data.error) {
                        alert(error.response.data.error);
                    } else {
                        alert('분석 중 오류가 발생했습니다. 다시 시도해주세요.');
                    }
                } finally {
                    // Restore button state
                    button.innerHTML = originalText;
                    button.disabled = false;
                }
            }
            // Platform functions
            function initPlatform() {
                const user = JSON.parse(localStorage.getItem('fortuneUser') || 'null');
                if (user) {
                    document.getElementById('authButtons').classList.add('hidden');
                    document.getElementById('userMenu').classList.remove('hidden');
                    document.getElementById('userName').textContent = user.name;
                    document.getElementById('creditDisplay').textContent = user.credits;
                } else {
                    // Give 1 free trial for non-members
                    if (!localStorage.getItem('trialUsed')) {
                        localStorage.setItem('trialCredits', '1');
                    }
                }
            }

            function register() {
                const email = document.getElementById('regEmail').value;
                const password = document.getElementById('regPassword').value;
                const name = document.getElementById('regName').value;

                if (!email || !password || !name) {
                    alert('모든 항목을 입력해주세요.');
                    return;
                }

                const user = {
                    email,
                    name,
                    plan: 'free',
                    credits: 3,
                    joined: new Date().toISOString()
                };

                localStorage.setItem('fortuneUser', JSON.stringify(user));
                closeModal('register');
                initPlatform();
                alert('회원가입이 완료되었습니다! 무료 3회 체험을 시작하세요 🎉');
            }

            function login() {
                const email = document.getElementById('loginEmail').value;
                const password = document.getElementById('loginPassword').value;

                if (!email || !password) {
                    alert('이메일과 비밀번호를 입력해주세요.');
                    return;
                }

                const user = JSON.parse(localStorage.getItem('fortuneUser') || 'null');
                if (user && user.email === email) {
                    closeModal('login');
                    initPlatform();
                    alert('로그인되었습니다!');
                } else {
                    alert('등록되지 않은 사용자입니다. 회원가입해주세요.');
                }
            }

            function logout() {
                if (confirm('로그아웃하시겠습니까?')) {
                    localStorage.removeItem('fortuneUser');
                    location.reload();
                }
            }

            function checkCredits() {
                const user = JSON.parse(localStorage.getItem('fortuneUser') || 'null');
                if (user) {
                    if (user.plan !== 'free') {
                        return true; // Unlimited for premium users
                    }
                    if (user.credits > 0) {
                        return true;
                    }
                    alert('크레딧이 부족합니다. 요금제를 업그레이드하거나 크레딧을 구매해주세요.');
                    openModal('pricing');
                    return false;
                } else {
                    const trialCredits = parseInt(localStorage.getItem('trialCredits') || '0');
                    if (trialCredits > 0) {
                        return true;
                    }
                    alert('체험 기회를 모두 사용했습니다. 회원가입하고 무료 3회를 더 받으세요!');
                    openModal('register');
                    return false;
                }
            }

            function useCredit() {
                const user = JSON.parse(localStorage.getItem('fortuneUser') || 'null');
                if (user && user.plan === 'free') {
                    user.credits--;
                    localStorage.setItem('fortuneUser', JSON.stringify(user));
                    document.getElementById('creditDisplay').textContent = user.credits;
                } else if (!user) {
                    const trialCredits = parseInt(localStorage.getItem('trialCredits') || '0');
                    localStorage.setItem('trialCredits', (trialCredits - 1).toString());
                }
            }

            // Initialize platform on load
            window.addEventListener('DOMContentLoaded', initPlatform);
        </script>
    </body>
    </html>
  `)
})

export default app
