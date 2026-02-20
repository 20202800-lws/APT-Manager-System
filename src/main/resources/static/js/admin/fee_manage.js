/* =========================================
   1. 샘플 데이터 (ERD: MANAGE_FEE 구조 기반)
   ========================================= */
// ERD Table: MANAGE_FEE (fee_id, dong, ho, use_year, use_month, total_cost, payment_status)
// [수정사항] isPaid -> paymentStatus (tinyint: 0 or 1)
const feeData = [
    { 
        feeId: 1, dong: '101', ho: '1502', useYear: 2024, useMonth: 2, 
        totalCost: 245000, paymentStatus: 0,  // 0: 미납
        // DTO 확장 필드 (FEE_DETAIL 집계)
        commonFee: 120000, elecFee: 85000, waterFee: 30000, etcFee: 10000 
    },
    { 
        feeId: 2, dong: '103', ho: '805', useYear: 2024, useMonth: 2, 
        totalCost: 189000, paymentStatus: 1,  // 1: 납부완료
        commonFee: 120000, elecFee: 45000, waterFee: 20000, etcFee: 4000 
    },
    { 
        feeId: 3, dong: '102', ho: '304', useYear: 2024, useMonth: 2, 
        totalCost: 310000, paymentStatus: 1, 
        commonFee: 120000, elecFee: 150000, waterFee: 35000, etcFee: 5000 
    },
    { 
        feeId: 4, dong: '105', ho: '1001', useYear: 2024, useMonth: 2, 
        totalCost: 215000, paymentStatus: 0, 
        commonFee: 120000, elecFee: 60000, waterFee: 25000, etcFee: 10000 
    },
    { 
        // 1월 데이터 (연체 시뮬레이션용)
        feeId: 5, dong: '101', ho: '202', useYear: 2024, useMonth: 1, 
        totalCost: 198000, paymentStatus: 0, 
        commonFee: 120000, elecFee: 50000, waterFee: 20000, etcFee: 8000 
    }
];

// 상태 변수
let currentTab = 'all';

/* =========================================
   2. 초기화
   ========================================= */
document.addEventListener('DOMContentLoaded', () => {
    // JSP의 input ID
    const monthInput = document.getElementById('searchYearMonth'); 
    if(monthInput) monthInput.value = '2024-02'; 

    updateStats();        
    filterTab('all');
});

/* =========================================
   3. 통계 업데이트 (Mapped: totalCost, paymentStatus)
   ========================================= */
function updateStats() {
    // 총 부과액 (total_cost)
    const totalAmount = feeData.reduce((acc, cur) => acc + cur.totalCost, 0);
    document.getElementById('statTotalAmount').innerHTML = totalAmount.toLocaleString() + '<span style="font-size:1rem; color:#888; font-weight:400;">원</span>';

    // 미납 (payment_status === 0)
    const unpaidItems = feeData.filter(d => d.paymentStatus === 0);
    const unpaidAmount = unpaidItems.reduce((acc, cur) => acc + cur.totalCost, 0);
    
    document.getElementById('statUnpaidCount').innerText = unpaidItems.length;
    document.getElementById('statUnpaidAmount').innerText = '총 ' + unpaidAmount.toLocaleString() + '원';

    // 납부율
    const paidCount = feeData.filter(d => d.paymentStatus === 1).length;
    const rate = feeData.length > 0 ? Math.round((paidCount / feeData.length) * 100) : 0;
    document.getElementById('statPaymentRate').innerHTML = rate + '<span style="font-size:1rem; color:#888; font-weight:400;">%</span>';
}

/* =========================================
   4. 탭 전환
   ========================================= */
function filterTab(status) {
    currentTab = status;

    // 탭 버튼 UI 업데이트
    const tabs = document.querySelectorAll('.tab-btn');
    tabs.forEach((btn, index) => {
        if (status === 'all' && index === 0) btn.classList.add('active');
        else if (status === 'unpaid' && index === 1) btn.classList.add('active');
        else if (status === 'paid' && index === 2) btn.classList.add('active');
        else btn.classList.remove('active');
    });

    const titles = { 'all': '전체 관리비 내역', 'unpaid': '미납 세대 목록', 'paid': '납부 완료 목록' };
    document.getElementById('listTitle').innerText = titles[status] || '관리비 내역';

    searchTable();
}

/* =========================================
   5. 검색 및 테이블 렌더링 (핵심 로직)
   ========================================= */
