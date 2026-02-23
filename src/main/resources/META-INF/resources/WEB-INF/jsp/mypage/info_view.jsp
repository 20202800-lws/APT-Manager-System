<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 내 정보</title>
    
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/mypage.css'/>">
</head>
<body>

    <jsp:include page="../layout/header_intro.jsp">
        <jsp:param name="pageTitle" value="마이페이지" />
    </jsp:include>

    <main class="container">
        
        <jsp:include page="../layout/sidebar_mypage.jsp">
            <jsp:param name="activeMenu" value="info_view" />
        </jsp:include>

        <section style="position: relative; flex: 1;">
            <div class="info-card">
                <div class="profile-img-area">
                    <img src="https://i.imgur.com/81bee8.jpg" onerror="this.src='https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=300&q=80'" alt="프로필">
                </div>

                <div class="info-details">
                    <h3>내 정보</h3>
                    <div class="info-row"><div class="info-label">아이디</div><div class="info-value">${userInfo.userId}</div></div>
                    <div class="info-row"><div class="info-label">단지명</div><div class="info-value">${not empty userInfo.aptName ? userInfo.aptName : '원소집합'}</div></div>
                    <div class="info-row"><div class="info-label">동 / 호수</div><div class="info-value">${userInfo.dong}동 ${userInfo.ho}호</div></div>
                    <div class="info-row"><div class="info-label">타입</div><div class="info-value">${userInfo.houseType}</div></div>
                    <div class="info-row"><div class="info-label">이름</div><div class="info-value">${userInfo.userName}</div></div>
                    <div class="info-row"><div class="info-label">전화번호</div><div class="info-value">${userInfo.phone}</div></div>
                    <div class="info-row"><div class="info-label">이메일</div><div class="info-value">${userInfo.email}</div></div>
                </div>

                <div class="settings-area">
                    <h4>알림 설정</h4>
                    <div class="toggle-row">
                        <span class="toggle-label">이메일 알림</span>
                        <label class="switch">
                            <input type="checkbox" ${userInfo.emailAlert == 'Y' ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div class="toggle-row">
                        <span class="toggle-label">문자 알림</span>
                        <label class="switch">
                            <input type="checkbox" ${userInfo.smsAlert == 'Y' ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div class="toggle-row">
                        <span class="toggle-label">커뮤니티 알림</span>
                        <label class="switch">
                            <input type="checkbox" ${userInfo.commAlert == 'Y' ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div class="toggle-row">
                        <span class="toggle-label">댓글 알림</span>
                        <label class="switch">
                            <input type="checkbox" ${userInfo.replyAlert == 'Y' ? 'checked' : ''}>
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                <button type="button" class="btn-withdraw" id="withdrawBtn">회원 탈퇴</button>
            </div>
        </section>
    </main>
    
    <jsp:include page="../layout/footer.jsp" />
    
    <script src="<c:url value='/js/mypage.js'/>"></script>

</body>
</html>