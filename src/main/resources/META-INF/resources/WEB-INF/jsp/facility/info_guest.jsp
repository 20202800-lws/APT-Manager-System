<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 시설 - 게스트하우스</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="css/community.css">
	<link rel="stylesheet" href="/css/layout.css">
</head>
<body>
	<!--header sub로 바꾸기!(이미지도 완성되면)-->
	<jsp:include page="../layout/header_auth.jsp" />

    <div class="sub-header">
        <h1>커뮤니티 시설 상세안내</h1>
    </div>

    <div class="container">
        <div class="tab-menu">
            <button class="tab-btn" onclick="goPage('golf')">스크린골프</button>
            <button class="tab-btn" onclick="goPage('gym')">피트니스센터</button>
            <button class="tab-btn" onclick="goPage('pool')">수영장</button>
            <button class="tab-btn active" onclick="goPage('guest')">게스트하우스</button>
        </div>

        <div class="facility-section active">
            <div class="section-title">게스트하우스 (GUEST HOUSE)</div>
            
            <div class="room-type-grid">
                <div class="room-card">
                    <span class="room-title">A타입 (원룸형)</span>
                    <span class="room-desc">침대 1 + 욕실 1 (8평)</span>
                    <span class="room-price">1박 40,000원</span>
                </div>
                <div class="room-card">
                    <span class="room-title">B타입 (거실분리형)</span>
                    <span class="room-desc">침대 1 + 거실 + 욕실 1 (15평)</span>
                    <span class="room-price">1박 60,000원</span>
                </div>
                <div class="room-card">
                    <span class="room-title">C타입 (패밀리형)</span>
                    <span class="room-desc">침대 2 + 거실 + 욕실 2 (24평)</span>
                    <span class="room-price">1박 80,000원</span>
                </div>
            </div>

            <div class="content-grid">
                <div class="img-box">
                    <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=800" alt="게스트하우스">
                </div>
                <div class="info-box">
                    <h3>호텔급 숙박 시설</h3>
                    <p>친인척 및 지인 방문 시 편안하게 머무를 수 있는 고품격 게스트하우스입니다.
                    호텔식 침구류와 어메니티가 제공됩니다.</p>
                    <table class="price-table">
                        <thead><tr><th>타입</th><th>정원</th><th>평일(일~목)</th><th>주말(금~토)</th></tr></thead>
                        <tbody>
                            <tr><td>A타입 (원룸형/8평)</td><td>2인</td><td>40,000원</td><td>60,000원</td></tr>
                            <tr><td>B타입 (방1+거실1+화장실+주방/15평)</td><td>4인</td><td>60,000원</td><td>80,000원</td></tr>
                            <tr><td>C타입 (방2+거실1+화장실+주방/24평)</td><td>6인</td><td>80,000원</td><td>100,000원</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="notice-list">
                <p>1. <strong>예약</strong>: 입실일 30일 전 관리사무소 방문예약 또는 홈페이지 예약 (세대당 1년 최대 30일, 1개월 3박 4일 제한)</p>
                <p>2. <strong>시간</strong>: 입실 15시 / 퇴실 11시</p>
                <p>3. <strong>키 수령</strong>: 월~토(15:00~21:30) 안내데스크 / 일·공휴일(15:00~17:30) 안내데스크 / 그 외 보안실 수령</p>
                <p class="important">※ 시설물 내 취사 금지, 화기 및 위험물질 반입 금지</p>
                <p>※ 고성방가, 도박, 반려동물 동반 입실 시 퇴소 조치</p>
                <p>※ 침구류 및 식기도구 구비 / 일반 쓰레기 및 분리수거 필수</p>
            </div>
        </div>
    </div>
	<jsp:include page="../layout/footer.jsp" />
    <script src="js/community.js"></script>
</body>
</html>