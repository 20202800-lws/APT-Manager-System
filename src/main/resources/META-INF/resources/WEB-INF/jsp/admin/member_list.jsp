<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 회원 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="<c:url value='/resources/css/admin.css'/>">
</head>
<body>

<div class="admin-container">
    
    <jsp:include page="../../common/admin_sidebar.jsp" />

    <main class="main-content">
        
        <div class="content-header">
            <h2>회원 관리</h2>
            <p class="subtitle">입주민 가입 승인 및 권한 설정</p>
        </div>

        <div class="stat-grid-container grid-4">
            <div class="stat-card border-left-primary">
                <h3>총 회원 수</h3>
                <div class="number text-primary" id="statTotalCount">0<span class="unit">명</span></div>
                <div class="desc">전체 가입자</div>
            </div>
            <div class="stat-card border-left-warning">
                <h3>승인 대기</h3>
                <div class="number text-warning" id="statWaitCount">0<span class="unit">명</span></div>
                <div class="desc" style="font-weight:600; color:#d32f2f;">가입 승인 필요</div>
            </div>
            <div class="stat-card border-left-success">
                <h3>입주민 (정상)</h3>
                <div class="number text-success" id="statActiveCount">0<span class="unit">명</span></div>
                <div class="desc">활동 중인 입주민</div>
            </div>
            <div class="stat-card border-left-danger">
                <h3>관리자</h3>
                <div class="number text-danger" id="statAdminCount">0<span class="unit">명</span></div>
                <div class="desc">시스템 관리 권한</div>
            </div>
        </div>

        <div class="tab-wrapper">
            <div class="tab-container">
                <div class="tab-highlighter" id="tabHighlighter"></div>
                <button class="tab-btn active" onclick="filterTab('ALL', 0)">전체 회원</button>
                <button class="tab-btn" onclick="filterTab('WAIT', 1)">승인 대기</button>
                <button class="tab-btn" onclick="filterTab('ACT', 2)">입주민</button>
                <button class="tab-btn" onclick="filterTab('ADM', 3)">관리자</button>
            </div>
        </div>

        <div class="content-box">
            <div class="section-header">
                <h3 class="section-title" id="tableTitle">전체 회원 목록</h3>
                <div class="section-actions">
                    <input type="text" class="form-input" id="searchInput" placeholder="이름, 동/호수, 전화번호" onkeyup="searchTable()">
                    <button class="btn btn-primary" onclick="searchTable()"><i class="fa-solid fa-search"></i></button>
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

            <div style="margin-top:20px; text-align:center;">
                <button class="btn btn-secondary btn-xs" disabled>&lt;</button>
                <button class="btn btn-primary btn-xs">1</button>
                <button class="btn btn-secondary btn-xs">2</button>
                <button class="btn btn-secondary btn-xs">&gt;</button>
            </div>
        </div>

    </main>
</div>

<div id="memberModal" class="modal-overlay">
    <div class="modal-container" style="width: 550px;">
        <div class="content-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
            <h3 style="font-size:1.3rem; font-weight:700;">회원 상세 정보</h3>
            <button onclick="closeModal()" style="border:none; background:none; font-size:1.2rem; cursor:pointer; color:#666;">
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
            <button class="btn btn-danger" style="margin-right:auto;" onclick="alert('회원을 삭제하시겠습니까? (DB Soft Delete)')">삭제</button>
            <button class="btn btn-secondary" onclick="closeModal()">취소</button>
            <button class="btn btn-primary" id="modalSaveBtn" onclick="saveMember()">저장</button>
        </div>
    </div>
</div>

<script src="<c:url value='/resources/js/admin/admin_common.js'/>"></script>

<script>
/* =========================================
   1. 데이터 (Mock Data - MemberVO 구조)
   ========================================= */
