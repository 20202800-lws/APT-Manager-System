<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 활동내역/게시물</title>
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
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'info_view')">내 정보</button>
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'info_edit')">정보 수정</button>
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'fee_view')">관리비</button>
	        
	        <div class="dropdown-grp">
	            <div class="menu-item">활동 내역 ▾</div>
	            <div class="sub-menu-side">
	                <button type="button" class="sub-item" onclick="changeMenu(this, 'act_reply')">내가 쓴 댓글</button>
	                <button type="button" class="sub-item active" onclick="changeMenu(this, 'act_posts')">내가 쓴 게시물</button>
	            </div>
	        </div>
	    </nav>
	</aside>

	<div class="content-area">
	    <div class="activity-header">
	        <h3 id="pageTitle">📝 내가 쓴 게시물</h3>
	        <span class="count-txt">총 <strong id="totalCount" style="color:#1a0b2e;">0</strong>건</span>
	    </div>

	    <ul id="activityList" class="activity-list"></ul>
	</div>

</main>
<jsp:include page="../layout/footer.jsp" />
<script src="mypage.js"></script>

</body>
</html>

