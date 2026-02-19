<!-- 일반 서브페이지용 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>APARTNERS | Center Navigation</title>
		<link rel="stylesheet" as="style" crossorigin
			href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
		<link rel="stylesheet" href="css/layout.css">

	
	</head>

	<body>
		<header id="mainHeader">
			
			<jsp:include page="../layout/header_auth.jsp" />
			<div class="nav-right">
				<a href="/mypage/act_main">마이페이지</a>
				<span>|</span>
<!--				<button onclick="alert('로그아웃 되었습니다.')">로그아웃</button> -->				<button onclick="logout()">로그아웃</button>
				<script> function logout() {alert('로그아웃 되었습니다.'); 
					// 메인 페이지로 이동 (예: index.jsp) 
					 location.href = '/home.jsp'; 
				 }
			    </script>
			</div>

		</header>

		<section class="hero-slider">
			<div class="slide-item active"
				style="background-image: url('https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=2070');">
			</div>
			<div class="slide-item"
				style="background-image: url('https://images.unsplash.com/photo-1545324418-f1d3c5b53571?q=80&w=2000');">
			</div>
		</section>


		<script src="/script.js"></script>
	</body>

	</html>