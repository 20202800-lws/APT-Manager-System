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
                <div class="number text-primary" id="statTotalCount">${stats.total}<span class="unit">명</span></div>
                <div class="desc">전체 가입자</div>
            </div>
            <div class="stat-card border-left-warning">
                <h3>승인 대기</h3>
                <div class="number text-warning" id="statWaitCount">${stats.total}<span class="unit">명</span></div>
                <div class="desc" style="font-weight:600; color:#d32f2f;">가입 승인 필요</div>
            </div>
            <div class="stat-card border-left-success">
                <h3>입주민 (정상)</h3>
                <div class="number text-success" id="statActiveCount">${stats.total}<span class="unit">명</span></div>
                <div class="desc">활동 중인 입주민</div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>관리자</h3>
                <div class="number text-danger" id="statAdminCount">${stats.total}<span class="unit">명</span></div>
                <div class="desc">시스템 관리 권한</div>
            </div>
        </div>

        <div class="tab-wrapper">
            <div class="tab-container">
                <div class="tab-highlighter" id="tabHighlighter"></div>
                <button class="tab-btn active" onclick="adminMember.filterTab('ALL', 0)">전체 회원</button>
                <button class="tab-btn" onclick="adminMember.filterTab('WAIT', 1)">승인 대기</button>
                <button class="tab-btn" onclick="adminMember.filterTab('ACT', 2)">입주민</button>
                <button class="tab-btn" onclick="adminMember.filterTab('ADM', 3)">관리자</button>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title" id="tableTitle">전체 회원 목록</h3>
                <div class="section-actions">
                    <input type="text" class="form-input" id="searchInput" placeholder="이름, 동/호수, 전화번호" onkeyup="adminMember.searchTable(true)">
                    <button class="btn btn-primary" onclick="adminMember.searchTable(true)"><i class="fa-solid fa-search"></i></button>
                </div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="10%"> <col width="15%"> <col width="15%"> <col width="20%"> <col width="20%"> <col width="10%"> <col width="10%"> 
                </colgroup>
                <thead>
                    <tr>
                        <th>상태</th>
                        <th>동/호수</th>
                        <th>이름</th>
                        <th>연락처</th>
                        <th>이메일</th>
                        <th>가입일</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="memberTableBody">
                </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>
        </div>

    </main>
</div>

<div id="memberModal" class="modal-overlay">
    <div class="modal-container" style="width: 550px;">
        <div class="content-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
            <h3 style="font-size:1.3rem; font-weight:700;">회원 상세 정보</h3>
            <button onclick="adminMember.closeModal()" style="border:none; background:none; font-size:1.2rem; cursor:pointer; color:#666;">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        
        <div class="form-grid" style="display:flex; flex-direction:column; gap:15px;">
            <div style="display:flex; gap:15px;">
                <div class="info-group" style="flex:1;">
                    <label class="info-label">이름</label>
                    <input type="text" class="form-input" id="modalUserName">
                </div>
                <div class="info-group" style="flex:1;">
                    <label class="info-label">회원 상태</label>
                    <select class="form-select" id="modalApprovalStatus">
                        <option value="WAIT">승인 대기</option>
                        <option value="ACT">정상 (입주민)</option>
                        <option value="ADM">관리자</option>
                        <option value="BAN">정지됨</option>
                    </select>
                </div>
            </div>

            <div style="display:flex; gap:15px;">
                <div class="info-group" style="flex:1;">
                    <label class="info-label">동</label>
                    <input type="text" class="form-input" id="modalDong">
                </div>
                <div class="info-group" style="flex:1;">
                    <label class="info-label">호</label>
                    <input type="text" class="form-input" id="modalHo">
                </div>
            </div>

            <div class="info-group">
                <label class="info-label">연락처</label>
                <input type="text" class="form-input" id="modalPhone">
            </div>

            <div class="info-group">
                <label class="info-label">이메일 (아이디)</label>
                <input type="text" class="form-input" id="modalEmail" readonly style="background:#f5f5f5;">
            </div>
            
            <div class="info-group">
                <label class="info-label">가입일시</label>
                <div class="info-value" id="modalJoinDate" style="color:#666;"></div>
            </div>
        </div>

        <div style="margin-top:25px; display:flex; justify-content:flex-end; gap:10px;">
            <button class="btn btn-danger" style="margin-right:auto;" onclick="adminMember.deleteMember()">삭제</button>
            <button class="btn btn-secondary" onclick="adminMember.closeModal()">취소</button>
            <button class="btn btn-primary" id="modalSaveBtn" onclick="adminMember.saveMember()">저장</button>
        </div>
    </div>
</div>

<!--<script src="<c:url value='/js/admin/admin_common.js'/>"></script>-->

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
				approvalStatus: '${member.userRole}' === 'ADMIN' ? 'ADM' : 
								                               ('${member.status}' === 'true' || '${member.status}' === 'ACT' ? 'ACT' : 'WAIT')
				            });

        </c:forEach>
    </c:if>
</script>

<script src="<c:url value='/js/admin/member_list.js'/>"></script>

</body>
</html>