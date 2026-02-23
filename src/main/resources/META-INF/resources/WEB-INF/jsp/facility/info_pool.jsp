<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 시설 - 수영장</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="css/community.css">
	<link rel="stylesheet" href="/css/layout.css">
</head>
<body>
	<jsp:include page="../layout/header_auth.jsp" />

    <div class="sub-header">
        <h1>커뮤니티 시설 상세안내</h1>
    </div>

    <div class="container">
        <div class="tab-menu">
            <button class="tab-btn" onclick="goPage('golf')">스크린골프</button>
            <button class="tab-btn" onclick="goPage('gym')">피트니스센터</button>
            <button class="tab-btn active" onclick="goPage('pool')">수영장</button>
            <button class="tab-btn" onclick="goPage('guest')">게스트하우스</button>
        </div>

        <div class="facility-section active">
            <div class="section-title">실내 수영장 (INDOOR POOL)</div>
            <div class="content-grid">
                <div class="img-box">
                    <img src="https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?q=80&w=800" alt="수영장">
                </div>
                <div class="info-box">
                    <h3>25m 4레인 정규 풀</h3>
                    <p>자연채광이 들어오는 쾌적한 실내 수영장입니다.
                    유아풀이 별도로 마련되어 있어 가족 단위 이용이 편리합니다.</p>
                    <ul class="info-list">
                        <li><strong>위치:</strong> 커뮤니티센터 B2층</li>
                        <li><strong>시설:</strong> 성인풀(25m x 4레인), 유아풀(수심 0.6m), 자쿠지</li>
                        <li><strong>운영시간:</strong> 06:00 ~ 22:00 (수질정화시간 12:00~13:00)</li>
                        <li><strong>수질관리:</strong> 인공 해수풀 시스템</li>
                    </ul>
                    <table class="price-table">
                        <thead><tr><th>구분</th><th>이용요금</th><th>비고</th></tr></thead>
                        <tbody>
                            <tr><td>자유수영 (1일)</td><td>3,000원</td><td>입주민</td></tr>
                            <tr><td>강습 (주3회)</td><td>40,000원/월</td><td>초/중/상급</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="notice-list">
                <p class="important">※ 수영모 착용 필수 (캡모자 불가)</p>
                <p>※ 신장 130cm 미만 어린이는 반드시 보호자와 동반 입수해야 합니다.</p>
                <p>※ 오일, 화장품 등을 깨끗이 씻고 입장해주시기 바랍니다.</p>
            </div>
        </div>
    </div>
	<jsp:include page="../layout/footer.jsp" />
    <script src="js/community.js"></script>
</body>
</html>