<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 공지사항 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">
        
        <div class="content-header">
            <h2>공지사항 관리</h2>
            <p class="subtitle">단지 소식 및 주요 알림 게시판 관리</p>
        </div>

        <div class="stat-grid-container grid-3">
            <div class="stat-card border-left-primary">
                <h3>전체 게시글</h3>
                <div class="number text-primary" id="statTotal">0<span class="unit">건</span></div>
                <div class="desc">누적 등록된 공지</div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>중요(필독) 공지</h3>
                <div class="number text-danger" id="statImportant">0<span class="unit">건</span></div>
                <div class="desc">현재 상단 고정 중</div>
            </div>
            <div class="stat-card border-left-warning">
                <h3>비공개(숨김)</h3>
                <div class="number text-warning" id="statHidden">0<span class="unit">건</span></div>
                <div class="desc">임시저장 및 숨김 처리</div>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title">공지사항 목록</h3>
                <div class="section-actions">
                    <select class="form-select" id="searchFilter">
                        <option value="all">전체 상태</option>
                        <option value="public">공개</option>
                        <option value="private">비공개</option>
                    </select>
                    <input type="text" class="form-input" id="searchKeyword" placeholder="제목 검색" value="${keyword}" onkeyup="if(window.event.keyCode==13){noticeManager.searchTable(true)}">
                    <button class="btn btn-primary" onclick="noticeManager.searchTable(true)"><i class="fa-solid fa-search"></i></button>
                    
                    <button class="btn btn-dark" onclick="noticeManager.openModal('create')">
                        <i class="fa-solid fa-pen-to-square"></i> 공지 등록
                    </button>
                </div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="8%">  <col width="45%"> <col width="12%"> <col width="15%"> <col width="12%"> <col width="8%">  
                </colgroup>
                <thead>
                    <tr>
                        <th>번호(ID)</th>
                        <th>제목</th>
                        <th>작성자(ID)</th>
                        <th>작성일</th>
                        <th>조회수</th> 
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="noticeTableBody">
                </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;">
				<div class="admin-pagination" style="display:flex; justify-content:center; gap:8px;">
					<c:if test="$paging.totalPages>0}">
				        <%-- 이전 페이지 --%>
				        <c:if test="${paging.hasPrevious()}">
				            <a href="?page=${paging.number - 1}&searchInput=${keyword}&searchType=${searchType}" class="btn btn-secondary btn-xs">이전</a>
				        </c:if>

				        <%-- 페이지 번호 --%>
				        <c:forEach var="i" begin="0" end="${paging.totalPages - 1}">
				            <a href="?page=${i}&searchInput=${keyword}&searchType=${searchType}" 
				               class="btn btn-xs ${i == paging.number ? 'btn-primary' : 'btn-secondary'}">
				               ${i + 1}
				            </a>
				        </c:forEach>

				        <%-- 다음 페이지 --%>
				        <c:if test="${paging.hasNext()}">
				            <a href="?page=${paging.number + 1}&searchInput=${keyword}&searchType=${searchType}" class="btn btn-secondary btn-xs">다음</a>
				        </c:if>
					</c:if>
				    </div>
			</div>
        </div>

    </main>
</div>

<div id="noticeModal" class="modal-overlay">
    <div class="modal-container" style="width: 700px;">
        <div class="content-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
            <h3 style="font-size:1.3rem; font-weight:700;" id="modalTitle">공지사항 등록</h3>
            <button onclick="noticeManager.closeModal()" style="border:none; background:none; font-size:1.2rem; cursor:pointer; color:#666;">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        
        <form id="noticeForm" action="/admin/notice/write_pro" method="post">
            <input type="hidden" id="modalNoticeId" name="noticeId">

			<input type="hidden" id="modalNoticeId" name="noticeId">

			    <div class="form-grid" style="display:flex; flex-direction:column; gap:15px;">
			        <div class="info-group">
			            <label class="info-label">제목</label>
			            <input type="text" class="form-input" id="inputTitle" name="title" placeholder="제목 입력" style="font-weight:500;" required>
			        </div>

			        <div style="display:flex; gap:20px; align-items:center; padding:15px; background:#f8f9fa; border-radius:8px;">
			            <label style="display:flex; align-items:center; cursor:pointer; gap:8px;">
			                <input type="checkbox" id="checkImportant" name="isImportant" value="true" style="transform:scale(1.2); accent-color:var(--danger);">
			                <span style="font-weight:600; color:var(--danger);">[필독] 상단 고정</span>
			            </label>
			            <div style="width:1px; height:20px; background:#ddd;"></div>
			            <label style="display:flex; align-items:center; cursor:pointer; gap:8px;">
			                <input type="checkbox" id="checkVisible" name="isVisible" value="true" checked style="transform:scale(1.2);">
			                <span>바로 공개하기</span>
			            </label>
			        </div>

			        <div class="info-group">
			            <label class="info-label">내용</label>
			            <textarea class="form-input" id="inputContent" name="content" rows="12" placeholder="내용을 입력하세요..." style="resize:vertical; line-height:1.6;" required></textarea>
			        </div>
			    </div>

			    <div style="margin-top:25px; display:flex; justify-content:flex-end; gap:10px;">
			        <button type="button" class="btn btn-secondary" onclick="noticeManager.closeModal()">취소</button>
			        <button type="button" class="btn btn-primary" onclick="noticeManager.saveNotice()">저장하기</button>
			    </div>
        </form>
    </div>
</div>



<script>
	window.globalNoticeList = [];
	    <c:forEach var="item" items="${paging.content}">
	        window.globalNoticeList.push({
	            noticeId: parseInt('${item.noticeId}'),
	            writerId: '${item.writerId}',
	            title: '${item.title.replace("'", "\\'")}', 
	            content: `${item.content != null ? item.content.replace("`", "\\`") : ""}`,
	            views: parseInt('${item.views}') || 0,
	            regDate: '${item.regDate}',
	            isImportant: ${item.isImportant == true},
	            isVisible: ${item.isVisible != false}
	        });
	    </c:forEach>

	    // 2. 서버의 페이징 상태를 JS로 전달
		window.serverPaging = {
		        currentPage: ${paging.number},
		        totalPages: ${paging.totalPages},
		        totalElements: ${paging.totalElements},
		        // keyword가 null일 경우 빈 문자열("")로 처리하여 에러 방지
		        keyword: '${keyword != null ? keyword : ""}', 
		        searchType: '${searchType != null ? searchType : "title"}'
		    };
			
			window.serverStats = {
			        total: ${status.total != null ? status.total : 0},
			        important: ${status.importantCount != null ? status.importantCount : 0},
			        hidden: ${status.hiddenCount != null ? status.hiddenCount : 0}
			    };
	
	
</script>
<script src="<c:url value='/js/admin/notice_manage.js'/>"></script>


</body>
</html>