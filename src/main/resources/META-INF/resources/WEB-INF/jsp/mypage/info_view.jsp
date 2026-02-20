<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 내 정보</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
	<link rel="stylesheet" href="/css/layout.css">
	 <link rel="stylesheet" href="/css/mypage.css">
		
	</head>

	<body>
	  			 <!--header sub로 바꾸기!(이미지도 완성되면)-->
		<jsp:include page="../layout/header_auth.jsp" />

<main class="container">
	<aside class="sidebar">
	    <h2>마이페이지</h2>
	    <nav class="menu-list">
	        <button type="button" class="menu-item active" onclick="changeMenu(this, 'info_view')">내 정보</button>
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'info_edit')">정보 수정</button>
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'fee_view')">관리비</button>
	        
	        <div class="dropdown-grp">
	            <div class="menu-item">활동 내역 ▾</div>
	            <div class="sub-menu-side">
	                <button type="button" class="sub-item" onclick="changeMenu(this, 'act_reply')">내가 쓴 댓글</button>
	                <button type="button" class="sub-item" onclick="changeMenu(this, 'act_posts')">내가 쓴 게시물</button>
	            </div>
	        </div>
	    </nav>
	</aside>

    <section style="position: relative; flex: 1;">
        <div class="info-card">
            <div class="profile-img-area">
                <img src="https://i.imgur.com/81bee8.jpg" onerror="this.src='https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=300&q=80'" alt="프로필">
            </div>

            <div class="info-details">
                <h3>내 정보</h3>
                <div class="info-row"><div class="info-label">아이디</div><div class="info-value">won****</div></div>
                <div class="info-row"><div class="info-label">단지명</div><div class="info-value">원소집합</div></div>
                <div class="info-row"><div class="info-label">동 / 호수</div><div class="info-value">121동 1102호</div></div>
                <div class="info-row"><div class="info-label">타입</div><div class="info-value">A타입 (84㎡)</div></div>
                <div class="info-row"><div class="info-label">이름</div><div class="info-value">군포삼촌</div></div>
                <div class="info-row"><div class="info-label">전화번호</div><div class="info-value">010 - 1111 - 2234</div></div>
                <div class="info-row"><div class="info-label">이메일</div><div class="info-value">won@naver.com</div></div>
            </div>

            <div class="settings-area">
                <h4>알림 설정</h4>
                <div class="toggle-row">
                    <span class="toggle-label">이메일 알림</span>
                    <label class="switch"><input type="checkbox" checked><span class="slider"></span></label>
                </div>
                <div class="toggle-row">
                    <span class="toggle-label">문자 알림</span>
                    <label class="switch"><input type="checkbox"><span class="slider"></span></label>
                </div>
                <div class="toggle-row">
                    <span class="toggle-label">커뮤니티 알림</span>
                    <label class="switch"><input type="checkbox" checked><span class="slider"></span></label>
                </div>
                <div class="toggle-row">
                    <span class="toggle-label">댓글 알림</span>
                    <label class="switch"><input type="checkbox" checked><span class="slider"></span></label>
                </div>
            </div>

            <button type="button" class="btn-withdraw" id="withdrawBtn">회원 탈퇴</button>
        </div>
    </section>
</main>
<jsp:include page="../layout/footer.jsp" />
<script src="mypage.js"></script>

</body>
</html>

