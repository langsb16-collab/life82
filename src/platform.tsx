// Platform utility functions and middleware
import { sign, verify } from 'hono/jwt'
import { getCookie, setCookie } from 'hono/cookie'

export type Bindings = {
  DB: D1Database
  JWT_SECRET: string
}

export async function hashPassword(password: string): Promise<string> {
  const encoder = new TextEncoder()
  const data = encoder.encode(password)
  const hash = await crypto.subtle.digest('SHA-256', data)
  return Array.from(new Uint8Array(hash))
    .map(b => b.toString(16).padStart(2, '0'))
    .join('')
}

export async function createSession(db: D1Database, userId: number, jwtSecret: string): Promise<string> {
  const token = await sign({ userId, exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 7 }, jwtSecret)
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString()
  
  await db.prepare('INSERT INTO sessions (user_id, token, expires_at) VALUES (?, ?, ?)')
    .bind(userId, token, expiresAt)
    .run()
  
  return token
}

export async function getUser(c: any): Promise<any> {
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

export async function authMiddleware(c: any, next: any) {
  const user = await getUser(c)
  if (!user) {
    return c.json({ error: '로그인이 필요합니다.' }, 401)
  }
  c.set('user', user)
  await next()
}

export async function saveReading(
  db: D1Database,
  userId: number,
  readingType: string,
  inputData: any,
  resultData: any,
  creditsUsed: number = 1
) {
  await db.prepare(
    'INSERT INTO readings (user_id, reading_type, input_data, result_data, credits_used) VALUES (?, ?, ?, ?, ?)'
  ).bind(userId, readingType, JSON.stringify(inputData), JSON.stringify(resultData), creditsUsed).run()
}

export async function deductCredit(db: D1Database, userId: number, plan: string) {
  if (plan === 'free') {
    await db.prepare('UPDATE users SET credits = credits - 1 WHERE id = ?')
      .bind(userId).run()
  }
}
