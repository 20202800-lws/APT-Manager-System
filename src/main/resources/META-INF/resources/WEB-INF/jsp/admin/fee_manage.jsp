<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 관리비 조회 및 정산</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    
    <style>
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(2px);}
        .modal-container { background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); width: 500px; display: flex; flex-direction: column; gap: 15px; animation: fadeIn 0.3s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .info-group { margin-bottom: 5px; }
        .info-label { font-size: 0.85rem; color: #666; font-weight: 600; margin-bottom: 3px; }
        .info-value { font-size: 1.05rem; color: #333; font-weight: 500; }
    </style>
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">
        
        <div class="content-header" style="display:flex; justify-content:space-between; align-items:flex-end;">
            <div>
                <h2>관리비 조회 / 정산</h2>
                <p class="subtitle">월별 관리비 부과 현황 및 납부 관리</p>
            </div>
            <button class="btn btn-secondary" onclick="location.href='/admin/fee_log'">
                <i class="fa-solid fa-clock-rotate-left"></i> 변경 이력 보기
            </button>
        </div>

        <div class="stat-grid-container grid-3">
           <div class="stat-card border-left-primary">
                <h3>이번 달 총 부과액</h3>
                <div class="number text-primary" id="statTotalAmount">0<span style="font-size:1rem; color:#888; font-weight:400;">원</span></div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>미납 세대 / 금액</h3>
                <div class="number text-danger">
                    <span id="statUnpaidCount">0</span><span style="font-size:1rem; color:#888; font-weight:400;">세대</span>
                </div>
                <div id="statUnpaidAmount" style="font-size:0.9rem; color:#D32F2F; margin-top:5px; font-weight:600;">총 0원</div>
            </div>
            <div class="stat-card border-left-success">
                <h3>납부율</h3>
                <div class="number text-success" id="statPaymentRate">0%</div>
            </div>
        </div>

        <div class="tab-wrapper">
            <div class="tab-container">
                <button class="tab-btn active" onclick="feeManager.filterTab('all')">전체 내역</button>
                <button class="tab-btn" onclick="feeManager.filterTab('unpaid')">미납 내역</button>
                <button class="tab-btn" onclick="feeManager.filterTab('paid')">납부 완료</button>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title" id="listTitle">전체 관리비 내역</h3>
                <div class="section-actions">
                    <input type="month" class="form-input" id="searchYearMonth" onchange="feeManager.searchTable()" style="width: 150px; font-family: inherit;">
                    <input type="text" class="form-input" id="searchKeyword" placeholder="동/호수 검색" onkeyup="if(window.event.keyCode==13){feeManager.searchTable()}">
                    <button class="btn btn-primary" onclick="feeManager.searchTable()"><i class="fa-solid fa-search"></i></button>
                    <button class="btn btn-success" onclick="feeManager.openRegisterModal()"><i class="fa-solid fa-plus"></i> 수동 부과</button>
                    <button class="btn btn-secondary" onclick="alert('엑셀 다운로드 기능')"><i class="fa-solid fa-download"></i> 엑셀</button>
                </div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="15%"> <col width="15%"> <col width="20%"> <col width="15%"> <col width="20%"> <col width="15%"> 
                </colgroup>
                <thead>
                    <tr>
                        <th>동/호수</th>
                        <th>부과년월</th>
                        <th>청구금액</th>
                        <th>상태</th>
                        <th>납부일자 (마감일)</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="feeTableBody">
                </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>
        </div>

    </main>
</div>

<div id="feeModal" class="modal-overlay">
    <div class="modal-container">
        <div class="content-header" style="margin-bottom:20px; display:flex; justify-content:space-between; align-items:center;">
            <h3 style="font-size:1.3rem; font-weight:700;">관리비 상세 내역</h3>
            <button onclick="feeManager.closeModal()" style="font-size:1.2rem; color:#666; background:none; border:none; cursor:pointer;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        
        <div style="display:flex; gap:15px; margin-bottom:15px;">
            <div class="info-group" style="flex:1;">
                <div class="info-label">동/호수</div>
                <div class="info-value" id="modalDongHo"></div>
            </div>
            <div class="info-group" style="flex:1;">
                <div class="info-label">부과년월</div>
                <div class="info-value" id="modalUseDate"></div>
            </div>
        </div>

        <div class="info-group">
            <div class="info-label">총 청구금액 / 상태</div>
            <div class="info-value" style="display:flex; justify-content:space-between; align-items:center;">
                <span id="modalTotalCost" style="color:var(--primary); font-weight:800; font-size:1.2rem;"></span>
                <span id="modalPaymentStatus"></span>
            </div>
        </div>

        <div style="background:#f9f9f9; padding:15px; border-radius:8px; margin-bottom:20px; border:1px solid #eee;">
            <div style="display:flex; justify-content:space-between; margin-bottom:8px; padding-bottom:8px; border-bottom:1px dashed #ddd;">
                <span style="color:#666;">일반관리비</span><span style="font-weight:600;" id="modalCommonFee"></span>
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom:8px; padding-bottom:8px; border-bottom:1px dashed #ddd;">
                <span style="color:#666;">전기세</span><span style="font-weight:600;" id="modalElecFee"></span>
            </div>
            <div style="display:flex; justify-content:space-between; margin-bottom:8px; padding-bottom:8px; border-bottom:1px dashed #ddd;">
                <span style="color:#666;">수도세</span><span style="font-weight:600;" id="modalWaterFee"></span>
            </div>
            <div style="display:flex; justify-content:space-between;">
                <span style="color:#666;">기타/감면</span><span style="font-weight:600;" id="modalEtcFee"></span>
            </div>
        </div>

        <div style="display:flex; justify-content:flex-end; gap:10px;">
            <button class="btn btn-secondary" onclick="feeManager.closeModal()">닫기</button>
            <button class="btn btn-primary" id="modalActionBtn">납부 확인증 출력</button>
        </div>
    </div>
</div>

<div id="registerModal" class="modal-overlay">
    <div class="modal-container" style="width: 450px;">
        <div class="content-header" style="margin-bottom:15px; display:flex; justify-content:space-between; align-items:center;">
            <h3 style="font-size:1.3rem; font-weight:700;">관리비 수동 부과</h3>
            <button onclick="feeManager.closeRegisterModal()" style="font-size:1.2rem; color:#666; background:none; border:none; cursor:pointer;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <p style="font-size:0.85rem; color:#888; margin-bottom:15px;">* 부과된 내역은 이력(로그)에 자동 기록됩니다.</p>
        
        <div style="display:flex; gap:10px; margin-bottom:15px;">
            <div style="flex:1;">
                <label class="info-label">동</label>
                <input type="text" id="regDong" class="form-input" style="width:100%;" placeholder="예: 101">
            </div>
            <div style="flex:1;">
                <label class="info-label">호수</label>
                <input type="text" id="regHo" class="form-input" style="width:100%;" placeholder="예: 101">
            </div>
        </div>
        
        <div style="display:flex; gap:10px; margin-bottom:15px;">
            <div style="flex:1;">
                <label class="info-label">부과 연도</label>
                <input type="number" id="regYear" class="form-input" style="width:100%;" value="2026">
            </div>
            <div style="flex:1;">
                <label class="info-label">부과 월</label>
                <input type="number" id="regMonth" class="form-input" style="width:100%;" min="1" max="12">
            </div>
        </div>

        <div style="background:#f8f9fa; padding:15px; border-radius:8px; display:flex; flex-direction:column; gap:10px; margin-bottom:20px;">
            <div style="display:flex; align-items:center;">
                <label class="info-label" style="width:100px; margin:0;">일반관리비</label>
                <input type="number" id="regCommon" class="form-input" style="flex:1;" placeholder="금액 입력(원)">
            </div>
            <div style="display:flex; align-items:center;">
                <label class="info-label" style="width:100px; margin:0;">전기세</label>
                <input type="number" id="regElec" class="form-input" style="flex:1;" placeholder="금액 입력(원)">
            </div>
            <div style="display:flex; align-items:center;">
                <label class="info-label" style="width:100px; margin:0;">수도세</label>
                <input type="number" id="regWater" class="form-input" style="flex:1;" placeholder="금액 입력(원)">
            </div>
            <div style="display:flex; align-items:center;">
                <label class="info-label" style="width:100px; margin:0;">기타/감면</label>
                <input type="number" id="regEtc" class="form-input" style="flex:1;" placeholder="할인 시 음수(-) 입력">
            </div>
        </div>

        <div style="display:flex; justify-content:flex-end; gap:10px;">
            <button class="btn btn-secondary" onclick="feeManager.closeRegisterModal()">취소</button>
            <button class="btn btn-success" onclick="feeManager.submitRegisterFee()">부과하기</button>
        </div>
    </div>
</div>

<script>
    window.globalFeeList = [];
    <c:if test="${not empty feeList}">
        <c:forEach var="item" items="${feeList}">
            window.globalFeeList.push({
                feeId: parseInt('${item.feeId}'),
                dong: '${item.dong}',
                ho: '${item.ho}',
                useYear: parseInt('${item.useYear}'),
                useMonth: parseInt('${item.useMonth}'),
                totalCost: parseInt('${item.totalCost}'),
                paymentStatus: parseInt('${item.paymentStatus}'),
                commonFee: parseInt('${item.commonFee}'),
                elecFee: parseInt('${item.elecFee}'),
                waterFee: parseInt('${item.waterFee}'),
                etcFee: parseInt('${item.etcFee}')
            });
        </c:forEach>
    </c:if>
</script>

<script src="<c:url value='/js/admin/fee_manage.js'/>"></script>

</body>
</html>