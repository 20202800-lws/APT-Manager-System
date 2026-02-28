<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 민원 접수 현황</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">
        <div class="content-header">
            <h2>민원 접수 현황</h2>
            <p class="subtitle">입주민 불편 사항 접수 및 처리 내역 관리</p>
        </div>

        <div class="stat-grid-container grid-4">
            <div class="stat-card border-left-primary">
                <h3>전체 민원</h3>
                <div class="number text-primary" id="statTotalCount">${stats.totalCount != null ? stats.totalCount : 0}<span class="unit">건</span></div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>신규 접수</h3>
                <div class="number text-danger" id="statPendingCount">${stats.newCount != null ? stats.newCount : 0}<span class="unit">건</span></div>
            </div>
            <div class="stat-card border-left-info">
                <h3>처리 중</h3>
                <div class="number text-info" id="statProcessingCount">${stats.processingCount != null ? stats.processingCount : 0}<span class="unit">건</span></div>
            </div>
            <div class="stat-card border-left-success">
                <h3>처리 완료</h3>
                <div class="number text-success" id="statCompletedCount">${stats.completedCount != null ? stats.completedCount : 0}<span class="unit">건</span></div>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title">접수 목록</h3>
                <div class="section-actions">
                    <select class="form-select" id="categoryFilter" onchange="complaintManager.searchTable()">
                        <option value="">전체 유형</option>
                        <option value="FACILITY" ${param.category == 'FACILITY' ? 'selected' : ''}>시설보수</option>
                        <option value="NOISE" ${param.category == 'NOISE' ? 'selected' : ''}>층간소음</option>
                        <option value="PARKING" ${param.category == 'PARKING' ? 'selected' : ''}>주차문제</option>
                        <option value="ETC" ${param.category == 'ETC' ? 'selected' : ''}>기타</option>
                    </select>

                    <select class="form-select" id="statusFilter" onchange="complaintManager.searchTable()">
                        <option value="">전체 상태</option>
                        <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>접수</option>
                        <option value="PROCESSING" ${param.status == 'PROCESSING' ? 'selected' : ''}>진행중</option>
                        <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>완료</option>
                    </select>

                    <select class="form-select" id="searchType" style="width: 100px;">
                        <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                        <option value="userId" ${searchType == 'userId' ? 'selected' : ''}>작성자ID</option>
                    </select>

                    <input type="text" class="form-input" id="keyword" value="${keyword}" placeholder="검색어 입력" 
                           onkeyup="if(window.event.keyCode==13){complaintManager.searchTable()}">
                           
                    <button class="btn btn-primary" onclick="complaintManager.searchTable()">
                        <i class="fa-solid fa-search"></i>
                    </button>
                </div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="8%"> <col width="12%"> <col width="*">
                    <col width="15%"> <col width="12%"> <col width="10%"> <col width="10%">
                </colgroup>
                <thead>
                    <tr>
                        <th>번호</th> <th>유형</th> <th>제목</th> <th>작성자</th>
                        <th>접수일</th> <th>상태</th> <th>관리</th>
                    </tr>
                </thead>
                <tbody id="complaintTableBody">
                    </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;">
                <c:if test="${paging.totalPages > 1}">
                    <button class="btn btn-secondary btn-xs" ${!paging.hasPrevious() ? 'disabled' : ''} 
                            onclick="location.href='?page=${paging.number-1}&searchType=${searchType}&keyword=${keyword}'">&lt;</button>
                    
                    <c:forEach var="i" begin="0" end="${paging.totalPages - 1}">
                        <c:if test="${i >= paging.number - 5 && i <= paging.number + 5}">
                            <button class="btn ${i == paging.number ? 'btn-primary' : 'btn-secondary'} btn-xs" 
                                    onclick="location.href='?page=${i}&searchType=${searchType}&keyword=${keyword}'">${i + 1}</button>
                        </c:if>
                    </c:forEach>

                    <button class="btn btn-secondary btn-xs" ${!paging.hasNext() ? 'disabled' : ''} 
                            onclick="location.href='?page=${paging.number+1}&searchType=${searchType}&keyword=${keyword}'">&gt;</button>
                </c:if>
            </div>
        </div>
    </main>
</div>

<div id="complaintModal" class="modal-overlay">
    <div class="modal-container large">
        <div class="modal-header">
            <h3><i class="fa-solid fa-clipboard-list"></i> 민원 상세 및 답변</h3>
            <button class="modal-close-btn" onclick="complaintManager.closeModal()">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        
        <div class="modal-body">
            <input type="hidden" id="targetCompId"> 
            
            <div class="complaint-info">
                <div class="info-row"><div class="info-label">유형</div><div class="info-value" id="modalCategory"></div></div>
                <div class="info-row"><div class="info-label">작성자</div><div class="info-value" id="modalUserName"></div></div>
                <div class="info-row"><div class="info-label">접수일</div><div class="info-value" id="modalRegDate"></div></div>
                <div class="info-row" style="margin-top:10px;"><div class="info-label">내용</div></div>
                <div style="background:#fff; padding:15px; border:1px solid #ddd; border-radius:4px; min-height:80px; white-space:pre-wrap; line-height:1.6;" id="modalContent"></div>
            </div>

            <div style="margin-top:20px;">
                <label style="font-size:0.95rem; font-weight:700; color:var(--primary); margin-bottom:8px; display:block;">
                    <i class="fa-solid fa-comment-dots"></i> 관리자 답변 등록
                </label>
                <textarea id="modalReply" class="form-input" style="width:100%; height:120px; padding:15px; resize:none; line-height:1.5;" placeholder="입주민에게 전달할 처리 결과 및 답변을 입력하세요."></textarea>
            </div>
        </div>

        <div class="modal-footer space-between">
            <div style="display:flex; align-items:center; gap:10px;">
                <label style="font-weight:600; font-size:0.9rem; color:#555;">처리 상태</label>
                <select id="modalCompStatus" class="form-select" style="width:140px; border-color:var(--primary);">
                    <option value="WAIT">대기 (미확인)</option>
                    <option value="PENDING">접수 완료</option>
                    <option value="PROCESSING">처리 중</option>
                    <option value="COMPLETED">처리 완료</option>
                </select>
            </div>
            <div style="display:flex; gap:10px;">
                <button class="btn btn-secondary" onclick="complaintManager.closeModal()">취소</button>
                <button class="btn btn-primary" onclick="complaintManager.saveComplaint()">
                    <i class="fa-solid fa-check"></i> 저장 및 전송
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // JS 데이터 바인딩
    window.globalComplaintList = [
        <c:forEach var="item" items="${paging.content}" varStatus="status">
            {
                compId: ${item.compId},
                category: '${item.category}',
                title: '${item.title}',
                content: `${item.content}`, 
                userName: '${item.userName}',
                regDate: '${item.regDate}',
                compStatus: '${item.compStatus}',
                userId : '${item.userId}',
                reply: `${item.reply}` // 답변 내용도 백틱으로 감싸서 줄바꿈 에러 방지
            }${!status.last ? ',' : ''}
        </c:forEach>
    ];
</script>

<script src="<c:url value='/js/admin/comp_manage.js'/>"></script>

</body>
</html>