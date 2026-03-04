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
            <a href="/intro/layout">
                <img src="/images/logo/apart2.jpg" class="active" alt="아파트 전경 1" style="cursor: pointer;">
            </a>
            <a href="/intro/layout">
                <img src="/images/logo/apart4.png" alt="아파트 전경 2" style="cursor: pointer;">
            </a>
            <a href="/intro/layout">
                <img src="/images/logo/summer.png" alt="여름 조경" style="cursor: pointer;">
            </a>
            <a href="/intro/layout">
                <img src="/images/logo/skyLounge.png" alt="스카이 라운지" style="cursor: pointer;">
            </a>
        </div>
        <div class="hero-text">
            우리들의 APARTNERS<br>함께 하세요
        </div>
    </section>

    <section class="info-section" id="intro">
        <div class="section-tag">SITE PLAN</div>
        <h2 class="section-title">단지배치도</h2>
        <p class="section-desc">천안 브레인시티의 중심, 자연과 일상이 공존하는 쾌적한 단지 설계를 확인하세요.</p>
        <div class="image-container">
            <a href="/intro/guide">
                <img src="/images/logo/apart7.png" class="active" alt="단지 배치도 1" style="cursor: pointer;">
            </a>
            <a href="/intro/guide">
                <img src="/images/logo/apart6.png" alt="단지 배치도 2" style="cursor: pointer;">
            </a>
        </div>
    </section>

    <section class="info-section" id="guide">
        <div class="section-tag">PREMIUM GUIDE</div>
        <h2 class="section-title">단지안내</h2>
        <p class="section-desc">품격 있는 마감재와 스마트 시스템이 적용된 프리미엄 단지를 소개합니다.</p>
        <div class="image-container">
            <a href="/intro/guide">
                <img src="/images/logo/skyLounge.png" class="active" alt="스카이 라운지" style="cursor: pointer;">
            </a>
            <a href="/intro/guide">
                <img src="/images/logo/apart5.png" alt="아파트 외관" style="cursor: pointer;">
            </a>
            <a href="/intro/guide">
                <img src="/images/logo/garden.png" alt="단지 내 정원 1" style="cursor: pointer;">
            </a>
            <a href="/intro/guide">
                <img src="/images/logo/garden2.png" alt="단지 내 정원 2" style="cursor: pointer;">
            </a>
            <a href="/intro/guide">
                <img src="/images/logo/child2.png" alt="어린이 놀이터" style="cursor: pointer;">
            </a>
        </div>
    </section>

    <section class="info-section" id="plan">
        <div class="section-tag">FLOOR PLAN</div>
        <h2 class="section-title">평면도</h2>
        <p class="section-desc">혁신적인 4Bay 설계와 넉넉한 수납공간으로 생활의 여유를 더했습니다.</p>
        <div class="image-container">
            <a href="/intro/floor_plan">
                <img src="/images/logo/84A.png" class="active" alt="84A 타입 평면도" style="cursor: pointer;">
            </a>
            <a href="/intro/floor_plan">
                <img src="/images/logo/84B.png" alt="84B 타입 평면도" style="cursor: pointer;">
            </a>
            <a href="/intro/floor_plan">
                <img src="/images/logo/84C.png" alt="84C 타입 평면도" style="cursor: pointer;">
            </a>
        </div>
    </section>

    <jsp:include page="layout/footer.jsp" />

    <script src="/js/common.js"></script>
    <script src="/js/main.js"></script>
</body>
</html>