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
                <h3>전체 공지</h3>
                <div class="number text-primary" id="statTotal">${status.total != null ? status.total : 0}<span class="unit">건</span></div>
                <div class="desc">누적 등록된 공지</div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>중요(필독) 공지</h3>
                <div class="number text-danger" id="statImportant">${status.importantCount != null ? status.importantCount : 0}<span class="unit">건</span></div>
                <div class="desc">현재 상단 고정 중</div>
            </div>
            <div class="stat-card border-left-warning">
                <h3>비공개(숨김)</h3>
                <div class="number text-warning" id="statHidden">${status.hiddenCount != null ? status.hiddenCount : 0}<span class="unit">건</span></div>
                <div class="desc">임시저장 및 숨김 처리</div>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title">공지사항 목록</h3>
                <div class="section-actions">
                    <select class="form-select" id="searchType">
                        <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                        <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                    </select>
                    
                    <input type="text" class="form-input" id="searchKeyword" placeholder="검색어 입력" value="${keyword}" 
                           onkeyup="if(window.event.keyCode==13){noticeManager.searchTable()}">
                    <button class="btn btn-primary" onclick="noticeManager.searchTable()">
                        <i class="fa-solid fa-search"></i>
                    </button>
                    
                    <div style="width: 10px;"></div>
                    
                    <button class="btn btn-dark" onclick="noticeManager.openModal('create')">
                        <i class="fa-solid fa-pen-to-square"></i> 공지 등록
                    </button>
                </div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="8%"> <col width="45%"> <col width="12%"> <col width="15%"> <col width="12%"> <col width="8%">  
                </colgroup>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>조회수</th> 
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="noticeTableBody">
                    </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;">
                <c:if test="${paging.totalPages > 1}">
                    <button class="btn btn-secondary btn-xs" ${!paging.hasPrevious() ? 'disabled' : ''} 
                            onclick="location.href='?page=${paging.number-1}&searchType=${searchType}&searchInput=${keyword}'">&lt;</button>
                    
                    <c:forEach var="i" begin="0" end="${paging.totalPages - 1}">
                        <c:if test="${i >= paging.number - 5 && i <= paging.number + 5}">
                            <button class="btn ${i == paging.number ? 'btn-primary' : 'btn-secondary'} btn-xs" 
                                    onclick="location.href='?page=${i}&searchType=${searchType}&searchInput=${keyword}'">${i + 1}</button>
                        </c:if>
                    </c:forEach>

                    <button class="btn btn-secondary btn-xs" ${!paging.hasNext() ? 'disabled' : ''} 
                            onclick="location.href='?page=${paging.number+1}&searchType=${searchType}&searchInput=${keyword}'">&gt;</button>
                </c:if>
            </div>
        </div>

    </main>
</div>

<div id="noticeModal" class="modal-overlay">
    <div class="modal-container large">
        <div class="modal-header">
            <h3 id="modalTitle"><i class="fa-solid fa-bullhorn"></i> 공지사항 등록</h3>
            <button class="modal-close-btn" onclick="noticeManager.closeModal()">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        
        <form id="noticeForm" action="<c:url value='/admin/notice/write_pro'/>" method="post" enctype="multipart/form-data">
            <div class="modal-body">
                <input type="hidden" id="modalNoticeId" name="noticeId">

                <div style="display:flex; flex-direction:column; gap:15px;">
                    <div>
                        <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">제목</label>
                        <input type="text" class="form-input" id="inputTitle" name="title" placeholder="제목을 입력하세요" style="width:100%; font-weight:500;" required>
                    </div>

                    <div style="display:flex; gap:20px; align-items:center; padding:15px; background:#f8f9fa; border-radius:8px; border:1px solid #eee;">
                        <label style="display:flex; align-items:center; cursor:pointer; gap:8px;">
                            <input type="checkbox" id="checkImportant" name="important" value="true" style="transform:scale(1.2); accent-color:var(--danger);">
                            <input type="hidden" name="_important" value="on">
                            <span style="font-weight:600; color:var(--danger);">[필독] 상단 고정</span>
                        </label>
                        <div style="width:1px; height:20px; background:#ddd;"></div>
                        <label style="display:flex; align-items:center; cursor:pointer; gap:8px;">
                            <input type="checkbox" id="checkVisible" name="visible" value="true" checked style="transform:scale(1.2);">
                            <input type="hidden" name="_visible" value="on">
                            <span style="font-weight:600; color:#333;">바로 공개하기</span>
                        </label>
                    </div>

                    <div>
                        <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">첨부 파일 (엑셀, 한글, PDF, 사진 등)</label>
                        <input type="file" class="form-input" name="uploadFiles" multiple style="width:100%; padding:10px; background:#fff;">
                    </div>

                    <div>
                        <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">내용</label>
                        <textarea class="form-input" id="inputContent" name="content" rows="12" placeholder="공지사항 내용을 입력하세요..." style="width:100%; resize:vertical; line-height:1.6;" required></textarea>
                    </div>
                </div>
            </div>

            <div class="modal-footer right-align">
                <button type="button" class="btn btn-secondary" onclick="noticeManager.closeModal()">취소</button>
                <button type="submit" class="btn btn-primary" id="btnSaveNotice"><i class="fa-solid fa-check"></i> 저장하기</button>
            </div>
        </form>
        </div>
</div>

<script>
    window.globalNoticeList = [];
    <c:if test="${not empty paging.content}">
        <c:forEach var="item" items="${paging.content}">
            window.globalNoticeList.push({
                noticeId: parseInt('${item.noticeId}'),
                writerId: '${item.writerId}',
                title: `${item.title}`, 
                content: `${item.content}`,
                views: parseInt('${item.views}') || 0,
                regDate: '${item.regDate}',
                isImportant: ${item.isImportant == true},
                isVisible: ${item.isVisible != false}
            });
        </c:forEach>
    </c:if>

    window.serverStats = {
        total: ${status.total != null ? status.total : 0},
        important: ${status.importantCount != null ? status.importantCount : 0},
        hidden: ${status.hiddenCount != null ? status.hiddenCount : 0}
    };
</script>

<script src="<c:url value='/js/admin/notice_manage.js'/>"></script>

</body>
</html>