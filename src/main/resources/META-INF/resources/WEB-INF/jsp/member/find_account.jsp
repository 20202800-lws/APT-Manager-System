<!-- 아이디/비밀번호 찾기(추가됨!) -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 | APARTNERS</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/member_find.css">
</head>
<body>

    <jsp:include page="../layout/header_auth.jsp" />

    

<div class="find-wrapper">
    <h1 class="find-title" id="find-title">아이디 찾기</h1>

    <div class="tab-menu" id="tab-menu">
        <div class="tab-btn active" onclick="openTab(event, 'id-find')">아이디 찾기</div>
        <div class="tab-btn" onclick="openTab(event, 'pw-find')">비밀번호 찾기</div>
    </div>

    <div id="id-find" class="find-content active">
        <div id="id-input-step">
            <div class="input-group"><input type="text" id="find-name" placeholder="이름" required></div>
            <div class="input-group"><input type="text" id="find-phone" placeholder="휴대폰 번호 (- 제외)" required></div>
            <div class="btn-area">
                <button class="btn-action" onclick="handleFindID()">아이디 찾기</button>
                <a href="login" class="btn-back">로그인</a>
              <a href="join" class="btn-back">회원가입</a>
            </div>
        </div>
        
        <div id="id-result-area" class="result-box">
            <p style="color:#666;">일치하는 아이디입니다.</p>
            <div class="result-id" id="display-id"></div>
            <div class="btn-area">
                <a href="login.jsp" class="btn-action" style="display:flex; align-items:center; justify-content:center; text-decoration:none;">로그인하기</a>
            </div>
        </div>
    </div>

    <div id="pw-find" class="find-content">
        <div id="pw-info-step">
            <div class="input-group"><input type="text" id="reset-id" placeholder="아이디" required></div>
            <div class="input-group"><input type="text" id="reset-name" placeholder="이름" required></div>
            <div class="input-group"><input type="text" id="reset-phone" placeholder="휴대폰 번호 (- 제외)" required></div>
            <div class="btn-area">
                <button class="btn-action" onclick="handleResetPWStep1()">비밀번호 재설정</button>
                <a href="login.jsp" class="btn-back">로그인</a>
            </div>
        </div>

        <div id="pw-reset-step">
            <p style="margin-bottom:15px; font-weight:600; color:var(--text-gray); text-align:center;">새로운 비밀번호를 입력해주세요.</p>
            <div class="input-group"><input type="password" id="new-pw" placeholder="새 비밀번호"></div>
            <div class="input-group"><input type="password" id="confirm-pw" placeholder="새 비밀번호 확인"></div>
            <div class="btn-area">
                <button class="btn-action" onclick="handleFinalReset()">변경 완료</button>
            </div>
        </div>
    </div>
</div>
 <jsp:include page="../layout/footer.jsp" />
    <script src="/js/member.js"></script>
    
</body>
</html>
