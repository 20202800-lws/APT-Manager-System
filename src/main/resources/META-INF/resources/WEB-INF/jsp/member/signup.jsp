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
                    <input type="password" id="pw2" name="userPwCheck" placeholder="비밀번호 확인" required>
                    <span class="error-msg" id="pwMsg" style="display:block; margin-top:5px; font-size:13px;"></span>
                </div>

                <label class="input-label">성함</label>
                <div class="input-group">
                    <input type="text" id="userName" name="userName" placeholder="실명 입력" required>
                </div>

                <label class="input-label">주민등록번호 앞자리 / 성별코드</label>
                <div class="input-flex">
                    <input type="text" id="birthDate" name="birthDate" placeholder="생년월일 6자리 (예: 990101)" 
                           maxlength="6" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    <span>-</span>
                    <div style="flex: 1;"> 
                        <select id="genderDigit" name="genderDigit" required>
                            <option value="">선택</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                        </select>
                    </div>
                    <input type="text" value="******" disabled style="background-color: #f5f5f5; text-align: center; color: #999; border:none;">
                </div>

                <label class="input-label">이메일 <span style="font-size: 12px; color: #888; font-weight: normal;">(선택)</span></label>
                <div class="input-group">
                    <input type="email" id="emailInput" name="email" placeholder="example@naver.com">
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
            // 1. 비밀번호 강도 검사
            const pw1 = document.getElementById('pw1').value;
            const pw2 = document.getElementById('pw2').value;
            const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&~^])[A-Za-z\d@$!%*#?&~^]{8,}$/;
            const pwMsg = document.getElementById('pwMsg');
            
            if(!pwRegex.test(pw1)) {
                alert("비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.");
                document.getElementById('pw1').focus();
                return false;
            }

            // 2. 비밀번호 일치 여부 검사
            if(pw1 !== pw2) {
                pwMsg.innerText = "비밀번호가 일치하지 않습니다.";
                pwMsg.style.color = "red";
                document.getElementById('pw2').focus();
                return false;
            } else {
                pwMsg.innerText = "";
            }

            // 3. 이메일 정규식 검사 (입력된 경우에만 검사!)
            const emailInput = document.getElementById('emailInput').value;
            const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.(com|net|org|kr|co\.kr|go\.kr|ac\.kr)$/i;
            if(emailInput && !emailRegex.test(emailInput)) {
                alert("유효하지 않은 이메일 형식입니다.\n(예: example@naver.com)");
                document.getElementById('emailInput').focus();
                return false;
            }

            // 4. 분할된 전화번호 하나로 합치기
            const p1 = document.getElementById('phone1').value;
            const p2 = document.getElementById('phone2').value;
            const p3 = document.getElementById('phone3').value;
            
            if(p1.length < 3 || p2.length < 3 || p3.length < 4) {
                alert("올바른 휴대전화 번호를 모두 입력해주세요.");
                return false;
            }
            
            // 합친 번호를 hidden input(fullPhone)에 꽂아 넣고 서버로 전송!
            document.getElementById('fullPhone').value = p1 + "-" + p2 + "-" + p3;

            return true; // 모든 관문을 통과하면 전송!
        }
    </script>
</body>
</html>