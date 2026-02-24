<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 주차 차량 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    
    <style>
        .car-num-badge { 
            font-family: 'Consolas', monospace; 
            font-weight: 700; 
            background: #f8f9fa; 
            padding: 2px 8px; 
            border-radius: 4px; 
            border: 1px solid #ddd;
            letter-spacing: 1px;
        }
        .admin-table th { transition: background 0.2s; }
    </style>
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">
        
        <div class="content-header">
            <h2>주차 차량 관리</h2>
            <p class="subtitle">입주민 및 방문 차량 등록/조회 및 불법 주차 단속</p>
        </div>

        <div class="stat-grid-container grid-3">
            <div class="stat-card border-left-primary">
                <h3>입주민 등록 차량</h3>
                <div class="number text-primary" id="statResidentCount">0<span class="unit">대</span></div>
            </div>
            <div class="stat-card border-left-success">
                <h3>금일 방문 예정</h3>
                <div class="number text-success" id="statVisitorCount">0<span class="unit">대</span></div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>불법/위반 차량</h3>
                <div class="number text-danger" id="statViolationCount">0<span class="unit">건</span></div>
                <div class="desc">이번 달 누적 단속 건수</div>
            </div>
        </div>

        <div class="tab-wrapper">
            <div class="tab-container">
                <div class="tab-highlighter" id="tabHighlighter"></div>
                <button class="tab-btn active" onclick="parkingManager.filterTab('RESIDENT', 0)">입주민 차량</button>
                <button class="tab-btn" onclick="parkingManager.filterTab('VISITOR', 1)">방문 차량</button>
                <button class="tab-btn" onclick="parkingManager.filterTab('VIOLATION', 2)">단속/위반 차량</button>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title" id="tableTitle">입주민 차량 목록</h3>
                <div class="section-actions">
                    <input type="text" class="form-input" id="searchInput" placeholder="차량번호 또는 동/호수 검색" onkeyup="parkingManager.searchTable(true)" style="width: 250px;">
                    <button class="btn btn-secondary" onclick="parkingManager.searchTable(true)"><i class="fa-solid fa-search"></i></button>
                    
                    <button class="btn btn-primary" id="btnRegResident" onclick="parkingManager.openModal('residentReg')">
                        <i class="fa-solid fa-plus"></i> 차량 등록
                    </button>
                    <button class="btn btn-primary" id="btnRegVisitor" onclick="parkingManager.openModal('visitorReg')" style="display:none;">
                        <i class="fa-solid fa-calendar-plus"></i> 방문 예약
                    </button>
                    <button class="btn btn-primary" id="btnRegViolation" onclick="parkingManager.openModal('violationReg')" style="display:none; background-color: var(--danger); border-color: var(--danger);">
                        <i class="fa-solid fa-triangle-exclamation"></i> 단속 등록
                    </button>
                </div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="10%"> <col width="15%"> <col width="20%"> <col width="15%"> <col width="20%"> <col width="10%"> <col width="10%">
                </colgroup>
                <thead id="dynamicTableHead">
                </thead>
                <tbody id="parkingTableBody">
                </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>
        </div>

    </main>
</div>

<div id="residentRegModal" class="modal-overlay">
    <div class="modal-container">
        <div class="content-header" style="margin-bottom:15px; display:flex; justify-content:space-between;">
            <h3 style="font-size:1.3rem;">입주민 차량 등록</h3>
            <button onclick="parkingManager.closeModal('residentReg')" style="border:none; background:none; cursor:pointer; font-size:1.2rem;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body form-grid" style="display:flex; flex-direction:column; gap:15px;">
            <div style="display:flex; gap:10px;">
                <div style="flex:1;">
                    <label class="info-label">동</label>
                    <input type="text" class="form-input" id="regDong" placeholder="101">
                </div>
                <div style="flex:1;">
                    <label class="info-label">호</label>
                    <input type="text" class="form-input" id="regHo" placeholder="1502">
                </div>
            </div>
            <div>
                <label class="info-label">차량번호</label>
                <input type="text" class="form-input" id="regCarNumber" style="width:100%;" placeholder="예: 12가 3456">
            </div>
            <div>
                <label class="info-label">소유주명</label>
                <input type="text" class="form-input" id="regUserName" style="width:100%;">
            </div>
            <div>
                <label class="info-label">연락처</label>
                <input type="text" class="form-input" id="regPhone" style="width:100%;" placeholder="010-0000-0000">
            </div>
        </div>
        <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
            <button class="btn btn-secondary" onclick="parkingManager.closeModal('residentReg')">취소</button>
            <button class="btn btn-primary" onclick="alert('등록되었습니다!'); parkingManager.closeModal('residentReg');">등록하기</button>
        </div>
    </div>
</div>

