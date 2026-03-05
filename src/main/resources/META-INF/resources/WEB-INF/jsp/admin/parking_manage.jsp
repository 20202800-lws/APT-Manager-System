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
            padding: 4px 10px; 
            border-radius: 4px; 
            border: 1px solid #ddd;
            letter-spacing: 1px;
            font-size: 15px;
        }
        .admin-table th { transition: background 0.2s; }
        
        /* 탭 관련 CSS는 삭제하고 admin.css의 공통 스타일(tab-wrapper)을 사용합니다 */
        
        .stat-box {
            display: flex; gap: 20px; margin-bottom: 30px;
        }
        .stat-card-custom {
            flex: 1; background: #fff; padding: 25px; border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm); display: flex; align-items: center; gap: 20px;
            border-left: 5px solid var(--primary);
        }
        .stat-card-custom.visitor { border-left-color: var(--success); }
        .stat-card-custom.violation { border-left-color: var(--danger); }
        .stat-icon {
            width: 60px; height: 60px; border-radius: 50%; display: flex;
            align-items: center; justify-content: center; font-size: 1.8rem;
        }
        .stat-icon.resident { background: #e0e7ff; color: var(--primary); }
        .stat-icon.visitor { background: #dcfce7; color: var(--success); }
        .stat-icon.violation { background: #fee2e2; color: var(--danger); }
        
        .stat-info h4 { margin: 0; color: #64748b; font-size: 0.9rem; margin-bottom: 5px; }
        .stat-info .num { font-size: 1.8rem; font-weight: 800; color: #333; }
        .stat-info .unit { font-size: 1rem; font-weight: 500; margin-left: 4px; }
    </style>
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">
        <header class="top-header">
            <div class="admin-info">
                <i class="fa-solid fa-circle-user"></i> 최고관리자 님
            </div>
        </header>

        <div class="content-body">
            <h1 class="page-title">주차 차량 관리</h1>

            <div class="stat-box">
                <div class="stat-card-custom resident">
                    <div class="stat-icon resident"><i class="fa-solid fa-car-side"></i></div>
                    <div class="stat-info">
                        <h4>등록된 입주민 차량</h4>
                        <div class="num" id="statResidentCount">0<span class="unit">대</span></div>
                    </div>
                </div>
                <div class="stat-card-custom visitor">
                    <div class="stat-icon visitor"><i class="fa-solid fa-id-badge"></i></div>
                    <div class="stat-info">
                        <h4>방문 승인 대기</h4>
                        <div class="num" id="statVisitorCount" style="color:var(--success);">0<span class="unit">대</span></div>
                    </div>
                </div>
                <div class="stat-card-custom violation">
                    <div class="stat-icon violation"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div class="stat-info">
                        <h4>미조치 위반/단속</h4>
                        <div class="num" id="statViolationCount" style="color:var(--danger);">0<span class="unit">건</span></div>
                    </div>
                </div>
            </div>

            <div class="tab-wrapper">
                <div class="tab-container">
                    <button class="tab-btn active" id="tab-RESIDENT" onclick="parkingManager.filterTab('RESIDENT')">입주민 차량</button>
                    <button class="tab-btn" id="tab-VISITOR" onclick="parkingManager.filterTab('VISITOR')">방문 차량</button>
                    <button class="tab-btn" id="tab-VIOLATION" onclick="parkingManager.filterTab('VIOLATION')">위반 차량</button>
                </div>
            </div>

            <div class="card">
                <div style="display:flex; justify-content:space-between; margin-bottom:20px; align-items:center;">
                    <h3 style="margin:0; font-size:1.2rem; color:#333;" id="tableTitle">입주민 차량 목록</h3>
                    <div style="display:flex; gap:10px;">
                        <input type="text" id="searchInput" placeholder="차량번호, 동/호수 검색" 
                               style="padding:10px 15px; border:1px solid #ddd; border-radius:6px; outline:none; width:250px;"
                               onkeyup="if(event.keyCode===13) parkingManager.searchTable(true)">
                        <button class="btn btn-secondary" onclick="parkingManager.searchTable(true)"><i class="fa-solid fa-magnifying-glass"></i> 검색</button>
                    </div>
                </div>

                <table class="admin-table">
                    <thead id="dynamicTableHead">
                    </thead>
                    <tbody id="parkingTableBody">
                    </tbody>
                </table>

                <div id="paginationWrapper" style="text-align:center; margin-top:30px; display:flex; justify-content:center; gap:5px;">
                </div>
            </div>
        </div>
    </main>
</div>

<div class="modal-overlay" id="detailModal">
    <div class="modal-container">
        <div class="modal-header">
            <h3>차량 상세 정보</h3>
            <button class="modal-close-btn" onclick="parkingManager.closeModal('detail')">&times;</button>
        </div>
        <div class="modal-body" style="font-size: 1.05rem;">
            <div style="text-align:center; margin-bottom: 25px;">
                <div class="badge badge-secondary" id="detailCategory" style="margin-bottom:10px; font-size:0.9rem;">분류</div>
                <h2 style="margin:0; font-family:'Consolas'; font-size:2.2rem; letter-spacing:2px; color:var(--primary);" id="detailCarNumber">12가 3456</h2>
            </div>
            
            <table style="width:100%; line-height:2.2;">
                <tr>
                    <td style="width:100px; color:#666; font-weight:600;">상태</td>
                    <td id="detailState" style="font-weight:700;">-</td>
                </tr>
                <tr>
                    <td style="color:#666; font-weight:600;">상세정보</td>
                    <td id="detailInfo">-</td>
                </tr>
                <tr>
                    <td style="color:#666; font-weight:600;">관련일자</td>
                    <td id="detailDate">-</td>
                </tr>
            </table>
        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="parkingManager.closeModal('detail')">닫기</button>
            <button class="btn btn-success" id="btnModalApprove" onclick="parkingManager.approveAction()" style="display:none;">승인 처리</button>
            <button class="btn btn-danger" id="btnModalDelete" onclick="parkingManager.deleteAction()">삭제/단속</button>
        </div>
    </div>
</div>

<script>
    // JSP에서 EL로 받은 데이터를 JS 전역 변수에 저장
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

<script src="<c:url value='/js/admin/parking_manage.js'/>"></script>

</body>
</html>