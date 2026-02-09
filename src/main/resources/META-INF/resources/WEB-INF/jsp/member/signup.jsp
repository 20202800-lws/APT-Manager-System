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

            <form id="signupForm" action="/member/signup" method="post">
                
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

                <label class="input-label">휴대전화</label>
                <div class="input-flex phone-group">
                    <input type="text" name="phone1" maxlength="3" placeholder="010" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    <span>-</span>
                    <input type="text" name="phone2" maxlength="4" placeholder="0000" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    <span>-</span>
                    <input type="text" name="phone3" maxlength="4" placeholder="0000" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
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
</body>
</html>