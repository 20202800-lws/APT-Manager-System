<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주차 관리 시스템 | APARTNERS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parking.css">
</head>
<body>
	
	<!--header sub로 바꾸기!(이미지도 완성되면)-->
	<jsp:include page="../layout/header_auth.jsp" />
    <aside class="sidebar">
        <div class="logo"><i class="fa-solid fa-car-side"></i> APARTNERS</div>
        <nav class="nav-menu">
            <a onclick="location.reload()" class="nav-item active"><i class="fa-solid fa-warehouse"></i> 주차시설</a>
            <a onclick="openModal('household')" class="nav-item"><i class="fa-solid fa-house-user"></i> 세대차량등록</a>
            <a onclick="openModal('visitor')" class="nav-item"><i class="fa-solid fa-user-plus"></i> 방문차량등록</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <h2>주차 시설 현황</h2>
        </div>

        <section class="status-card">
            <div class="card-header">
                <h3>🚗 실시간 구역별 현황</h3>
                <span class="live-indicator"><i class="fa-solid fa-circle fa-beat-fade"></i> 실시간 집계중</span>
            </div>
            
            <div class="status-overview">
                <div class="type-status-group">
                    <div class="type-badge"><span>일반차량</span><strong id="cntGeneral">450/600</strong></div>
                    <div class="type-badge ev"><span><i class="fa-solid fa-bolt"></i> 전기차</span><strong id="cntEV">20/30</strong></div>
                    <div class="type-badge disabled"><span><i class="fa-solid fa-wheelchair"></i> 장애인</span><strong id="cntDisabled">12/20</strong></div>
                </div>

                <div class="total-status-wrapper">
                    <div class="total-count" id="totalNow">482 <span class="total-max">/ 650</span></div>
                    <div class="total-label">전체 점유율 <span id="totalPercent">74</span>%</div>
                </div>
            </div>

            <div class="floor-status">
                <div class="floor-item"><span style="width:30px;">B1</span><div class="progress-bar-bg"><div class="progress-bar-fill" id="barB1" style="width:90%; background:var(--danger);"></div></div><span id="txtB1" style="color:var(--danger); width:40px;">혼잡</span></div>
                <div class="floor-item"><span style="width:30px;">B2</span><div class="progress-bar-bg"><div class="progress-bar-fill" id="barB2" style="width:65%; background:var(--warning);"></div></div><span id="txtB2" style="color:var(--warning); width:40px;">보통</span></div>
                <div class="floor-item"><span style="width:30px;">B3</span><div class="progress-bar-bg"><div class="progress-bar-fill" id="barB3" style="width:40%; background:var(--success);"></div></div><span id="txtB3" style="color:var(--success); width:40px;">여유</span></div>
            </div>
        </section>

        <section class="list-section">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <h3>등록 차량 관리</h3>
                <p style="font-size: 13px; color: var(--gray);">* 세대당 1대 무료, 추가 차량은 3만원씩 관리비 청구</p>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>구분</th><th>차량번호</th><th>차종</th><th>소유주/방문자</th><th>등록/방문일</th><th>상태</th><th>관리</th>
                    </tr>
                </thead>
                <tbody id="vehicleTableBody"></tbody>
            </table>
        </section>
    </main>

    <div class="modal-overlay" id="parkingModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">차량 등록</h2>
                <button onclick="closeModal()" style="border:none; background:none; cursor:pointer; font-size:24px; color:var(--gray);">&times;</button>
            </div>
            <form id="vehicleForm" onsubmit="submitVehicle(event)">
                <input type="hidden" id="entryType">
                <div class="form-group">
                    <label class="form-label">차량번호</label>
                    <input type="text" class="form-input" id="car_Number" placeholder="예: 12가 3456" required>
                </div>
                <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div><label class="form-label">차종</label><input type="text" class="form-input" id="carModel" placeholder="예: 쏘렌토"></div>
                    <div>
                        <label class="form-label" id="ownerLabel">소유주 정보</label>
                        <div id="ownerFieldWrap" style="display: flex; gap: 5px;">
                            <select class="form-input" id="relationType" style="width: 90px; flex-shrink: 0;">
								<option value="본인">본인</option>
								<option value="세대원">세대원</option>
							</select>
                            <input type="text" class="form-input" id="ownerName" placeholder="성함" required>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="visitDateGroup" style="display: none;"><label class="form-label">방문 예정일</label>
					<input type="date" class="form-input" id="visitDate">
					<p style="font-size: 11px; color: var(--danger); margin-top: 5px;">* 방문차량은 등록된 당일만 출차가 가능합니다.</p>
				</div>
                <div class="form-group">
					<label class="form-label">비상 연락처</label>
					<input type="tel" class="form-input" id="contact" placeholder="010-0000-0000" required></div>
                <button type="submit" class="btn-submit">저장하기</button>
            </form>
        </div>
    </div>

	<div id="customAlert" class="modal-overlay" style="z-index: 2000;">
	    <div class="modal-content alert-box">
	        <div id="alertIcon" class="alert-icon"><i class="fa-solid fa-circle-info"></i></div>
	        <h3 id="alertTitle">알림</h3>
	        <p id="alertMessage"></p>
	        <div id="alertBtns"></div>
	    </div>
	</div>
	 <jsp:include page="../layout/footer.jsp" />

	<script src="parking.js"></script>

</body>
</html>