<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 공지사항 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../../common/admin_sidebar.jsp" />

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
                    <select class="form-select" id="searchFilter" onchange="searchTable()">
                        <option value="all">전체 상태</option>
                        <option value="public">공개</option>
                        <option value="private">비공개</option>
                    </select>
                    <input type="text" class="form-input" id="searchKeyword" placeholder="제목 검색" onkeyup="searchTable()">
                    <button class="btn btn-primary" onclick="searchTable()"><i class="fa-solid fa-search"></i></button>
                    
                    <button class="btn btn-dark" onclick="openModal('create')">
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

            <div style="margin-top:20px; text-align:center;">
                <button class="btn btn-secondary btn-xs" disabled>&lt;</button>
                <button class="btn btn-primary btn-xs">1</button>
                <button class="btn btn-secondary btn-xs">2</button>
                <button class="btn btn-secondary btn-xs">&gt;</button>
            </div>
        </div>

    </main>
</div>

<div id="noticeModal" class="modal-overlay">
    <div class="modal-container" style="width: 700px;">
        <div class="content-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
            <h3 style="font-size:1.3rem; font-weight:700;" id="modalTitle">공지사항 등록</h3>
            <button onclick="closeModal()" style="border:none; background:none; font-size:1.2rem; cursor:pointer; color:#666;">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        
        <form id="noticeForm" onsubmit="return false;">
            <input type="hidden" id="modalNoticeId" name="noticeId">

            <div class="form-grid" style="display:flex; flex-direction:column; gap:15px;">
                <div class="info-group">
                    <label class="info-label">제목</label>
                    <input type="text" class="form-input" id="inputTitle" name="title" placeholder="제목 입력" style="font-weight:500;">
                </div>

                <div style="display:flex; gap:20px; align-items:center; padding:15px; background:#f8f9fa; border-radius:8px;">
                    <label style="display:flex; align-items:center; cursor:pointer; gap:8px;">
                        <input type="checkbox" id="checkImportant" name="isImportant" style="transform:scale(1.2); accent-color:var(--danger);">
                        <span style="font-weight:600; color:var(--danger);">[필독] 상단 고정</span>
                    </label>
                    <div style="width:1px; height:20px; background:#ddd;"></div>
                    <label style="display:flex; align-items:center; cursor:pointer; gap:8px;">
                        <input type="checkbox" id="checkVisible" name="isVisible" checked style="transform:scale(1.2);">
                        <span>바로 공개하기</span>
                    </label>
                </div>

                <div class="info-group">
                    <label class="info-label">내용</label>
                    <textarea class="form-input" id="inputContent" name="content" rows="12" placeholder="내용을 입력하세요..." style="resize:vertical; line-height:1.6;"></textarea>
                </div>
            </div>

            <div style="margin-top:25px; display:flex; justify-content:flex-end; gap:10px;">
                <button class="btn btn-secondary" onclick="closeModal()">취소</button>
                <button class="btn btn-primary" onclick="saveNotice()">저장하기</button>
            </div>
        </form>
    </div>
</div>

<script src="<c:url value='/resources/js/admin/notice.js'/>"></script>

</body>
</html>