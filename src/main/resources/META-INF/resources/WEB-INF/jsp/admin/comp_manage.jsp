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

    <style>
        /* CSS는 이전과 동일하므로 생략, ID 선택자만 JS와 일치시킴 */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 9999; align-items: center; justify-content: center; }
        .modal-overlay.active { display: flex; }
        .modal-container { width: 600px; background: #fff; padding: 30px; border-radius: 12px; display: flex; flex-direction: column; gap: 20px; }
        .complaint-info { background: #F8F9FA; padding: 15px; border-radius: 8px; border: 1px solid #eee; }
        .info-row { display: flex; margin-bottom: 8px; font-size: 0.95rem; }
        .info-label { width: 80px; font-weight: 600; color: #555; }
        .info-value { flex: 1; color: #333; }
    </style>
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
                <div class="number text-primary" id="statTotalCount">0<span class="unit">건</span></div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>신규 접수</h3>
                <div class="number text-danger" id="statPendingCount">0<span class="unit">건</span></div>
            </div>
            <div class="stat-card border-left-info">
                <h3>처리 중</h3>
                <div class="number text-info" id="statProcessingCount">0<span class="unit">건</span></div>
            </div>
            <div class="stat-card border-left-success">
                <h3>처리 완료</h3>
                <div class="number text-success" id="statCompletedCount">0<span class="unit">건</span></div>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title">접수 목록</h3>
                <div class="section-actions">
                    <select class="form-select" id="categoryFilter" onchange="complaintManager.searchTable()">
                        <option value="">전체 유형</option>
                        <option value="FACILITY">시설보수</option>
                        <option value="NOISE">층간소음</option>
                        <option value="PARKING">주차문제</option>
                        <option value="ETC">기타</option>
                    </select>
                    <select class="form-select" id="statusFilter" onchange="complaintManager.searchTable()">
                        <option value="">전체 상태</option>
                        <option value="PENDING">접수</option>
                        <option value="PROCESSING">진행중</option>
                        <option value="COMPLETED">완료</option>
                    </select>
                    <input type="text" class="form-input" id="keyword" placeholder="작성자 또는 제목" 
                           onkeyup="if(window.event.keyCode==13){complaintManager.searchTable()}">
                    <button class="btn btn-secondary" onclick="complaintManager.searchTable()">
                        <i class="fa-solid fa-search"></i>
                    </button>
                </div>
            </div>

            <table class="admin-table">
                <colgroup>
                    <col width="10%"> <col width="10%"> <col width="*">
                    <col width="15%"> <col width="15%"> <col width="10%"> <col width="10%">
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
        </div>
    </main>
</div>

<div id="complaintModal" class="modal-overlay">
    <div class="modal-container">
        <div class="content-header" style="margin:0; display:flex; justify-content:space-between;">
            <h3>민원 상세 및 답변</h3>
            <button onclick="complaintManager.closeModal()" style="border:none; background:none; cursor:pointer;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        
        <input type="hidden" id="targetCompId"> 
        
        <div class="complaint-info">
            <div class="info-row"><div class="info-label">유형</div><div class="info-value" id="modalCategory"></div></div>
            <div class="info-row"><div class="info-label">작성자</div><div class="info-value" id="modalUserName"></div></div>
            <div class="info-row"><div class="info-label">접수일</div><div class="info-value" id="modalRegDate"></div></div>
            <div class="info-row" style="margin-top:10px;"><div class="info-label">내용</div></div>
            <div style="background:#fff; padding:10px; border:1px solid #ddd; min-height:80px;" id="modalContent"></div>
        </div>

        <div>
            <label style="font-size:0.9rem; font-weight:600; margin-bottom:5px; display:block;">관리자 답변</label>
            <textarea id="modalReply" class="form-input" style="width:100%; height:100px; padding:10px; resize:none;" placeholder="답변을 입력하세요"></textarea>
        </div>

        <div style="display:flex; justify-content:space-between; align-items:center;">
            <select id="modalCompStatus" class="form-select" style="width:150px;">
                <option value="PENDING">접수 (대기)</option>
                <option value="PROCESSING">진행중</option>
                <option value="COMPLETED">처리 완료</option>
            </select>
            <div style="display:flex; gap:10px;">
                <button class="btn btn-secondary" onclick="complaintManager.closeModal()">닫기</button>
                <button class="btn btn-primary" onclick="complaintManager.saveComplaint()">저장</button>
            </div>
        </div>
    </div>
</div>

<script src="<c:url value='/js/admin/complaint.js'/>"></script>
</body>
</html>