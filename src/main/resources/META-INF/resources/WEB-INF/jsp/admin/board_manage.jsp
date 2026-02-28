<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 게시판 통합 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">
        
        <div class="content-header">
            <h2>게시판 통합 관리</h2>
            <p class="subtitle">커뮤니티 게시글 모니터링 및 불량 게시물 신고 관리</p>
        </div>

        <div class="stat-grid-container grid-3">
            <div class="stat-card border-left-primary">
                <h3>전체 게시글</h3>
                <div class="number text-primary" id="statTotalCount">${not empty status.total ? status.total : 0}<span class="unit">개</span></div>
                <div class="desc">누적 게시글 현황</div>
            </div>
            <div class="stat-card border-left-success">
                <h3>오늘의 새 글</h3>
                <div class="number text-success" id="statTodayCount">${not empty status['new'] ? status['new'] : 0}<span class="unit">개</span></div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>신고 / 블라인드</h3>
                <div class="number text-danger" id="statReportCount">${not empty status.report ? status.report : 0}<span class="unit">건</span></div>
                <div class="desc">관리자 확인 필요</div>
            </div>
        </div>

        <div class="tab-wrapper">
			<div class="tab-container">
                <button class="tab-btn ${(category == 'ALL' || empty category) ? 'active' : ''}" 
			            onclick="boardManager.filterTab('ALL')">전체보기</button>
			    <button class="tab-btn ${category == 'FREE' ? 'active' : ''}" 
			            onclick="boardManager.filterTab('FREE')">자유게시판</button>
			    <button class="tab-btn ${category == 'SECRET' ? 'active' : ''}" 
			            onclick="boardManager.filterTab('SECRET')">익명게시판</button>
			    <button class="tab-btn ${category == 'REPORT' ? 'active' : ''}" 
			            onclick="boardManager.filterTab('REPORT')">신고내역</button>
			</div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title" id="listTitle">
                    <c:choose>
                        <c:when test="${category == 'FREE'}">자유게시판 목록</c:when>
                        <c:when test="${category == 'SECRET'}">익명게시판 목록</c:when>
                        <c:when test="${category == 'REPORT'}">신고된 게시글</c:when>
                        <c:otherwise>전체 게시글 목록</c:otherwise>
                    </c:choose>
                </h3>
				<div class="section-actions">
				    <button class="btn btn-secondary" onclick="boardManager.openBannedModal()">
				        <i class="fa-solid fa-shield-halved"></i> 금지어 설정
				    </button>
				    
				    <div style="width: 10px;"></div>
				    
                    <select class="form-select" id="searchFilter">
				        <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
				        <option value="userName" ${searchType == 'userName' ? 'selected' : ''}>작성자</option>
				    </select>

				    <input type="text" class="form-input" id="searchInput"
				           placeholder="검색어 입력" 
				           value="${keyword}" 
				           onkeyup="if(window.event.keyCode==13){boardManager.searchTable()}">

				    <button class="btn btn-primary" onclick="boardManager.searchTable()">
				        <i class="fa-solid fa-search"></i>
				    </button>
				</div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="8%"> <col width="10%"> <col width="35%"> 
                    <col width="15%"> <col width="12%"> <col width="8%"> 
                    <col width="8%"> <col width="7%">
                </colgroup>
                <thead>
                    <tr>
                        <th>번호</th> <th>게시판</th> <th>제목</th> <th>작성자</th>
                        <th>작성일</th> <th>조회</th> <th>상태</th> <th>관리</th>
                    </tr>
                </thead>
                <tbody id="boardTableBody">
                    </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;">
                <c:if test="${paging.hasPrevious()}">
				    <button class="btn btn-secondary btn-xs" 
				            onclick="location.href='?page=${paging.number - 1}&category=${category}&searchType=${searchType}&searchInput=${keyword}'">&lt;</button>
				</c:if>

				<c:forEach var="i" begin="1" end="${paging.totalPages}">
                    <button class="btn ${i == paging.number + 1 ? 'btn-primary' : 'btn-secondary'} btn-xs" 
                            onclick="location.href='?page=${i-1}&category=${category}&searchType=${searchType}&searchInput=${keyword}'">${i}</button>
				</c:forEach>

				<c:if test="${paging.hasNext()}">
				    <button class="btn btn-secondary btn-xs" 
				            onclick="location.href='?page=${paging.number + 1}&category=${category}&searchType=${searchType}&searchInput=${keyword}'">&gt;</button>
				</c:if>
			</div>
        </div>

    </main>
</div>

<jsp:include page="./modals/board_modals.jsp" /> 

<script>
    // ★ 통계 데이터 바인딩 최적화
    window.adminStats = {
        total: parseInt('${status.total != null ? status.total : 0}'),
        newPost: parseInt("${status['new'] != null ? status['new'] : 0}"),
        report: parseInt('${status.report != null ? status.report : 0}')
    };

    window.globalBoardList = [];

    <c:if test="${not empty paging.content}">
        <c:forEach var="board" items="${paging.content}">
            window.globalBoardList.push({
                boardId: parseInt('${board.boardId}'),
                category: '${board.category}',
                title: '${board.title}',
                userName: '${board.author}',
                regDate: '${board.regDate}',
                views: parseInt('${board.views}'),
                reportCount: parseInt('${board.reportCount}'),
                postStatus: '${board.postStatus}',
                content: `${board.content}` // 줄바꿈 대응을 위해 백틱(`) 권장
            });
        </c:forEach>
    </c:if>
</script>

<script src="<c:url value='/js/admin/board_manage.js'/>"></script>

</body>
</html>