<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 시설 - 스크린골프</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    
    <link rel="stylesheet" href="/css/community.css">	
</head>
<body>
	<!--header sub로 바꾸기!(이미지도 완성되면)-->
	<jsp:include page="../layout/header_auth.jsp" />

    <div class="sub-header">
        <h1>커뮤니티 시설 상세안내</h1>
    </div>

    <div class="container">
        <div class="tab-menu">
            <button class="tab-btn active" onclick="goPage('golf')">스크린골프</button>
            <button class="tab-btn" onclick="goPage('gym')">헬스장</button>
            <button class="tab-btn" onclick="goPage('pool')">수영장</button>
            <button class="tab-btn" onclick="goPage('guest')">게스트하우스</button>
        </div>

        <div class="facility-section active">
            <div class="section-title">스크린골프 (GOLF ZONE)</div>
            <div class="content-grid">
                <div class="img-box">
                    <img src="https://images.unsplash.com/photo-1535131749006-b7f58c99034b?q=80&w=800" alt="골프">
                </div>
                <div class="info-box">
                    <h3>최신 GDR 시스템 완비</h3>
                    <p>실제 필드와 같은 생동감을 느낄 수 있는 최신식 스크린 골프 시설입니다. 
                    입주민들의 건전한 여가생활과 체력단련을 위한 공간입니다.</p>
                    <ul class="info-list">
                        <li><strong>위치:</strong> 커뮤니티센터 B1층</li>
                        <li><strong>타석:</strong> 5타석 (좌타석 1개 보유)</li>
                        <li><strong>운영시간:</strong> 06:00 ~ 23:00 (연중무휴)</li>
                        <li><strong>이용대상:</strong> 입주민 전용 (예약 필수)</li>
                    </ul>
                    <table class="price-table">
                        <thead><tr><th>구분</th><th>이용요금</th><th>비고</th></tr></thead>
                        <tbody>
                            <tr><td>1회 이용 (60분)</td><td>10,000원</td><td>앱 예약</td></tr>
                            <tr><td>월 정기권</td><td>150,000원</td><td>1일 1회</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="notice-list">
                <p class="important">※ 개인 클럽 사용을 권장하며, 연습용 클럽이 비치되어 있습니다.</p>
                <p>※ 안전사고 예방을 위해 타석 외 스윙 연습은 금지됩니다.</p>
                <p>※ 예약 시간 10분 경과 시 예약이 자동 취소됩니다.</p>
            </div>
        </div>
    </div>


	 <jsp:include page="../layout/footer.jsp" />

	<script src="community.js"></script>

</body>
</html>