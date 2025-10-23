# 테스트 가이드

## 📸 사진 업로드 기능 테스트

### 준비물
- 테스트용 얼굴 사진 (JPG, PNG, WEBP 형식)
- 테스트용 손바닥 사진 (JPG, PNG, WEBP 형식)

### 테스트 절차

#### 1. 서버 실행 확인
```bash
# 서버 상태 확인
pm2 list

# 로그 확인
pm2 logs webapp --nostream

# API 헬스체크
curl http://localhost:3000/api/health
```

#### 2. 브라우저에서 테스트
1. 브라우저에서 접속: https://3000-id01tvycogf48q63fcoqh-8f57ffe2.sandbox.novita.ai
2. "AI 관상" 카드 클릭
3. 얼굴 사진 업로드
4. "AI 관상 분석 시작" 버튼 클릭
5. 결과 확인

#### 3. CLI에서 API 테스트
```bash
# 관상 분석 테스트
curl -X POST http://localhost:3000/api/face-reading \
  -F "image=@/path/to/face.jpg" \
  -H "Content-Type: multipart/form-data"

# 수상 분석 테스트
curl -X POST http://localhost:3000/api/palm-reading \
  -F "image=@/path/to/palm.jpg" \
  -H "Content-Type: multipart/form-data"

# 사주팔자 테스트
curl -X POST http://localhost:3000/api/saju \
  -H "Content-Type: application/json" \
  -d '{"year":1990,"month":5,"day":15,"hour":"12:00","gender":"female"}'

# 타로 & 별자리 테스트
curl -X POST http://localhost:3000/api/tarot \
  -H "Content-Type: application/json" \
  -d '{"question":"오늘의 운세","spread":"three-card"}'

curl http://localhost:3000/api/zodiac/leo
```

### 예상 결과

#### ✅ 정상 작동 시
- 사진 미리보기가 표시됨
- 로딩 스피너가 표시됨 (분석 중...)
- 결과 화면이 표시됨
  - 셀럽 닮은꼴 분석 (이름, 유사도, 운)
  - 관상 분석 (얼굴형, 오관 해석)
  - 운세 (재물운, 애정운, 사업운, 건강운)

#### ❌ 에러 발생 시
- 파일이 없을 때: "이미지를 업로드해주세요."
- 잘못된 형식: "JPG, PNG, WEBP 형식의 이미지만 업로드 가능합니다."
- 파일이 너무 클 때: "이미지 크기는 10MB 이하여야 합니다."

### 파일 검증 기능

#### 지원 형식
- ✅ JPEG (.jpg, .jpeg)
- ✅ PNG (.png)
- ✅ WEBP (.webp)
- ❌ GIF (.gif) - 지원하지 않음
- ❌ BMP (.bmp) - 지원하지 않음

#### 파일 크기 제한
- 최대: 10MB
- 권장: 1-3MB

### 브라우저 콘솔 확인

F12 키를 눌러 개발자 도구를 열고 Console 탭에서 다음 로그를 확인:

```
Face image uploaded: photo.jpg, 524288 bytes, image/jpeg
```

### 네트워크 탭 확인

1. F12 → Network 탭
2. 사진 업로드 후 "face-reading" 또는 "palm-reading" 요청 확인
3. Request Headers: `Content-Type: multipart/form-data`
4. Response: JSON 형식의 분석 결과

### 문제 해결

#### 사진이 업로드되지 않을 때
1. 파일 형식 확인 (JPG, PNG, WEBP만 가능)
2. 파일 크기 확인 (10MB 이하)
3. 브라우저 콘솔에서 에러 메시지 확인
4. 서버 로그 확인: `pm2 logs webapp --nostream`

#### 분석 결과가 표시되지 않을 때
1. 네트워크 탭에서 API 응답 확인
2. 서버 로그 확인
3. 브라우저 새로고침 후 재시도

#### 서버가 응답하지 않을 때
```bash
# 서버 재시작
pm2 restart webapp

# 포트 확인
netstat -tulpn | grep 3000

# 강제 종료 후 재시작
fuser -k 3000/tcp
pm2 delete webapp
npm run build
pm2 start ecosystem.config.cjs
```

## 🧪 자동화된 테스트 (향후 추가 예정)

```bash
# Unit Tests
npm run test:unit

# Integration Tests
npm run test:api

# E2E Tests
npm run test:e2e
```

## 📊 성능 테스트

### 응답 시간 측정
```bash
# 헬스체크
time curl http://localhost:3000/api/health

# 사주팔자 분석
time curl -X POST http://localhost:3000/api/saju \
  -H "Content-Type: application/json" \
  -d '{"year":1990,"month":5,"day":15,"gender":"female"}'
```

### 예상 응답 시간
- 헬스체크: < 10ms
- 사주팔자: < 100ms
- 관상 분석: < 500ms (현재는 시뮬레이션)
- 수상 분석: < 500ms (현재는 시뮬레이션)

## 🔐 보안 테스트

### 파일 업로드 보안
```bash
# 큰 파일 테스트 (거부되어야 함)
dd if=/dev/zero of=large.jpg bs=1M count=15
curl -X POST http://localhost:3000/api/face-reading -F "image=@large.jpg"

# 잘못된 형식 테스트 (거부되어야 함)
curl -X POST http://localhost:3000/api/face-reading -F "image=@file.txt"
```

### XSS 테스트
```bash
# 악의적인 입력 테스트
curl -X POST http://localhost:3000/api/tarot \
  -H "Content-Type: application/json" \
  -d '{"question":"<script>alert(\"XSS\")</script>"}'
```

## 📱 모바일 테스트

1. 모바일 기기에서 접속
2. 터치 인터랙션 테스트
3. 파일 선택 (카메라/갤러리)
4. 반응형 레이아웃 확인

## ✅ 체크리스트

- [ ] 서버 정상 실행
- [ ] 메인 페이지 로딩
- [ ] 관상 분석 사진 업로드
- [ ] 수상 분석 사진 업로드
- [ ] 사주팔자 입력 및 분석
- [ ] 타로 & 별자리 분석
- [ ] 에러 처리 확인
- [ ] 로딩 상태 표시 확인
- [ ] 모바일 반응형 확인
- [ ] API 응답 시간 확인

---

**테스트 완료 후**: GitHub Issues에 버그 리포트 또는 개선 제안을 작성해주세요.
