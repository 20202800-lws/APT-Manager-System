<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게스트하우스 | APARTNERS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/community.css">
</head>

<body>
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="커뮤니티 시설 안내" />
    </jsp:include>

    <div class="page-wrapper" style="min-height: calc(100vh - 80px);">

        <jsp:include page="../layout/sidebar_facility.jsp" />

        <main class="content-area">
            <div class="page-header">
                <h2>게스트하우스 (GUEST HOUSE)</h2>
            </div>

            <div class="facility-section active" style="margin-top: 0;">
                <div class="room-type-grid">
                    <div class="room-card active" 
                         onclick="window.open('/images/logo/room4.png', '객실이미지', 'width=800,height=600,top=100,left=200')" 
                         style="cursor:pointer;">
                        <span class="room-title">A타입 (원룸형)</span>
                        <span class="room-desc">침대 1 + 욕실 1 (8평)</span>
                        <span class="room-price">1박 40,000원~</span>
                    </div>
                    <div class="room-card active" 
                         onclick="window.open('/images/logo/room1.png', '객실이미지2', 'width=800,height=600,top=100,left=200')" 
                         style="cursor:pointer;">
                        <span class="room-title">B타입 (거실분리형)</span>
                        <span class="room-desc">침대 1 + 거실 + 욕실 1 + 주방1 (15평)</span>
                        <span class="room-price">1박 60,000원~</span>
                    </div>
                    <div class="room-card active" 
                         onclick="window.open('/images/logo/room2.png', '객실이미지3', 'width=800,height=600,top=100,left=200')" 
                         style="cursor:pointer;">
                        <span class="room-title">C타입 (패밀리형)</span>
                        <span class="room-desc">침대 2 + 거실 + 욕실 2 + 주방1(24평)</span>
                        <span class="room-price">1박 80,000원~</span>
                    </div>
                </div>

                <div class="content-grid">
                    <div class="img-box">
                        <img id="mainRoomImg" src="/images/logo/room1.png" alt="게스트하우스 메인 이미지" style="max-width: 100%; height: auto; border-radius: 12px;">
                    </div>
                    
                    <div class="info-box">
                        <h3>호텔급 숙박 시설</h3>
                        <p>친인척 및 지인 방문 시 편안하게 머무를 수 있는 고품격 게스트하우스입니다. 호텔식 침구류와 어메니티가 제공됩니다.</p>
                        <table class="price-table">
                            <thead>
                                <tr>
                                    <th>타입</th>
                                    <th>정원</th>
                                    <th>평일(일~목)</th>
                                    <th>주말(금~토)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>A타입 (원룸형/8평)</td>
                                    <td>2인</td>
                                    <td>40,000원</td>
                                    <td>60,000원</td>
                                </tr>
                                <tr>
                                    <td>B타입 (15평)</td>
                                    <td>4인</td>
                                    <td>60,000원</td>
                                    <td>80,000원</td>
                                </tr>
                                <tr>
                                    <td>C타입 (24평)</td>
                                    <td>6인</td>
                                    <td>80,000원</td>
                                    <td>100,000원</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="notice-list">
                    <p>1. <strong>예약</strong>: 입실일 30일 전 관리사무소 방문예약 또는 홈페이지 예약</p>
                    <p>2. <strong>시간</strong>: 입실 15시 / 퇴실 11시</p>
                    <p class="important">※ 시설물 내 취사 금지, 화기 및 위험물질 반입 금지</p>
                    <p>※ 반려동물 동반 입실 시 퇴소 조치</p>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />
</body>

</html>