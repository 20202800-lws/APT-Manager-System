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
                <div class="number text-primary" id="statTotalCount">0<span class="unit">개</span></div>
                <div class="desc">누적 게시글 현황</div>
            </div>
            <div class="stat-card border-left-success">
                <h3>오늘의 새 글</h3>
                <div class="number text-success" id="statTodayCount">0<span class="unit">개</span></div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>신고 / 블라인드</h3>
                <div class="number text-danger" id="statReportCount">0<span class="unit">건</span></div>
                <div class="desc">관리자 확인 필요</div>
            </div>
        </div>

        <div class="tab-wrapper">
            <div class="tab-container">
                <div class="tab-highlighter" id="tabHighlighter"></div>
                <button class="tab-btn active" onclick="boardManager.filterTab('ALL', 0)">전체보기</button>
                <button class="tab-btn" onclick="boardManager.filterTab('FREE', 1)">자유게시판</button>
                <button class="tab-btn" onclick="boardManager.filterTab('SECRET', 2)">익명게시판</button>
                <button class="tab-btn" onclick="boardManager.filterTab('REPORT', 3)">신고내역</button>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title" id="listTitle">전체 게시글 목록</h3>
                <div class="section-actions">
                    <button class="btn btn-secondary" onclick="boardManager.openBannedModal()">
                        <i class="fa-solid fa-shield-halved"></i> 금지어 설정
                    </button>
                    <div style="width: 10px;"></div>
                    <select class="form-select" id="searchFilter">
                        <option value="title">제목</option>
                        <option value="userName">작성자</option>
                    </select>
                    <input type="text" class="form-input" id="searchInput" placeholder="검색어 입력" onkeyup="boardManager.searchTable()">
                    <button class="btn btn-primary" onclick="boardManager.searchTable()"><i class="fa-solid fa-search"></i></button>
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

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>
        </div>

    </main>
</div>

<div id="bannedModal" class="modal-overlay">
    <div class="modal-container">
        <div class="content-header" style="margin-bottom:15px; display:flex; justify-content:space-between;">
            <h3 style="font-size:1.2rem; font-weight:700;">🚫 금지어 관리 설정</h3>
            <button onclick="boardManager.closeModal('bannedModal')" style="border:none; background:none; cursor:pointer; font-size:1.2rem;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <p style="font-size:0.9rem; color:#666; margin-bottom:10px;">
            등록된 단어가 포함된 게시글은 자동으로 블라인드 처리되거나 등록이 제한됩니다.
        </p>
        
        <textarea id="bannedInput" class="form-input" style="height:150px; resize:none; padding:15px; line-height:1.6; width:100%;" 
            placeholder="금지어를 쉼표(,)로 구분하여 입력하세요. (예: 바보, 멍청이, 욕설)"></textarea>
        
        <div style="text-align:right; display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
            <button class="btn btn-secondary" onclick="boardManager.closeModal('bannedModal')">취소</button>
            <button class="btn btn-primary" onclick="boardManager.saveBannedWords()">설정 저장</button>
        </div>
    </div>
</div>

<div id="detailModal" class="modal-overlay">
    <div class="modal-container" style="width: 600px;"> 
        <div class="content-header" style="margin-bottom:15px; display:flex; justify-content:space-between;">
            <h3 class="font-bold text-lg">게시글 상세 정보</h3>
            <button onclick="boardManager.closeModal('detailModal')" style="border:none; background:none; cursor:pointer; font-size:1.2rem;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        
        <input type="hidden" id="targetBoardId"> 
        <div id="postDetailContent"></div>

        <div style="margin-top:20px; padding-top:20px; border-top:1px solid #eee;">
             <label style="font-weight:600; display:block; margin-bottom:8px; color:var(--danger);">관리 조치 (블라인드 사유)</label>
             <select id="blindReason" class="form-select" style="width:100%;">
                 <option value="부적절한 홍보 게시물">부적절한 홍보 게시물</option>
                 <option value="욕설 및 비방">욕설 및 비방</option>
                 <option value="도배 및 스팸">도배 및 스팸</option>
                 <option value="기타 사유">기타 사유</option>
             </select>
        </div>

        <div style="display:flex; justify-content:space-between; margin-top:25px;">
            <button class="btn btn-secondary" style="color:var(--danger); border-color:var(--danger);" onclick="boardManager.executeAction('delete')">
                <i class="fa-solid fa-trash"></i> 완전 삭제
            </button>
            <div style="display:flex; gap:10px;">
                 <button class="btn btn-secondary" onclick="boardManager.closeModal('detailModal')">닫기</button>
                 <button class="btn btn-primary" onclick="boardManager.executeAction('blind')">
                    <i class="fa-solid fa-eye-slash"></i> 블라인드 처리
                 </button>
            </div>
        </div>
    </div>
</div>

<script>
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
                content: '${board.content}'
            });
        </c:forEach>
    </c:if>
</script>

<script src="<c:url value='/js/admin/board_manage.js'/>"></script>

</body>
</html>