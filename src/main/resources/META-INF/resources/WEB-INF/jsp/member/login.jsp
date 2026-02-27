<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 | APARTNERS</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/member.css">
</head>
<body>

    <jsp:include page="../layout/header_auth.jsp" />

    <div class="login-container">
        
        <div class="login-box">
            <div class="login-header">
                <h2>로그인</h2>
                <p>입주민 전용 서비스를 위해 로그인해주세요.</p>
            </div>

            <form id="loginForm" action="/member/login" method="post">
				<input type="hidden" id="serverMsg" value="${param.msg != null ? param.msg : msg}">
				
                <div class="input-group">
                    <input type="text" id="userId" name="userId" placeholder="아이디" required>
                </div>
                <div class="input-group">
                    <input type="password" id="userPw" name="userPw" placeholder="비밀번호" required>
                </div>
                
				<div class="find-links">
				    <a href="/member/find_account?tab=id">아이디 찾기</a>
				    <span>|</span>
				    <a href="/member/find_account?tab=pw">비밀번호 찾기</a>
				</div>

                <div class="btn-area">
                    <button type="submit" class="btn-login">로그인</button>
                    <a href="/member/signup" class="btn-join">회원가입</a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="/js/common.js"></script>
    <script src="/js/member.js"></script>
    
</body>
</html>