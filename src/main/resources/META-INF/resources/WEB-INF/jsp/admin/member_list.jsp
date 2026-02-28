<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 회원 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">
        
        <div class="content-header">
            <h2>회원 관리</h2>
            <p class="subtitle">입주민 가입 승인 및 권한 설정</p>
        </div>

        <div class="stat-grid-container grid-4">
            <div class="stat-card border-left-primary">
                <h3>총 회원 수</h3>
                <div class="number text-primary" id="statTotalCount">${stats.total != null ? stats.total : 0}<span class="unit">명</span></div>
                <div class="desc">전체 가입자</div>
            </div>
            <div class="stat-card border-left-warning">
                <h3>승인 대기</h3>
                <div class="number text-warning" id="statWaitCount">${stats.wait != null ? stats.wait : 0}<span class="unit">명</span></div>
                <div class="desc" style="font-weight:600; color:#d32f2f;">가입 승인 필요</div>
            </div>
            <div class="stat-card border-left-success">
                <h3>입주민 (정상)</h3>
                <div class="number text-success" id="statActiveCount">${stats.member != null ? stats.member : 0}<span class="unit">명</span></div>
                <div class="desc">활동 중인 입주민</div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>관리자</h3>
                <div class="number text-danger" id="statAdminCount">${stats.admin != null ? stats.admin : 0}<span class="unit">명</span></div>
                <div class="desc">시스템 관리 권한</div>
            </div>
        </div>

        <div class="tab-wrapper">
            <div class="tab-container">
                <button class="tab-btn ${(tab == 'ALL' || empty tab) ? 'active' : ''}" onclick="adminMember.filterTab('ALL')">전체 회원</button>
                <button class="tab-btn ${tab == 'WAIT' ? 'active' : ''}" onclick="adminMember.filterTab('WAIT')">승인 대기</button>
                <button class="tab-btn ${tab == 'ACT' ? 'active' : ''}" onclick="adminMember.filterTab('ACT')">입주민</button>
                <button class="tab-btn ${tab == 'ADMIN' ? 'active' : ''}" onclick="adminMember.filterTab('ADMIN')">관리자</button>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title" id="tableTitle">
                    <c:choose>
                        <c:when test="${tab == 'WAIT'}">승인 대기자 목록</c:when>
                        <c:when test="${tab == 'ACT'}">입주민 목록</c:when>
                        <c:when test="${tab == 'ADMIN'}">관리자 목록</c:when>
                        <c:otherwise>전체 회원 목록</c:otherwise>
                    </c:choose>
                </h3>
                <div class="section-actions">
                    <select class="form-select" id="searchType">
                        <option value="kwName" ${not empty kwName ? 'selected' : ''}>이름</option>
                        <option value="kwAddress" ${not empty kwAddress ? 'selected' : ''}>동/호수</option>
                        <option value="kwPhone" ${not empty kwPhone ? 'selected' : ''}>연락처</option>
                    </select>

                    <c:set var="currentKeyword" value="${not empty kwName ? kwName : (not empty kwAddress ? kwAddress : kwPhone)}" />
                    <input type="text" class="form-input" id="keyword" placeholder="검색어 입력" value="${currentKeyword}" onkeyup="if(window.event.keyCode==13){adminMember.searchTable()}">
                    
                    <button class="btn btn-primary" onclick="adminMember.searchTable()"><i class="fa-solid fa-search"></i></button>
                </div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="10%"> <col width="15%"> <col width="15%"> <col width="20%"> <col width="20%"> <col width="10%"> <col width="10%"> 
                </colgroup>
                <thead>
                    <tr>
                        <th>상태</th> <th>동/호수</th> <th>이름</th> <th>연락처</th>
                        <th>이메일(ID)</th> <th>가입일</th> <th>관리</th>
                    </tr>
                </thead>
                <tbody id="memberTableBody">
                    </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;">
                <c:if test="${paging.totalPages > 1}">
                    <button class="btn btn-secondary btn-xs" ${!paging.hasPrevious() ? 'disabled' : ''} 
                            onclick="location.href='?page=${paging.number-1}&tab=${tab}&kwName=${kwName}&kwAddress=${kwAddress}&kwPhone=${kwPhone}'">&lt;</button>
                    
                    <c:forEach var="i" begin="0" end="${paging.totalPages - 1}">
                        <c:if test="${i >= paging.number - 5 && i <= paging.number + 5}">
                            <button class="btn ${i == paging.number ? 'btn-primary' : 'btn-secondary'} btn-xs" 
                                    onclick="location.href='?page=${i}&tab=${tab}&kwName=${kwName}&kwAddress=${kwAddress}&kwPhone=${kwPhone}'">${i + 1}</button>
                        </c:if>
                    </c:forEach>

                    <button class="btn btn-secondary btn-xs" ${!paging.hasNext() ? 'disabled' : ''} 
                            onclick="location.href='?page=${paging.number+1}&tab=${tab}&kwName=${kwName}&kwAddress=${kwAddress}&kwPhone=${kwPhone}'">&gt;</button>
                </c:if>
            </div>
        </div>

    </main>
