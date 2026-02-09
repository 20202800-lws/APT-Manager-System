<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>APARTNERS 홈페이지에 오신 것을 환영합니다.</title>
	<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
	    
	<link rel="stylesheet" href="/css/layout.css">
	    
	<link rel="stylesheet" href="/css/main.css">
</head>
<body>

    <jsp:include page="layout/header_auth.jsp" />

    <section class="hero">
        <div class="hero-slider">
            <img src="https://images.unsplash.com/photo-1545324418-f1d3c5b53004?auto=format&fit=crop&w=1920&q=80" class="active">
            <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1920&q=80">
            <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1920&q=80">
        </div>
        <div class="hero-text">우리들의 APARTNERS<br>함께 하세요</div>
    </section>

    <section class="info-section" id="intro">
        <div class="section-tag">SITE PLAN</div>
        <h2 class="section-title">단지배치도</h2>
        <p class="section-desc">천안 브레인시티의 중심, 자연과 일상이 공존하는 쾌적한 단지 설계를 확인하세요.</p>
        <div class="image-container">
            <img src="https://images.unsplash.com/photo-1545324418-f1d3c5b53004?auto=format&fit=crop&w=1200" class="active">
            <img src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200">
        </div>
    </section>

    <section class="info-section" id="guide">
        <div class="section-tag">PREMIUM GUIDE</div>
        <h2 class="section-title">세대안내</h2>
        <p class="section-desc">품격 있는 마감재와 스마트 시스템이 적용된 프리미엄 주거 공간을 소개합니다.</p>
        <div class="image-container">
            <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200" class="active">
            <img src="https://images.unsplash.com/photo-1600607687940-c52af0424225?auto=format&fit=crop&w=1200">
        </div>
    </section>

    <section class="info-section" id="plan">
        <div class="section-tag">FLOOR PLAN</div>
        <h2 class="section-title">평면도</h2>
        <p class="section-desc">혁신적인 4Bay 설계와 넉넉한 수납공간으로 생활의 여유를 더했습니다.</p>
        <div class="image-container">
            <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1200" class="active">
            <img src="https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=1200">
        </div>
    </section>

    <jsp:include page="layout/footer.jsp" />

	<script src="/js/common.js"></script>

	<script src="/js/main.js"></script>
</body>
</html>