// [MOD] Key값 변경: ERD 기준 (user_id, user_name, phone, join_date, approval_status)
let memberList = [
    { userId: '1', userName: '홍길동', dong: '101', ho: '101', phone: '010-1234-5678', email: 'hong@test.com', joinDate: '2024-02-01', approvalStatus: 'WAIT' },
    { userId: '2', userName: '김철수', dong: '102', ho: '205', phone: '010-2222-3333', email: 'kim@test.com', joinDate: '2024-01-28', approvalStatus: 'ACT' },
    { userId: '3', userName: '이영희', dong: '103', ho: '1501', phone: '010-3333-4444', email: 'lee@test.com', joinDate: '2024-01-15', approvalStatus: 'ACT' },
    { userId: '4', userName: '관리자', dong: '관리실', ho: '-', phone: '010-9999-9999', email: 'admin@apt.com', joinDate: '2023-01-01', approvalStatus: 'ADM' },
    { userId: '5', userName: '박민수', dong: '101', ho: '303', phone: '010-5555-6666', email: 'park@test.com', joinDate: '2024-02-04', approvalStatus: 'WAIT' }
];

let currentFilterCode = 'ALL'; // 현재 탭 상태 (ALL, WAIT, ACT, ADM)
const TAB_WIDTH = 140; 

// 초기 실행
document.addEventListener('DOMContentLoaded', () => {
    updateStats();
    filterTab('ALL', 0);
});

/* =========================================
   2. 통계 업데이트
   ========================================= */
function updateStats() {
    // [MOD] status -> approvalStatus
    const counts = {
        total: memberList.length,
        wait: memberList.filter(m => m.approvalStatus === 'WAIT').length,
        active: memberList.filter(m => m.approvalStatus === 'ACT').length,
        admin: memberList.filter(m => m.approvalStatus === 'ADM').length
    };

    document.getElementById('statTotalCount').innerHTML = `${counts.total}<span class="unit">명</span>`;
    document.getElementById('statWaitCount').innerHTML = `${counts.wait}<span class="unit">명</span>`;
    document.getElementById('statActiveCount').innerHTML = `${counts.active}<span class="unit">명</span>`;
    document.getElementById('statAdminCount').innerHTML = `${counts.admin}<span class="unit">명</span>`;
}

/* =========================================
   3. 탭 및 테이블 필터링
   ========================================= */
function filterTab(code, index) {
    currentFilterCode = code;

    // 1. 하이라이터 이동
    const highlighter = document.getElementById('tabHighlighter');
    if (highlighter) {
        highlighter.style.transform = `translateX(${index * TAB_WIDTH}px)`;
    }
    
    // 2. 버튼 활성화
    document.querySelectorAll('.tab-btn').forEach((btn, i) => {
        if(i === index) btn.classList.add('active');
        else btn.classList.remove('active');
    });

    // 3. 타이틀 변경
    const titles = { 
        'ALL': '전체 회원 목록', 
        'WAIT': '가입 승인 대기 목록', 
        'ACT': '입주민 회원 목록',
        'ADM': '관리자 목록'
    };
    document.getElementById('tableTitle').innerText = titles[code] || '회원 목록';

    searchTable();
}

function searchTable() {
    const keyword = document.getElementById('searchInput').value.toLowerCase();
    
    const filtered = memberList.filter(item => {
        // [MOD] status -> approvalStatus
        // 1. 탭 필터 (상태 코드 확인)
        if (currentFilterCode !== 'ALL' && item.approvalStatus !== currentFilterCode) return false;
        
        // 2. 검색 필터
        if (keyword) {
            const dongStr = String(item.dong);
            const hoStr = String(item.ho);
            
            // [MOD] memberName -> userName, phoneNumber -> phone
            return item.userName.toLowerCase().includes(keyword) || 
                   dongStr.includes(keyword) || 
                   hoStr.includes(keyword) || 
                   item.phone.includes(keyword);
        }
        return true;
    });

    renderTable(filtered);
}

