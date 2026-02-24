<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 대시보드 | APARTNERS</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    
    <style>
        /* 대시보드 전용 레이아웃 */
        .dashboard-row { display: flex; gap: 20px; }
        .dashboard-col { flex: 1; display: flex; flex-direction: column; }
        
        /* 테이블 텍스트 스타일 */
        .td-title { text-align: left !important; max-width: 200px; cursor: pointer; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .td-title:hover { text-decoration: underline; color: var(--primary); }
    </style>
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">
        
        <div class="content-header">
            <div>
                <h2>관리자 대시보드</h2>
                <p class="subtitle">아파트 전체 현황 및 주요 알림 요약</p>
            </div>
            <div style="font-size:0.9rem; color:#666; font-weight:500;">
                <i class="fa-regular fa-calendar"></i> <span id="currentDate"></span>
            </div>
        </div>

        <div class="stat-grid-container grid-4">
            <div class="stat-card border-left-primary">
                <h3>총 입주 세대</h3>
                <div class="number text-primary" id="statTotalHouseholdCount">0<span class="unit">세대</span></div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>미처리 민원</h3>
                <div class="number text-danger" id="statUnprocessedMinwon">0<span class="unit">건</span></div>
                <div class="desc" style="color:#d32f2f; font-weight:600;">빠른 확인 요망</div>
            </div>
            <div class="stat-card border-left-success">
                <h3>관리비 납부율</h3>
                <div class="number text-success" id="statFeePaymentRate">0<span class="unit">%</span></div>
            </div>
            <div class="stat-card border-left-warning">
                <h3>주차 혼잡도</h3>
                <div class="number text-warning" id="statParkingRate">0<span class="unit">%</span></div>
            </div>
        </div>

        <div class="dashboard-row">
            
            <div class="dashboard-col content-box">
                <div class="section-header">
                    <h3 class="section-title">📢 최근 접수된 민원</h3>
                    <a href="<c:url value='/admin/comp_manage'/>" class="btn btn-secondary btn-xs">더보기 +</a>
                </div>
                <table class="admin-table">
                    <colgroup>
                        <col width="15%"> <col width="50%"> <col width="20%"> <col width="15%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>카테고리</th>
                            <th>제목</th>
                            <th>작성일</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody id="minwonTableBody">
                    </tbody>
                </table>
                <div id="minwonPaginationWrapper" style="margin-top:auto; padding-top:15px; text-align:center;"></div>
            </div>

            <div class="dashboard-col content-box">
                <div class="section-header">
                    <h3 class="section-title">👤 입주 승인 대기</h3>
                    <a href="<c:url value='/admin/member_list'/>" class="btn btn-secondary btn-xs">관리 이동 <i class="fa-solid fa-arrow-right"></i></a>
                </div>
                <table class="admin-table">
                    <colgroup>
                        <col width="25%"> <col width="25%"> <col width="30%"> <col width="20%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>동/호수</th>
                            <th>이름</th>
                            <th>신청일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="memberTableBody">
                    </tbody>
                </table>
                <div id="memberPaginationWrapper" style="margin-top:auto; padding-top:15px; text-align:center;"></div>
            </div>

        </div> 
    </main>
</div>

<script>
    // 1. 상단 통계 데이터
    window.globalStatsData = {
        totalHouseholdCount: parseInt('${stats.totalHouseholdCount}') || 0,
        unprocessedMinwon: parseInt('${stats.unprocessedMinwon}') || 0,
        feePaymentRate: parseInt('${stats.feePaymentRate}') || 0,
        parkingRate: parseInt('${stats.parkingRate}') || 0
    };

    // 2. 최근 민원 리스트
    window.globalRecentMinwonList = [];
    <c:if test="${not empty recentMinwonList}">
        <c:forEach var="item" items="${recentMinwonList}">
            window.globalRecentMinwonList.push({
                compId: parseInt('${item.compId}'),
                category: '${item.category}',
                title: '${item.title}',
                regDate: '${item.regDate}',
                compStatus: '${item.compStatus}'
            });
        </c:forEach>
    </c:if>

    // 3. 승인 대기 회원 리스트
    window.globalPendingMemberList = [];
    <c:if test="${not empty pendingMemberList}">
        <c:forEach var="item" items="${pendingMemberList}">
            window.globalPendingMemberList.push({
                userId: '${item.userId}',
                dong: '${item.dong}',
                ho: '${item.ho}',
                userName: '${item.userName}',
                joinDate: '${item.joinDate}'
            });
        </c:forEach>
    </c:if>
</script>

<script src="<c:url value='/js/admin/admin_common.js'/>"></script>
<script src="<c:url value='/js/admin/dashboard.js'/>"></script>

</body>
</html>