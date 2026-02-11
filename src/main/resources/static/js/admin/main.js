/* =========================================
   1. 데이터 (Mock Data - ERD 컬럼 매핑 완료)
   ========================================= */

// [통계 DTO] DashboardStatsVO
const statsData = {
    totalHouseholdCount: 1205, // select count(*) from USERS
    unprocessedMinwon: 5,      // select count(*) from COMPLAINT where comp_status != 'DONE'
    feePaymentRate: 92,        // calculated from MANAGE_FEE
    parkingRate: 88            // calculated
};

// [민원 DTO] ComplaintVO 리스트
// ERD Table: COMPLAINT (comp_id, category, title, reg_date, comp_status)
const recentMinwonList = [
    { compId: 1, category: '시설', title: '지하주차장 102동 입구 누수 발생', regDate: '2024-02-06', compStatus: 'WAIT' },
    { compId: 2, category: '소음', title: '윗집 층간소음 너무 심해요 (새벽)', regDate: '2024-02-05', compStatus: 'ING' },
    { compId: 3, category: '건의', title: '헬스장 이용 시간 연장 부탁드립니다', regDate: '2024-02-05', compStatus: 'WAIT' },
    { compId: 4, category: '시설', title: '놀이터 그네 줄이 끊어질 것 같아요', regDate: '2024-02-04', compStatus: 'DONE' },
    { compId: 5, category: '주차', title: '방문차량 등록이 안됩니다', regDate: '2024-02-04', compStatus: 'DONE' }
];

// [입주민 DTO] UsersVO 리스트 (승인 대기 상태)
// ERD Table: USERS (user_id, dong, ho, user_name, join_date, approval_status)
// [수정사항] memberId -> userId, memberName -> userName, regDate -> joinDate
const pendingMemberList = [
    { userId: 'user101', dong: '101', ho: '1502', userName: '김신입', joinDate: '2024-02-06' },
    { userId: 'user102', dong: '105', ho: '304', userName: '박이사', joinDate: '2024-02-06' },
    { userId: 'user103', dong: '102', ho: '1101', userName: '최입주', joinDate: '2024-02-05' },
    { userId: 'user104', dong: '103', ho: '505', userName: '정대기', joinDate: '2024-02-04' },
    { userId: 'user105', dong: '101', ho: '201', userName: '강부자', joinDate: '2024-02-03' }
];

/* =========================================
   2. 초기화 및 렌더링
   ========================================= */
document.addEventListener('DOMContentLoaded', () => {
    renderDate();
    renderStats();
    renderClaims();
    renderMembers();
});

// 날짜 표시
function renderDate() {
    const today = new Date();
    const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
    document.getElementById('currentDate').innerText = today.toLocaleDateString('ko-KR', options);
}

// 통계 렌더링
function renderStats() {
    document.getElementById('statTotalHouseholdCount').innerHTML = 
        `${statsData.totalHouseholdCount.toLocaleString()}<span class="unit">세대</span>`;
    
    document.getElementById('statUnprocessedMinwon').innerHTML = 
        `${statsData.unprocessedMinwon}<span class="unit">건</span>`;
    
    document.getElementById('statFeePaymentRate').innerHTML = 
        `${statsData.feePaymentRate}<span class="unit">%</span>`;
    
    document.getElementById('statParkingRate').innerHTML = 
        `${statsData.parkingRate}<span class="unit">%</span>`;
}

// 민원 목록 렌더링 (COMPLAINT 테이블 매핑)
function renderClaims() {
    const tbody = document.getElementById('minwonTableBody');
    
    if (recentMinwonList.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" style="color:#999; text-align:center; padding:15px;">최근 접수된 민원이 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = recentMinwonList.map(item => {
        let badge = '';
        // comp_status 값에 따른 배지 처리
        if(item.compStatus === 'WAIT') badge = '<span class="badge badge-red">대기</span>';
        else if(item.compStatus === 'ING') badge = '<span class="badge badge-blue">진행</span>'; 
        else badge = '<span class="badge badge-gray">완료</span>';

        // 카테고리 스타일
        let catColor = '#666';
        if(item.category === '시설') catColor = '#1A237E';

        return `
            <tr>
                <td style="color:${catColor}; font-weight:600;">${item.category}</td>
                <td class="td-title" onclick="alert('민원 상세(ID:${item.compId}) 이동')">
                    ${item.title}
                </td>
                <td style="color:#888; font-size:0.9rem;">${item.regDate}</td>
                <td>${badge}</td>
            </tr>
        `;
    }).join('');
}

// 입주 승인 대기 렌더링 (USERS 테이블 매핑)
function renderMembers() {
    const tbody = document.getElementById('memberTableBody');
    
    if (pendingMemberList.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" style="color:#999; text-align:center; padding:15px;">승인 대기 중인 회원이 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = pendingMemberList.map(item => {
        return `
            <tr>
                <td style="font-weight:600;">${item.dong}동 ${item.ho}호</td>
                <td>${item.userName}</td>
                <td style="color:#888; font-size:0.9rem;">${item.joinDate}</td>
                <td>
                    <button class="btn btn-primary btn-xs" onclick="quickApprove('${item.userId}', '${item.userName}')">
                        승인
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

/* =========================================
   3. 기능 로직 (AJAX 통신 예정)
   ========================================= */
function quickApprove(id, name) {
    // id: user_id (PK), name: user_name
    if(confirm(`${name} 님의 가입을 승인하시겠습니까?`)) {
        
        /* [AJAX 요청 예시]
           DTO 매핑: { "userId": "user101" } -> Controller에서 UsersVO로 수신
           fetch('/admin/member/approve', {
               method: 'POST',
               headers: { 'Content-Type': 'application/json' },
               body: JSON.stringify({ userId: id }) 
           })...
        */

        alert("승인 처리되었습니다.");
        
        // UI Optimistic Update
        const rowIndex = pendingMemberList.findIndex(m => m.userId === id);
        if(rowIndex > -1) {
            pendingMemberList.splice(rowIndex, 1);
            renderMembers();
            
            // 승인 시 총 세대수 증가 시뮬레이션
            // statsData.totalHouseholdCount++;
            // renderStats();
        }
    }
}