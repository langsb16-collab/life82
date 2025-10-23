# 기여 가이드

운세의 신 프로젝트에 기여해 주셔서 감사합니다! 🙏

## 개발 환경 설정

### 필수 요구사항
- Node.js 18 이상
- npm 또는 yarn
- Wrangler CLI

### 설치 방법

```bash
# 저장소 클론
git clone https://github.com/YOUR-USERNAME/webapp.git
cd webapp

# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .dev.vars
# .dev.vars 파일을 편집하여 필요한 값 입력

# 빌드
npm run build

# 개발 서버 실행
npm run dev:sandbox
```

## 개발 워크플로우

### 브랜치 전략
- `main`: 프로덕션 브랜치
- `develop`: 개발 브랜치
- `feature/*`: 새 기능 개발
- `bugfix/*`: 버그 수정
- `hotfix/*`: 긴급 수정

### 커밋 메시지 규칙
```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 변경
style: 코드 포맷팅, 세미콜론 누락 등
refactor: 코드 리팩토링
test: 테스트 추가
chore: 빌드 작업, 패키지 매니저 설정 등
```

### Pull Request 절차

1. Fork 후 브랜치 생성
```bash
git checkout -b feature/my-feature
```

2. 변경사항 커밋
```bash
git add .
git commit -m "feat: add new feature"
```

3. 푸시 및 PR 생성
```bash
git push origin feature/my-feature
```

4. GitHub에서 Pull Request 생성

## 코드 스타일

- TypeScript 사용
- TailwindCSS를 이용한 스타일링
- ESLint 규칙 준수
- 의미있는 변수명 사용

## 테스트

```bash
# API 테스트
npm run test
curl http://localhost:3000/api/health
```

## 문의

이슈나 질문이 있으시면 GitHub Issues를 이용해주세요.
