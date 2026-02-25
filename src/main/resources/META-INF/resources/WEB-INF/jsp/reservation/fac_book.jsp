<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설 예약 | APARTNERS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/reservation.css">
</head>
<body>
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="예약 및 관리" />
    </jsp:include>

    <div class="page-wrapper" style="min-height: calc(100vh - 80px);">
        
        <jsp:include page="../layout/sidebar_reservation.jsp" />

        <main class="content-area">
            <div class="page-header">
                <h2>커뮤니티 시설 예약</h2>
            </div>

            <div id="view-booking" style="margin-top: 20px;">
                <p class="section-desc" style="margin-bottom: 30px; color: #666;">단지 내 커뮤니티 시설을 예약하고 이용하세요.</p>
                
                <div class="facility-grid">
                    <div class="fac-card" onclick="openModal('pool')">
                        <div class="fac-icon" style="background: #3498db;">🏊</div>
                        <h4>수영장</h4>
                        <p>25m 4레인 실내 수영장</p>
                        <span class="time">06:00 - 22:00</span>
                        <span class="status-badge">예약 가능</span>
                    </div>
                    
                    <div class="fac-card" onclick="openModal('gym')">
                        <div class="fac-icon" style="background: #e74c3c;">🏋️</div>
                        <h4>피트니스센터</h4>
                        <p>최신 운동기구 완비</p>
                        <span class="time">06:00 - 23:00</span>
                        <span class="status-badge">예약 가능</span>
                    </div>
                    
                    <div class="fac-card" onclick="openModal('guest')">
                        <div class="fac-icon" style="background: #9b59b6;">🛏️</div>
                        <h4>게스트하우스</h4>
                        <p>방문객을 위한 숙박시설</p>
                        <span class="time">입실 15:00</span>
                        <span class="status-badge">예약 가능</span>
                    </div>
                    
                    <div class="fac-card" onclick="openModal('golf')">
                        <div class="fac-icon" style="background: #2ecc71;">⛳</div>
                        <h4>스크린골프</h4>
                        <p>최신 골프 시뮬레이터</p>
                        <span class="time">06:00 - 23:00</span>
                        <span class="status-badge">예약 가능</span>
                    </div>
                </div>

                <div class="info-box" style="margin-top: 50px; background: #f8f9fa; padding: 25px; border-radius: 8px;">
                    <h3 style="margin-top: 0; margin-bottom: 15px;">시설 이용 안내</h3>
                    <table class="info-table" style="width: 100%; text-align: left;">
                        <tr><td style="padding: 8px 0; font-weight: bold; width: 120px;">예약 시간</td><td>최소 1일 전까지 예약 가능합니다.</td></tr>
                        <tr><td style="padding: 8px 0; font-weight: bold;">취소 규정</td><td>이용일 7일 전까지 무료 취소 가능</td></tr>
                        <tr><td style="padding: 8px 0; font-weight: bold;">게스트하우스</td><td>2~6일 전까지 위약금 50%, 당일~48시간 위약금 100%</td></tr>
                        <tr><td style="padding: 8px 0; font-weight: bold;">유의사항</td><td>빈번한 예약취소는 시설 이용에 제한이 될 수 있습니다.</td></tr>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="bookingModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">시설 예약</h3>
                <button class="close-btn" onclick="closeModal()">×</button>
            </div>
            <div class="modal-body" id="modalBody"></div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="/js/reservation.js"></script>
</body>
</html>