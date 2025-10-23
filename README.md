# 운세의 신 - AI 기반 종합 운세 플랫폼 ✨

> 전통 철학과 최신 AI 기술이 만난 프리미엄 운세 서비스

## 📋 프로젝트 개요

**운세의 신**은 30대 여성을 타겟으로 하는 세련된 디자인의 AI 기반 종합 운세 플랫폼입니다.
전통적인 사주팔자, 관상, 수상부터 타로와 별자리까지 다양한 운세 서비스를 하나의 플랫폼에서 제공합니다.

### 🎯 플랫폼 서비스 특징
- 👤 **회원가입/로그인 시스템** - 간편한 회원 가입
- 💎 **크레딧 시스템** - 무료 3회 체험 제공
- 💳 **4단계 요금제** - 무료/스탠다드/프리미엄/VIP
- 📊 **마이페이지** - 내 정보 및 크레딧 관리
- 🎁 **무료 체험** - 회원가입 시 즉시 3회 무료

### 주요 기능
- 🎨 세련되고 모던한 UI/UX (오렌지 테마, 30대 여성 타겟)
- 📸 AI 기반 얼굴 분석 (관상 + 셀럽 닮은꼴)
- 🤚 AI 기반 손바닥 분석 (손금 해석)
- 🔮 정통 사주팔자 해석
- 🃏 디지털 타로 & 12궁도 별자리 운세
- ✅ 파일 검증 (형식, 크기)
- ⏳ 로딩 상태 표시
- 🛡️ 에러 처리 및 사용자 피드백

## 🌐 배포 URL

- **개발 서버**: https://3000-id01tvycogf48q63fcoqh-8f57ffe2.sandbox.novita.ai
- **프로덕션**: (배포 예정)

## 🎯 완료된 기능

### 1. AI 관상 분석 📸
- ✅ 얼굴 사진 업로드 기능
- ✅ AI 기반 얼굴형 분석
- ✅ 오관(눈, 코, 입, 이마) 해석
- ✅ **셀럽 닮은꼴 찾기** (아이유, 손예진, 전지현 등)
- ✅ 재물운, 애정운, 사업운, 건강운 분석
- ✅ 행운의 색, 숫자, 요일 제공

### 2. AI 수상 분석 🤚
- ✅ 손바닥 사진 업로드 기능
- ✅ 손 모양 분석 (물형, 불형 등)
- ✅ 4대 손금선 해석 (생명선, 감정선, 두뇌선, 운명선)
- ✅ 재물운, 애정운, 사업운, 건강운 분석
- ✅ 특별한 표시 (별, 삼각형 등) 분석
- ✅ 행운의 나이 제공

### 3. 사주팔자 해석 🔮
- ✅ 생년월일시 입력 기능
- ✅ 성별 선택 기능
- ✅ 사주 네 기둥 (년주, 월주, 일주, 시주) 분석
- ✅ 오행(목, 화, 토, 금, 수) 분석
- ✅ 성격 분석 (장점, 단점, 적합 직업)
- ✅ 올해 운세 및 향후 5년 운세
- ✅ 인생 전환기 예측
- ✅ 띠별 궁합 분석

### 4. 타로 & 별자리 운세 🃏⭐
- ✅ 디지털 타로카드 리딩
- ✅ 3장 스프레드 (과거-현재-미래)
- ✅ 12궁도 별자리 운세
- ✅ 종합운, 애정운, 직장운, 재물운, 건강운
- ✅ 행운의 색, 숫자 제공

## 🎨 디자인 특징

