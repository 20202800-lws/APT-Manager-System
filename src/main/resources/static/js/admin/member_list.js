/* =========================================
   1. 데이터 (Mock Data - UserVO 구조 매핑)
   ========================================= */
// [MOD] ERD 컬럼 기준 매핑: user_id, user_name, phone, join_date, approval_status
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
    // [MOD] status -> approvalStatus (ERD: approval_status)
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
        // 1. 탭 필터
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
        // 상태별 배지 및 버튼 설정
        let badgeHtml = '';
        let btnHtml = '';
        
        // [MOD] status -> approvalStatus
        // [MOD] memberId -> userId (PK 매핑)
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
            default: 
                badgeHtml = '<span class="badge badge-red">정지</span>';
                btnHtml = `<button class="btn btn-secondary btn-xs" onclick="openModal('${item.userId}')">상세</button>`;
        }

        let dongHoText = '';
        if(isNaN(item.dong)) {
             dongHoText = item.dong; 
        } else {
             dongHoText = `${item.dong}동 ${item.ho}호`;
        }

        // [MOD] 변수명 매핑 (userName, phone, joinDate)
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
    // 데이터 타입(String/Number) 주의: ERD상 user_id는 varchar이므로 문자열 비교 권장
    const member = memberList.find(m => m.userId === String(id));
    
    // [MOD] memberName -> userName
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
    const item = memberList.find(d => d.userId === String(id));
    if(!item) return;

    currentUserId = id;

    // [MOD] DOM ID 변경 및 데이터 매핑
    // modalMemberName -> modalUserName (ERD: user_name)
    document.getElementById('modalUserName').value = item.userName;
    document.getElementById('modalDong').value = item.dong;
    document.getElementById('modalHo').value = item.ho;
    
    // modalPhoneNumber -> modalPhone (ERD: phone)
    document.getElementById('modalPhone').value = item.phone;
    document.getElementById('modalEmail').value = item.email;
    
    // modalRegDate -> modalJoinDate (ERD: join_date)
    document.getElementById('modalJoinDate').innerText = item.joinDate;
    
    // modalStatus -> modalApprovalStatus (ERD: approval_status)
    document.getElementById('modalApprovalStatus').value = item.approvalStatus;

    // 모달 표시
    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('show'), 10);
}

// 모달 저장 버튼
function saveMember() {
    // [MOD] memberId -> userId
    const item = memberList.find(d => d.userId === String(currentUserId));
    if(item) {
        // [MOD] 입력값 업데이트 (JSP ID 매칭 필수)
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
        currentUserId = null; // [MOD] 초기화
    }, 300);
}

// 배경 클릭 시 닫기
window.onclick = function(event) {
    if (event.target.className.includes('modal-overlay')) {
        closeModal();
    }
}