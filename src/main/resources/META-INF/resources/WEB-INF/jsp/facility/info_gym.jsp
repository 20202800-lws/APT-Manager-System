<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 시설 - 피트니스센터</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="/css/community.css">
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
            <button class="tab-btn active" onclick="goPage('gym')">피트니스센터</button>
            <button class="tab-btn" onclick="goPage('pool')">수영장</button>
            <button class="tab-btn" onclick="goPage('guest')">게스트하우스</button>
        </div>

        <div class="facility-section active">
            <div class="section-title">피트니스센터 (GYM)</div>
            <div class="content-grid">
                <div class="img-box">
                    <img src="https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=800" alt="헬스장">
                </div>
                <div class="info-box">
                    <h3>프리미엄 피트니스 공간</h3>
                    <p>최고급 유산소 및 웨이트 머신이 구비되어 있습니다.</p>
                    <ul class="info-list">
                        <li><strong>위치:</strong> 커뮤니티센터 1층</li>
                        <li><strong>기구:</strong> 테크노짐 머신 30종, 런닝머신 20대</li>
                        <li><strong>운영시간:</strong> 06:00 ~ 23:00 (매월 첫째주 월요일 휴관)</li>
                        <li><strong>편의시설:</strong> 샤워실, 락커룸, 인바디 측정기</li>
                    </ul>
                    <table class="price-table">
                        <thead><tr><th>구분</th><th>이용요금</th><th>비고</th></tr></thead>
                        <tbody>
                            <tr><td>세대당 1인</td><td>무료</td><td>관리비 포함</td></tr>
                            <tr><td>인원 추가 (1인)</td><td>30,000원/월</td><td>최대 2인 추가</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="notice-list">
                <p class="important">※ 실내 운동화 착용 필수 (슬리퍼, 구두 입장 불가)</p>
                <p>※ 중학생(14세) 이상부터 이용 가능합니다.</p>
                <p>※ 사용한 기구 및 덤벨은 제자리에 정리해주시기 바랍니다.</p>
            </div>
        </div>
    </div>

	 <jsp:include page="../layout/footer.jsp" />

    <script src="/js/community.js"></script>
</body>
</html>