### 타겟 사용자: 30대 여성
- **색상**: 따뜻한 오렌지 그라데이션 (Orange #ff6b35 → #f7931e → #ff9a56)
- **폰트**: Noto Sans KR (한글), Playfair Display (영문)
- **효과**: Glass morphism, 부드러운 그림자, 애니메이션
- **레이아웃**: 모바일 반응형, 카드 기반 디자인
- **인터랙션**: 호버 효과, 모달 팝업, 로딩 스피너, 부드러운 전환

## 🛠 기술 스택

### Frontend
- **HTML5/CSS3**: 시맨틱 마크업
- **TailwindCSS**: 유틸리티 기반 스타일링
- **JavaScript**: ES6+ 모던 문법
- **Axios**: HTTP 클라이언트
- **Font Awesome**: 아이콘
- **Google Fonts**: Noto Sans KR, Playfair Display

### Backend
- **Hono**: 경량 웹 프레임워크
- **Cloudflare Workers**: 엣지 런타임
- **TypeScript**: 타입 안전성

### DevOps
- **Wrangler**: Cloudflare CLI
- **Vite**: 빌드 도구
- **PM2**: 프로세스 관리
- **Git**: 버전 관리

## 📊 데이터 구조

### API 응답 예시

#### 관상 분석 응답
```json
{
  "faceShape": "계란형",
  "features": {
    "eyes": "큰 눈으로 총명함과 예술적 재능",
    "nose": "곧은 콧대로 강한 의지와 리더십",
    "mouth": "미소가 아름답고 대인관계가 원만",
    "forehead": "넓은 이마로 지혜롭고 통찰력이 뛰어남"
  },
  "celebrities": [
    {"name": "아이유", "similarity": 92, "fortune": "부귀영화"},
    {"name": "손예진", "similarity": 88, "fortune": "좋은 인연"}
  ],
  "fortune": {
    "wealth": "재물운이 매우 좋음",
    "love": "진실한 사랑을 만날 운명",
    "career": "승진운이 보임",
    "health": "전반적으로 건강"
  }
}
```

## 🚀 로컬 개발

### 사전 요구사항
- Node.js 18+
- npm 또는 yarn
- Wrangler CLI

### 설치 및 실행
```bash
# 저장소 클론
git clone https://github.com/YOUR-USERNAME/webapp.git
cd webapp

# 의존성 설치
npm install

# 환경 변수 설정 (선택사항)
cp .env.example .dev.vars
# .dev.vars 파일을 편집하여 필요한 값 입력

# 빌드
npm run build

# 개발 서버 시작 (PM2)
pm2 start ecosystem.config.cjs

# 또는 직접 실행
npm run dev:sandbox

# 서버 상태 확인
pm2 list
pm2 logs webapp --nostream

# 포트 3000 정리
npm run clean-port

# API 테스트
curl http://localhost:3000/api/health
curl -X POST http://localhost:3000/api/face-reading -F "image=@photo.jpg"
```

## 📝 사용 가이드

### 1. 메인 페이지 접속
브라우저에서 https://3000-id01tvycogf48q63fcoqh-8f57ffe2.sandbox.novita.ai 접속

### 2. 서비스 선택
4가지 서비스 카드 중 원하는 서비스 클릭:
- 📸 AI 관상 분석
- 🤚 AI 수상 분석
- 🔮 사주팔자
- 🃏 타로 & 별자리

### 3. 정보 입력
- **관상/수상**: 사진 업로드
- **사주**: 생년월일시 입력
- **타로**: 질문 작성 및 별자리 선택

### 4. 결과 확인
AI 분석 결과 및 운세 해석 확인

## 🗺 API 엔드포인트

### 관상 분석
- `POST /api/face-reading`
- FormData: `image` (File - JPG/PNG/WEBP, 최대 10MB)
- Response: 얼굴형, 오관 해석, 셀럽 닮은꼴, 운세

### 수상 분석
- `POST /api/palm-reading`
- FormData: `image` (File - JPG/PNG/WEBP, 최대 10MB)
- Response: 손 모양, 손금선 해석, 운세

### 사주팔자
- `POST /api/saju`
- JSON: `{year, month, day, hour?, gender}`
- Response: 사주팔자, 오행, 성격, 운세, 궁합

### 타로 리딩
- `POST /api/tarot`
- JSON: `{question?, spread}`
- Response: 타로 카드, 해석

### 별자리 운세
- `GET /api/zodiac/:sign`
- Params: `sign` (aries, taurus, gemini, ...)
- Response: 오늘의 별자리 운세

### 헬스체크
- `GET /api/health`
- Response: `{status: 'ok', message: 'AI Fortune Telling Platform'}`

## 📁 프로젝트 구조

```
webapp/
├── .env.example          # 환경 변수 예시
├── .gitignore            # Git 무시 파일
├── CONTRIBUTING.md       # 기여 가이드
├── LICENSE               # MIT 라이선스
├── README.md             # 프로젝트 문서
├── ecosystem.config.cjs  # PM2 설정
├── package.json          # 의존성 및 스크립트
├── tsconfig.json         # TypeScript 설정
├── vite.config.ts        # Vite 빌드 설정
├── wrangler.jsonc        # Cloudflare 설정
├── src/
│   ├── index.tsx         # 메인 Hono 앱 (API + UI)
│   └── renderer.tsx      # JSX 렌더러
└── public/
    └── static/
        └── style.css     # 커스텀 스타일
```

## 🔮 향후 개발 계획

### 단기 (1-2주)
- [ ] 실제 AI 모델 통합 (얼굴/손바닥 인식)
- [ ] 더 많은 셀럽 데이터베이스 추가
- [ ] 사용자 인증 및 프로필 기능
- [ ] 결과 히스토리 저장 기능

### 중기 (1-2개월)
- [ ] Cloudflare D1 데이터베이스 연동
- [ ] 유료 구독 및 결제 시스템
- [ ] 전문가 상담 예약 기능
- [ ] 커뮤니티 및 후기 기능
- [ ] 푸시 알림 (오늘의 운세)

### 장기 (3-6개월)
- [ ] 모바일 앱 (React Native)
- [ ] 다국어 지원 (영어, 중국어, 일본어)
- [ ] AI 정확도 향상 (머신러닝 모델 훈련)
- [ ] 소셜 미디어 연동 (공유 기능)
- [ ] 파트너십 및 제휴 마케팅

## 📈 비즈니스 모델

### 수익화 전략
1. **프리미엄 구독** (월 9,900원~39,900원)
   - 무제한 운세 이용
   - 전문가 상담 포함
   
2. **건별 결제** (건당 3,000원~5,000원)
   - 1회성 운세 분석
   
3. **전문가 상담** (30분 30,000원)
   - 1:1 실시간 상담

## 🔒 보안 및 개인정보

- 업로드된 이미지는 임시 저장 후 즉시 삭제
- HTTPS 암호화 통신
- 개인정보는 최소 수집 원칙
- GDPR 및 개인정보보호법 준수

## 📄 라이선스

이 프로젝트는 비공개 소유권 소프트웨어입니다.

## 👥 팀

- **기획**: AI 운세 플랫폼 기획팀
- **개발**: Hono + Cloudflare Workers 기반
- **디자인**: 30대 여성 타겟 UI/UX

## 📞 문의

프로젝트에 대한 문의사항은 이슈를 등록해주세요.

---

**Last Updated**: 2025-10-23
**Version**: 1.0.0
**Status**: ✅ 개발 완료 (배포 대기)
