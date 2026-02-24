<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 관리비/수납 변경 이력</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../layout/admin_sidebar.jsp" />

    <main class="main-content">

        <div class="content-header">
            <h2>관리비/수납 변경 이력</h2>
            <div class="subtitle">관리비, 수도요금 등 금전 관련 데이터의 수동 변경 이력을 관리합니다.</div>
        </div>

        <div class="content-box">

            <div class="section-header" style="display: flex; justify-content: space-between; align-items: center;">
                
                <div class="section-actions" style="display: flex; gap: 10px; align-items: center;">
                    <select id="severityFilter" class="form-select" onchange="searchLogs()">
                        <option value="">전체</option>
                        <option value="INFO">정보</option>
                        <option value="WARNING">주의</option>
                        <option value="URGENT">긴급</option>
                    </select>

                    <input type="text" id="keyword" 
                           class="form-input" 
                           placeholder="사용자, 내용 검색"
                           onkeyup="if(event.keyCode===13) searchLogs()">

                    <button class="btn btn-primary" onclick="searchLogs()">검색</button>
                </div>

                <div>
                    <button class="btn btn-success" onclick="openLogModal()">+ 로그 작성</button>
                </div>
            </div>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="100">중요도</th>
                        <th width="180">일시</th>
                        <th width="120">사용자</th>
                        <th width="120">카테고리</th>
                        <th>내용</th>
                        <th width="140">IP</th>
                    </tr>
                </thead>
                <tbody id="logTableBody">
                </tbody>
            </table>

            <div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>

        </div>
    </main>
</div>

<div id="logModal" class="modal-overlay" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div class="modal-container" style="background:#fff; width:400px; padding:20px; border-radius:8px; display:flex; flex-direction:column; gap:15px;">
        
        <div class="content-header" style="margin-bottom:5px; display:flex; justify-content:space-between;">
            <h3 style="margin:0; font-size:1.3rem;">수동 변경 로그 작성</h3>
            <button onclick="closeLogModal()" style="border:none; background:none; font-size:1.2rem; cursor:pointer; color:#666;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        
        <div class="info-group">
            <label class="info-label" style="display:block; margin-bottom:5px; font-weight:600;">중요도</label>
            <select id="newSeverity" class="form-select" style="width:100%;">
                <option value="INFO">정보 (일반 수정)</option>
                <option value="WARNING">주의 (금액 큰 폭 변경)</option>
                <option value="URGENT">긴급 (오납금 환불 등)</option>
            </select>
        </div>

        <div class="info-group">
            <label class="info-label" style="display:block; margin-bottom:5px; font-weight:600;">카테고리</label>
            <select id="newCategory" class="form-select" style="width:100%;">
                <option value="수정">수정</option>
                <option value="추가">추가</option>
                <option value="삭제">삭제</option>
                <option value="기타">기타</option>
            </select>
        </div>

        <div class="info-group">
            <label class="info-label" style="display:block; margin-bottom:5px; font-weight:600;">변경 내용</label>
            <textarea id="newContent" class="form-input" style="width:100%; height:80px; resize:none; padding:10px;" placeholder="예: 105동 103호 수도요금 오기재 수정"></textarea>
        </div>

        <div style="text-align:right; margin-top:10px; display:flex; justify-content:flex-end; gap:10px;">
            <button class="btn btn-secondary" onclick="closeLogModal()">취소</button>
            <button id="saveLogBtn" class="btn btn-primary" onclick="saveLog()">작성 완료</button>
        </div>
    </div>
</div>

<script src="<c:url value='/js/admin/admin_common.js'/>"></script>
<script src="<c:url value='/js/admin/fee_log.js'/>"></script>

</body>
</html>