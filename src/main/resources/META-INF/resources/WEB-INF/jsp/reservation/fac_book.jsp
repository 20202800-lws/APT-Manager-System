<!--커뮤니티 예약/신청 하기-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설 예약 - Brain City</title>
 

	<link rel="stylesheet" href="../css/layout.css">
	<link rel="stylesheet" href="../css/reservation.css">
	</head>
<body>
	<jsp:include page="../layout/header_auth.jsp"/>

	
<div class="wrapper">
    <aside>
        <div class="nav-group">
            <div class="nav-item active" onclick="location.href='fac_book'">커뮤니티 시설 예약/신청</div>
            <div class="nav-item" onclick="location.href='my_list'">예약/수강 내역</div>
        </div>
    </aside>

    <main>
        <div id="view-booking">
            <p class="section-desc">단지 내 커뮤니티 시설을 예약하고 이용하세요.</p>
            
            <div class="facility-grid">
                <div class="fac-card" onclick="openModal('pool')">
                    <div class="fac-icon" style="background: #3498db;">🏊</div>
                    <h4>수영장</h4>
                    <p>실내 수영장 (25m)</p>
                    <span class="time">06:00 - 22:00</span>
                    <span class="status-badge">예약 가능</span>
                </div>
                <div class="fac-card" onclick="openModal('gym')">
                    <div class="fac-icon" style="background: #e67e22;">🏋️</div>
                    <h4>헬스장</h4>
                    <p>최신 운동기구 완비</p>
                    <span class="time">06:00 - 23:00</span>
                    <span class="status-badge">예약 가능</span>
                </div>
                <div class="fac-card" onclick="openModal('guest')">
                    <div class="fac-icon" style="background: #2ecc71;">🏠</div>
                    <h4>게스트하우스</h4>
                    <p>방문객 숙박 시설</p>
                    <span class="time">체크인 15:00 / 아웃 11:00</span>
                    <span class="status-badge">예약 가능</span>
                </div>
                <div class="fac-card" onclick="openModal('golf')">
                    <div class="fac-icon" style="background: #9b59b6;">⛳</div>
                    <h4>스크린골프</h4>
                    <p>최신 골프 시뮬레이터</p>
                    <span class="time">06:00 - 23:00</span>
                    <span class="status-badge">예약 가능</span>
                </div>
            </div>

            <div class="info-box">
                <h3>시설 이용 안내</h3>
                <table class="info-table">
                    <tr><td>예약 시간</td><td>최소 1일 전까지 예약 가능합니다.</td></tr>
                    <tr><td>취소 규정</td><td>이용일 7일 전까지 무료 취소 가능</td></tr>
                    <tr><td>게스트하우스</td><td>2~6일 전까지 위약금 50%, 당일~48시간 위약금 100%</td></tr>
                    <tr><td>유의사항</td><td>빈번한 예약취소는 시설 이용에 제한이 될 수 있습니다.</td></tr>
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

<div id="confirmModal" class="modal">
    <div class="confirm-box">
        <p class="confirm-msg" id="confirmMessage">신청하시겠습니까?</p>
        <div class="confirm-btns">
            <button class="btn-yes" onclick="processConfirm(true)">예</button>
            <button class="btn-no" onclick="processConfirm(false)">아니오</button>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />
<script src="../js/reservation.js"></script>
</body>
</html>