</div>

<div id="memberModal" class="modal-overlay">
    <div class="modal-container">
        <div class="modal-header">
            <h3><i class="fa-solid fa-user-gear"></i> 회원 상세 정보</h3>
            <button class="modal-close-btn" onclick="adminMember.closeModal()">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        
        <div class="modal-body">
            <input type="hidden" id="modalUserId"> <div style="display:flex; flex-direction:column; gap:15px;">
                <div style="display:flex; gap:15px;">
                    <div style="flex:1;">
                        <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">이름</label>
                        <input type="text" class="form-input" id="modalUserName" style="width:100%;">
                    </div>
                    <div style="flex:1;">
                        <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">회원 권한 (상태)</label>
                        <select class="form-select" id="modalApprovalStatus" style="width:100%;">
                            <option value="WAIT">가입 대기</option>
                            <option value="ACT">입주민 (승인됨)</option>
                            <option value="ADMIN">관리자</option>
                        </select>
                    </div>
                </div>

                <div style="display:flex; gap:15px;">
                    <div style="flex:1;">
                        <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">동</label>
                        <input type="text" class="form-input" id="modalDong" style="width:100%;">
                    </div>
                    <div style="flex:1;">
                        <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">호</label>
                        <input type="text" class="form-input" id="modalHo" style="width:100%;">
                    </div>
                </div>

                <div>
                    <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">연락처</label>
                    <input type="text" class="form-input" id="modalPhone" style="width:100%;">
                </div>

                <div>
                    <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">이메일 (아이디)</label>
                    <input type="text" class="form-input" id="modalEmail" readonly style="width:100%; background:#f5f5f5; color:#888;">
                </div>
                
                <div>
                    <label style="font-size:0.85rem; font-weight:600; color:#666; margin-bottom:5px; display:block;">가입일시</label>
                    <div id="modalJoinDate" style="color:#333; font-weight:500;"></div>
                </div>
            </div>
        </div>

        <div class="modal-footer space-between">
            <button class="btn btn-secondary" style="color:var(--danger); border-color:var(--danger); background:#fff;" 
                    onclick="adminMember.deleteMember()">
                <i class="fa-solid fa-user-xmark"></i> 강제 탈퇴
            </button>
            <div style="display:flex; gap:10px;">
                <button class="btn btn-secondary" onclick="adminMember.closeModal()">취소</button>
                <button class="btn btn-primary" id="modalSaveBtn" onclick="adminMember.saveMember()">
                    <i class="fa-solid fa-check"></i> 정보 저장
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    window.globalMemberList = [];

    <c:if test="${not empty paging.content}">
        <c:forEach var="member" items="${paging.content}">
            window.globalMemberList.push({
                userId: '${member.userId}',
                userName: '${member.userName}',
                dong: '${member.dong}',
                ho: '${member.ho}',
                phone: '${member.phone}',
                email: '${member.email}',
                joinDate: '${member.joinDate}',
                // 백엔드 tab 분류와 일치하도록 상태값 재정의
                approvalStatus: '${member.userRole}' === 'ADMIN' ? 'ADMIN' : 
                               ('${member.status}' === 'true' || '${member.status}' === 'ACT' ? 'ACT' : 'WAIT')
            });
        </c:forEach>
    </c:if>
</script>

<script src="<c:url value='/js/admin/member_list.js'/>"></script>

</body>
</html>