function searchTable() {
    const keyword = document.getElementById('searchKeyword').value.toLowerCase();
    const selectedDate = document.getElementById('searchYearMonth').value; // '2024-02'
    
    const [selYear, selMonth] = selectedDate.split('-').map(Number);

    const filtered = feeData.filter(item => {
        // 1. 탭 필터 (DB값 paymentStatus 기준)
        if (currentTab === 'unpaid' && item.paymentStatus === 1) return false;
        if (currentTab === 'paid' && item.paymentStatus === 0) return false;

        // 2. 날짜 필터 (DB값 useYear, useMonth 기준)
        if (selectedDate) {
            if (item.useYear !== selYear || item.useMonth !== selMonth) return false;
        }
        
        // 3. 검색어 필터 (동/호수)
        const unitStr = `${item.dong}-${item.ho}`; 
        if (keyword && !unitStr.includes(keyword) && !item.dong.includes(keyword)) return false;

        return true;
    });

    renderTable(filtered);
}

function renderTable(data) {
    const tbody = document.getElementById('feeTableBody');
    
    if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="padding:30px; color:#999; text-align:center;">조건에 맞는 내역이 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = data.map(item => {
        let statusBadge = '';
        let dateText = '';
        let btnHtml = '';

        // "연체" 여부 판단 (납부마감일: 매월 25일 가정)
        const today = new Date('2024-03-01'); 
        const dueDate = new Date(item.useYear, item.useMonth - 1, 25); 
        // paymentStatus === 0 이 미납
        const isOverdue = (item.paymentStatus === 0 && today > dueDate);

        if (item.paymentStatus === 1) { // 1: 납부완료
            statusBadge = '<span class="badge badge-success">납부완료</span>';
            dateText = `<span style="color:#333;">-</span>`; 
            btnHtml = `<button class="btn btn-secondary btn-xs" onclick="openDetail(${item.feeId})"><i class="fa-solid fa-list"></i> 상세</button>`;
        } else if (isOverdue) {
            statusBadge = '<span class="badge badge-danger">연체</span>'; 
            dateText = `<span style="color:#D32F2F; font-weight:bold;">마감: ${item.useMonth}/25</span>`;
            btnHtml = `<button class="btn btn-secondary btn-xs" style="color:var(--danger);" onclick="openDetail(${item.feeId})"><i class="fa-solid fa-bell"></i> 독촉</button>`;
        } else {
            statusBadge = '<span class="badge badge-secondary">미납</span>'; 
            dateText = `<span style="color:#666;">마감: ${item.useMonth}/25</span>`;
            btnHtml = `<button class="btn btn-secondary btn-xs" onclick="openDetail(${item.feeId})"><i class="fa-solid fa-check"></i> 확인</button>`;
        }

        return `
            <tr>
                <td style="font-weight:600;">${item.dong}동 ${item.ho}호</td>
                <td>${item.useYear}-${String(item.useMonth).padStart(2,'0')}</td>
                <td>${item.totalCost.toLocaleString()}원</td>
                <td>${statusBadge}</td>
                <td>${dateText}</td>
                <td style="display:flex; justify-content:center; gap:5px;">${btnHtml}</td>
            </tr>
        `;
    }).join('');
}

/* =========================================
   6. 모달 기능
   ========================================= */
function openDetail(id) {
    const item = feeData.find(d => d.feeId === id);
    if(!item) return;

    // 모달 데이터 바인딩
    document.getElementById('modalDongHo').innerText = `${item.dong}동 ${item.ho}호`;
    document.getElementById('modalUseDate').innerText = `${item.useYear}년 ${item.useMonth}월`;
    document.getElementById('modalTotalCost').innerText = item.totalCost.toLocaleString() + '원';
    
    // 상태 뱃지 업데이트
    const badgeEl = document.getElementById('modalPaymentStatus'); // ID 수정됨
    if(item.paymentStatus === 1) {
        badgeEl.innerHTML = '<span class="badge badge-success">납부완료</span>';
        badgeEl.className = '';
    } else {
        badgeEl.innerHTML = '<span class="badge badge-danger">미납</span>';
        badgeEl.className = '';
    }

    // 상세 내역 (FEE_DETAIL 테이블 데이터가 DTO로 Flatten 되었다고 가정)
    document.getElementById('modalCommonFee').innerText = (item.commonFee || 0).toLocaleString() + '원';
    document.getElementById('modalElecFee').innerText = (item.elecFee || 0).toLocaleString() + '원';
    document.getElementById('modalWaterFee').innerText = (item.waterFee || 0).toLocaleString() + '원';
    document.getElementById('modalEtcFee').innerText = (item.etcFee || 0).toLocaleString() + '원';

    // 버튼 동작 설정
    const actionBtn = document.getElementById('modalActionBtn');
    if(item.paymentStatus === 1) {
        actionBtn.innerText = "납부 확인증 출력";
        actionBtn.className = "btn btn-secondary";
        actionBtn.onclick = () => alert(`[${item.dong}-${item.ho}] 납부 확인증 출력`);
    } else {
        actionBtn.innerText = "납부 독촉 알림 발송";
        actionBtn.className = "btn btn-primary";
        actionBtn.onclick = () => alert(`[${item.dong}-${item.ho}] 알림 발송 완료`);
    }

    document.getElementById('feeModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('feeModal').style.display = 'none';
}