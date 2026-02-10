<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 | APARTNERS</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/member.css">
    <style>
        /* select 태그도 input과 똑같은 스타일 적용을 위해 추가 */
        select {
            width: 100%;
            height: 50px; /* 기존 input 높이에 맞춤 (확인 필요) */
            padding: 0 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-family: 'Pretendard', sans-serif;
            font-size: 15px;
            color: #333;
            background-color: #fff;
            appearance: none; /* 브라우저 기본 화살표 제거 (선택사항) */
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px;
        }
    </style>
</head>
<body>

    <jsp:include page="../layout/header_auth.jsp" />

    <div class="login-container">
        <div class="login-box signup-box-width">
            <div class="login-header">
                <h2>회원가입</h2>
                <p>아파트너스 입주민 전용 관리서비스를 이용하실 수 있습니다</p>
            </div>

            <form id="signupForm" action="/member/signup" method="post" onsubmit="return handleSignupSubmit()">
                
                <label class="input-label">아이디</label>
                <div class="input-flex">
                    <input type="text" id="userId" name="userId" placeholder="아이디 입력" required>
                    <button type="button" class="btn-check" onclick="checkId()">중복확인</button>
                </div>

                <label class="input-label">비밀번호</label>
                <div class="input-group">
                    <input type="password" id="pw1" name="userPw" placeholder="8자 이상, 숫자/특수문자 포함" required>
                </div>
                <div class="input-group">
                    <input type="password" id="pw2" placeholder="비밀번호 확인" required>
                    <span class="error-msg" id="pwMsg"></span>
                </div>

                <label class="input-label">성함</label>
                <div class="input-group">
                    <input type="text" id="userName" name="userName" placeholder="실명 입력" required>
                </div>

                <label class="input-label">생년월일 / 성별코드</label>
                <div class="input-flex">
                    <input type="text" id="birthDate" name="birthDate" placeholder="생년월일 6자리 (예: 990101)" 
                           maxlength="6" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    
                    <span>-</span>
                    
                    <div style="flex: 1;"> <select id="genderDigit" name="genderDigit" required>
                            <option value="">선택</option>
                            <option value="1">1 (남성)</option>
                            <option value="2">2 (여성)</option>
                            <option value="3">3 (2000년생~ 남성)</option>
                            <option value="4">4 (2000년생~ 여성)</option>
                        </select>
                    </div>
                    
                    <input type="text" value="******" disabled style="background-color: #f5f5f5; text-align: center; color: #999; border:none;">
                </div>

                <label class="input-label">이메일</label>
                <div class="input-group">
                    <input type="email" name="email" placeholder="example@apt.com (선택)">
                </div>

                <label class="input-label">휴대전화</label>
                <div class="input-flex phone-group">
                    <input type="text" id="phone1" maxlength="3" placeholder="010" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    <span>-</span>
                    <input type="text" id="phone2" maxlength="4" placeholder="0000" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    <span>-</span>
                    <input type="text" id="phone3" maxlength="4" placeholder="0000" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    
                    <input type="hidden" id="fullPhone" name="phone">
                </div>

                <label class="input-label">동 / 호수</label>
                <div class="input-flex">
                    <input type="text" name="dong" placeholder="동 (예: 101)" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    <input type="text" name="ho" placeholder="호 (예: 502)" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                </div>
                
                <p class="info-text">※ 실거주 확인을 위해 최대 7일까지 시간이 소요될 수 있습니다.</p>

                <div class="agree-box">
                    <input type="checkbox" id="agree" name="agree" required>
                    <label for="agree">이용약관 및 개인정보 수집 이용에 동의합니다. (필수)</label>
                </div>

                <div class="btn-area">
                    <button type="submit" class="btn-login">회원가입 신청하기</button>
                    <a href="/member/login" class="btn-join">취소</a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="/js/common.js"></script>
    <script src="/js/member.js"></script>
    
    <script>
        function handleSignupSubmit() {
            // 1. 휴대전화 합치기 (010 + 1234 + 5678 => 010-1234-5678)
            const p1 = document.getElementById("phone1").value;
            const p2 = document.getElementById("phone2").value;
            const p3 = document.getElementById("phone3").value;
            
            if(!p1 || !p2 || !p3) {
                alert("휴대전화 번호를 모두 입력해주세요.");
                return false;
            }
            
            // hidden input에 값 넣기
            document.getElementById("fullPhone").value = p1 + "-" + p2 + "-" + p3;

            // 2. 생년월일 검증
            const birth = document.getElementById("birthDate").value;
            if(birth.length !== 6) {
                alert("생년월일 6자리를 정확히 입력해주세요.");
                return false;
            }
            
            // 3. 비밀번호 일치 확인 (기존 member.js에 있을 수 있음)
            const pw1 = document.getElementById("pw1").value;
            const pw2 = document.getElementById("pw2").value;
            if(pw1 !== pw2) {
                alert("비밀번호가 일치하지 않습니다.");
                return false;
            }

            return true; // 전송 진행
        }
    </script>
</body>
</html>