<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 | 커뮤니티 시설 관리</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <style>
        /* 점검 중(Maintenance) 상태일 때의 스타일 */
        .fac-item.on {
            border: 1px solid #ffebee !important;
            background-color: #fff5f5 !important;
        }
        .fac-item.on .form-input {
            background-color: #ffffff;
        }
    </style>
</head>
<body>

    <div class="admin-container">
		
        <jsp:include page="../layout/admin_sidebar.jsp" />
		
        <main class="main-content">
            
            <div class="content-header">
                <h2>커뮤니티 시설 관리</h2>
                <div class="subtitle" id="todayDateDisplay">📅 실시간 현황</div> 
            </div>

            <div class="stat-grid-container grid-4">
                <div class="stat-card border-left-primary" onclick="facilityManager.openHistory('profit')" style="cursor:pointer;">
                    <h3>이번 달 수익</h3>
                    <div class="number">₩0</div> 
                    <div class="desc text-primary">목표 달성중</div>
                </div>
                <div class="stat-card border-left-danger" onclick="facilityManager.openHistory('maintenance')" style="cursor:pointer;">
                    <h3>유지보수 지출</h3>
                    <div class="number text-danger">₩0</div>
                    <div class="desc">전월 대비 감소</div>
                </div>
                <div class="stat-card border-left-success" onclick="facilityManager.openHistory('net')" style="cursor:pointer;">
                    <h3>이번 달 순수익</h3>
                    <div class="number text-success">₩0</div>
                    <div class="desc">안정적</div>
                </div>
                <div class="stat-card border-left-info" onclick="facilityManager.openHistory('users')" style="cursor:pointer;">
                    <h3>이용객 수</h3>
                    <div class="number">0명</div>
                    <div class="desc">실시간 집계</div>
                </div>
            </div>

            <div class="content-box">
                <div class="section-header">
                    <div class="section-title">🛠️ 시설 실시간 점검 설정</div>
                </div>
                
                <div class="grid-4" style="display: grid; gap: 20px;">
                    <div class="fac-item" id="fac-card-POOL" data-fac-id="POOL" data-available="1" 
                         style="border:1px solid var(--border-color); padding:20px; border-radius:12px;">
                        <h4 style="margin-bottom:10px; font-weight:700;">🏊 수영장</h4>
                        <input type="text" class="form-input" placeholder="비고 입력" style="width:100%; margin-bottom:10px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span class="badge badge-green tgl-label">운영 중</span>
                            <button class="btn btn-secondary btn-xs" onclick="facilityManager.toggleFac('POOL')">상태변경</button>
                        </div>
                    </div>

                    <div class="fac-item" id="fac-card-GYM" data-fac-id="GYM" data-available="1" 
                         style="border:1px solid var(--border-color); padding:20px; border-radius:12px;">
                        <h4 style="margin-bottom:10px; font-weight:700;">🏋️ 헬스장</h4>
                        <input type="text" class="form-input" placeholder="비고 입력" style="width:100%; margin-bottom:10px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span class="badge badge-green tgl-label">운영 중</span>
                            <button class="btn btn-secondary btn-xs" onclick="facilityManager.toggleFac('GYM')">상태변경</button>
                        </div>
                    </div>

                    <div class="fac-item" id="fac-card-GOLF" data-fac-id="GOLF" data-available="1" 
                         style="border:1px solid var(--border-color); padding:20px; border-radius:12px;">
                        <h4 style="margin-bottom:10px; font-weight:700;">⛳ 골프장</h4>
                        <input type="text" class="form-input" placeholder="비고 입력" style="width:100%; margin-bottom:10px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span class="badge badge-green tgl-label">운영 중</span>
                            <button class="btn btn-secondary btn-xs" onclick="facilityManager.toggleFac('GOLF')">상태변경</button>
                        </div>
                    </div>

                    <div class="fac-item" id="fac-card-GUEST" data-fac-id="GUEST" data-available="1" 
                         style="border:1px solid var(--border-color); padding:20px; border-radius:12px;">
                        <h4 style="margin-bottom:10px; font-weight:700;">🏠 게스트하우스</h4>
                        <input type="text" class="form-input" placeholder="비고 입력" style="width:100%; margin-bottom:10px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span class="badge badge-green tgl-label">운영 중</span>
                            <button class="btn btn-secondary btn-xs" onclick="facilityManager.toggleFac('GUEST')">상태변경</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="content-box">
                <div class="section-header">
                    <div class="section-title">📅 시설별 예약 현황</div>
                </div>

                <div class="tab-wrapper">
                    <div class="tab-container">
                        <button class="tab-btn active" onclick="facilityManager.filterRes('ALL', this)">전체</button>
                        <button class="tab-btn" onclick="facilityManager.filterRes('POOL', this)">수영장</button>
                        <button class="tab-btn" onclick="facilityManager.filterRes('GYM', this)">헬스장</button>
                        <button class="tab-btn" onclick="facilityManager.filterRes('GOLF', this)">골프장</button>
                        <button class="tab-btn" onclick="facilityManager.filterRes('GUEST', this)">게스트하우스</button>
                    </div>
                </div>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>시설명</th> <th>예약자</th> <th>동/호수</th> <th>이용시간</th> <th>상태</th> <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="res-body">
                    </tbody>
                </table>
                <div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>
            </div>

        </main>
    </div>

    <div class="modal-overlay" id="historyModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
        <div class="modal-container" style="background:#fff; padding:25px; border-radius:12px; width:600px; max-width:90%; box-shadow:0 10px 25px rgba(0,0,0,0.2);">
            <div class="section-header" style="display:flex; justify-content:space-between; margin-bottom:20px;">
                <h3 class="section-title" id="modalTitle" style="margin:0;">통계 기록</h3>
                <button class="btn btn-secondary btn-xs" onclick="facilityManager.closeModal()"><i class="fa-solid fa-xmark"></i> 닫기</button>
            </div>
            
            <div style="margin-bottom: 15px; text-align: right;">
                <select class="form-select" id="yearSelector" onchange="facilityManager.renderHistory()" style="width: 120px;">
                    <option value="2026">2026년</option>
                    <option value="2025">2025년</option>
                    <option value="2024">2024년</option>
                </select>
            </div>

            <table class="admin-table">
                <thead>
                    <tr><th>월별</th><th>구분</th><th>수치/금액</th><th>비고</th></tr>
                </thead>
                <tbody id="modal-body">
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // 백엔드 연동용 JSTL-JS 브릿지 데이터
        window.globalResList = [];

        <c:if test="${not empty resList}">
            <c:forEach var="res" items="${resList}">
                window.globalResList.push({
                    resId: '${res.resId}',
                    facId: '${res.facId}',
                    userId: '${res.userId}',
                    userName: '${res.userName}',
                    dongHo: '${res.dongHo}',
                    useTime: '${res.useTime}',
                    resStatus: '${res.resStatus}',
                    reason: '' // 취소 사유 저장용
                });
            </c:forEach>
        </c:if>

        // 날짜 세팅 (서버에서 못 받아올 경우를 대비한 JS 날짜 처리)
        document.addEventListener('DOMContentLoaded', () => {
            const today = new Date();
            const dateString = today.getFullYear() + '-' + String(today.getMonth() + 1).padStart(2, '0') + '-' + String(today.getDate()).padStart(2, '0');
            document.getElementById('todayDateDisplay').innerText = `📅 \${dateString} 실시간 현황`;
        });
    </script>
    
    <script src="<c:url value='/js/admin/admin_common.js'/>"></script>
    <script src="<c:url value='/js/admin/community_manage.js'/>"></script>
</body>
</html>