function renderTable(data) {
    const tbody = document.getElementById('memberTableBody');
    
    if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="padding:30px; color:#999;">검색 결과가 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = data.map(item => {
        let badgeHtml = '';
        let btnHtml = '';
        
        // [MOD] status -> approvalStatus, memberId -> userId
        switch(item.approvalStatus) {
            case 'WAIT':
                badgeHtml = '<span class="badge badge-warning">승인대기</span>';
                btnHtml = `
                    <button class="btn btn-primary btn-xs" onclick="approveMember('${item.userId}')">승인</button>
                    <button class="btn btn-secondary btn-xs" onclick="openModal('${item.userId}')"><i class="fa-solid fa-gear"></i></button>
                `;
                break;
            case 'ACT':
                badgeHtml = '<span class="badge badge-success">입주민</span>';
                btnHtml = `<button class="btn btn-secondary btn-xs" onclick="openModal('${item.userId}')">상세</button>`;
                break;
            case 'ADM':
                badgeHtml = '<span class="badge badge-dark">관리자</span>';
                btnHtml = `<button class="btn btn-secondary btn-xs" onclick="openModal('${item.userId}')">관리</button>`;
                break;
            default: // BAN etc.
                badgeHtml = '<span class="badge badge-red">정지</span>';
                btnHtml = `<button class="btn btn-secondary btn-xs" onclick="openModal('${item.userId}')">상세</button>`;
        }

        let dongHoText = '';
        if(isNaN(item.dong)) {
             dongHoText = item.dong; 
        } else {
             dongHoText = `${item.dong}동 ${item.ho}호`;
        }

        // [MOD] 변수명 매핑 적용 (userName, phone, joinDate 등)
        return `
            <tr>
                <td>${badgeHtml}</td>
                <td style="font-weight:600;">${dongHoText}</td>
                <td>${item.userName}</td>
                <td>${item.phone}</td>
                <td style="color:#666;">${item.email}</td>
                <td>${item.joinDate}</td>
                <td style="display:flex; justify-content:center; gap:5px;">
                    ${btnHtml}
                </td>
            </tr>
        `;
    }).join('');
}

/* =========================================
   4. 승인 및 상세 모달 기능
   ========================================= */
const modal = document.getElementById('memberModal');
let currentUserId = null; // [MOD] currentMemberId -> currentUserId

// 바로 승인 (리스트에서 클릭 시)
function approveMember(id) {
    // [MOD] memberId -> userId
    const member = memberList.find(m => m.userId === id);
    
    if(member && confirm(`${member.userName} 님의 가입을 승인하시겠습니까?`)) {
        // [MOD] status -> approvalStatus
        member.approvalStatus = 'ACT'; 
        
        updateStats(); 
        searchTable(); 
        alert("승인 처리되었습니다.");
    }
}

// 모달 열기
function openModal(id) {
    // [MOD] memberId -> userId
    const item = memberList.find(d => d.userId === id);
    if(!item) return;

    currentUserId = id;

    // [MOD] 데이터 바인딩 (HTML ID 및 객체 Key 매핑)
    // modalMemberName -> modalUserName, item.memberName -> item.userName
    document.getElementById('modalUserName').value = item.userName;
    document.getElementById('modalDong').value = item.dong;
    document.getElementById('modalHo').value = item.ho;
    // modalPhoneNumber -> modalPhone, item.phoneNumber -> item.phone
    document.getElementById('modalPhone').value = item.phone;
    document.getElementById('modalEmail').value = item.email;
    // modalRegDate -> modalJoinDate, item.regDate -> item.joinDate
    document.getElementById('modalJoinDate').innerText = item.joinDate;
    // modalStatus -> modalApprovalStatus, item.status -> item.approvalStatus
    document.getElementById('modalApprovalStatus').value = item.approvalStatus;

    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('show'), 10);
}

// 모달 저장 버튼
function saveMember() {
    // [MOD] memberId -> userId
    const item = memberList.find(d => d.userId === currentUserId);
    if(item) {
        // [MOD] 변수명 매핑 업데이트
        item.userName = document.getElementById('modalUserName').value;
        item.dong = document.getElementById('modalDong').value;
        item.ho = document.getElementById('modalHo').value;
        item.phone = document.getElementById('modalPhone').value;
        item.approvalStatus = document.getElementById('modalApprovalStatus').value;
        
        alert('회원 정보가 수정되었습니다.');
        closeModal();
        updateStats();
        searchTable();
    }
}

function closeModal() {
    modal.classList.remove('show');
    setTimeout(() => {
        modal.style.display = 'none';
        currentUserId = null; // [MOD] currentMemberId -> currentUserId
    }, 300);
}

window.onclick = function(event) {
    if (event.target.className.includes('modal-overlay')) {
        closeModal();
    }
}
</script>

</body>
</html>