<div id="visitorRegModal" class="modal-overlay">
    <div class="modal-container">
        <div class="content-header" style="margin-bottom:15px; display:flex; justify-content:space-between;">
            <h3 style="font-size:1.3rem;">방문 차량 예약</h3>
            <button onclick="parkingManager.closeModal('visitorReg')" style="border:none; background:none; cursor:pointer; font-size:1.2rem;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body form-grid" style="display:flex; flex-direction:column; gap:15px;">
            <div style="display:flex; gap:10px;">
                <div style="flex:1;">
                    <label class="info-label">방문 동</label>
                    <input type="text" class="form-input" id="visitDong" placeholder="101">
                </div>
                <div style="flex:1;">
                    <label class="info-label">방문 호</label>
                    <input type="text" class="form-input" id="visitHo" placeholder="1502">
                </div>
            </div>
            <div>
                <label class="info-label">차량번호</label>
                <input type="text" class="form-input" id="visitCarNumber" style="width:100%;" placeholder="차량번호 전체">
            </div>
            <div>
                <label class="info-label">방문 목적</label>
                <input type="text" class="form-input" id="visitPurpose" style="width:100%;" placeholder="예: 가전 설치, 친척 방문">
            </div>
            <div>
                <label class="info-label">방문 일자</label>
                <input type="date" class="form-input" id="visitDate" style="width:100%;">
            </div>
        </div>
        <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
            <button class="btn btn-secondary" onclick="parkingManager.closeModal('visitorReg')">취소</button>
            <button class="btn btn-primary" onclick="alert('예약되었습니다!'); parkingManager.closeModal('visitorReg');">예약하기</button>
        </div>
    </div>
</div>

<div id="violationRegModal" class="modal-overlay">
    <div class="modal-container">
        <div class="content-header" style="margin-bottom:15px; display:flex; justify-content:space-between;">
            <h3 style="font-size:1.3rem;">위반 차량 단속 등록</h3>
            <button onclick="parkingManager.closeModal('violationReg')" style="border:none; background:none; cursor:pointer; font-size:1.2rem;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body form-grid" style="display:flex; flex-direction:column; gap:15px;">
            <div>
                <label class="info-label">차량번호</label>
                <input type="text" class="form-input" id="vioCarNumber" style="width:100%;" placeholder="예: 01바 9999">
            </div>
            <div>
                <label class="info-label">위반 장소</label>
                <input type="text" class="form-input" id="vioLocation" style="width:100%;" placeholder="예: 101동 앞 소방차 전용구역">
            </div>
            <div>
                <label class="info-label">위반 사유 / 참고사항</label>
                <input type="text" class="form-input" id="vioReason" style="width:100%;" placeholder="예: 주차금지구역 주차">
            </div>
            <div>
                <label class="info-label">적발 일자</label>
                <input type="date" class="form-input" id="vioDate" style="width:100%;">
            </div>
        </div>
        <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
            <button class="btn btn-secondary" onclick="parkingManager.closeModal('violationReg')">취소</button>
            <button class="btn btn-primary" style="background:var(--danger); border-color:var(--danger);" onclick="alert('단속 차량이 등록되었습니다!'); parkingManager.closeModal('violationReg');">등록하기</button>
        </div>
    </div>
</div>

<div id="detailModal" class="modal-overlay">
    <div class="modal-container">
        <div class="content-header" style="margin-bottom:15px; display:flex; justify-content:space-between;">
            <h3 style="font-size:1.3rem;">차량 상세 정보</h3>
            <button onclick="parkingManager.closeModal('detail')" style="border:none; background:none; cursor:pointer; font-size:1.2rem;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        
        <div class="complaint-info" style="background: white; border:none; padding:0;">
            <div style="background:#f8f9fa; padding:20px; border-radius:10px; border:1px solid #eee;">
                <div class="info-row">
                    <span class="info-label">차량번호</span>
                    <span class="info-value car-num-badge" id="detailCarNumber" style="font-size:1.2rem;"></span>
                </div>
                <div class="info-row">
                    <span class="info-label">구분</span>
                    <span class="info-value" id="detailCategory"></span>
                </div>
                <div class="info-row">
                    <span class="info-label">상태</span>
                    <span class="info-value" id="detailState"></span>
                </div>
                <div class="info-row">
                    <span class="info-label">상세정보</span>
                    <span class="info-value" id="detailInfo" style="color:#666;"></span>
                </div>
                <div class="info-row">
                    <span class="info-label">등록/발생일</span>
                    <span class="info-value" id="detailDate"></span>
                </div>
            </div>
        </div>

        <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
            <button class="btn btn-secondary" onclick="parkingManager.closeModal('detail')">닫기</button>
            <button class="btn btn-primary" style="background:var(--danger);" onclick="alert('데이터를 삭제/단속 처리합니다.');">삭제/단속</button>
        </div>
    </div>
</div>

<script src="<c:url value='/js/admin/admin_common.js'/>"></script>

<script>
    window.globalParkingList = [];

    <c:if test="${not empty parkingList}">
        <c:forEach var="item" items="${parkingList}">
            window.globalParkingList.push({
                category: '${item.category}',
                carNumber: '${item.carNumber}',
                dong: '${item.dong}',
                ho: '${item.ho}',
                userName: '${item.userName}',
                phone: '${item.phone}',
                regDate: '${item.regDate}',
                approvalStatus: parseInt('${item.approvalStatus}') || 0,
                visitId: '${item.visitId}',
                visitPurpose: '${item.visitPurpose}',
                visitDate: '${item.visitDate}',
                visitStatus: '${item.visitStatus}',
                violationId: '${item.violationId}',
                location: '${item.location}',
                reason: '${item.reason}',
                owner: '${item.owner}',
                violationDate: '${item.violationDate}',
                status: '${item.status}'
            });
        </c:forEach>
    </c:if>
</script>

<script src="<c:url value='/js/admin/parking.js'/>"></script>

</body>
</html>