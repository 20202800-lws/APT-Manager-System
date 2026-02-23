/* =========================================
   관리자 | 관리비 관리 로직 (데이터 연동 & 페이징)
   ========================================= */

const feeManager = (function() {

    // 1. 데이터 초기화 (JSP 전역 변수에서 호출)
    let feeData = window.globalFeeList || [];
    let currentTab = 'all';

    // 2. 페이징 관련 변수 설정
    let currentPage = 1;
    const rowsPerPage = 10;

    // 3. 초기 실행 (DOM 로드 후)
    document.addEventListener('DOMContentLoaded', () => {
        // 현재 연월을 YYYY-MM 형태로 기본 세팅 (원치 않으시면 제거 가능)
        const monthInput = document.getElementById('searchYearMonth'); 
        if(monthInput && !monthInput.value) {
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            monthInput.value = `${yyyy}-${mm}`; 
        }

        updateStats();        
        filterTab('all');

        // 모달 외부 클릭 시 닫기
        const modal = document.getElementById('feeModal');
        window.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });
    });

    /* =========================================
       상단 통계 (월 관계없이 전체 기준, 필요시 월별로 수정 가능)
       ========================================= */
    function updateStats() {
        const totalAmount = feeData.reduce((acc, cur) => acc + cur.totalCost, 0);
        document.getElementById('statTotalAmount').innerHTML = totalAmount.toLocaleString() + '<span style="font-size:1rem; color:#888; font-weight:400;">원</span>';

        const unpaidItems = feeData.filter(d => d.paymentStatus === 0);
        const unpaidAmount = unpaidItems.reduce((acc, cur) => acc + cur.totalCost, 0);
        
        document.getElementById('statUnpaidCount').innerText = unpaidItems.length;
        document.getElementById('statUnpaidAmount').innerText = '총 ' + unpaidAmount.toLocaleString() + '원';

        const paidCount = feeData.filter(d => d.paymentStatus === 1).length;
        const rate = feeData.length > 0 ? Math.round((paidCount / feeData.length) * 100) : 0;
        document.getElementById('statPaymentRate').innerHTML = rate + '<span style="font-size:1rem; color:#888; font-weight:400;">%</span>';
    }

    /* =========================================
       탭 전환 필터링
       ========================================= */
    function filterTab(status) {
        currentTab = status;

        const tabs = document.querySelectorAll('.tab-btn');
        tabs.forEach((btn, index) => {
            if (status === 'all' && index === 0) btn.classList.add('active');
            else if (status === 'unpaid' && index === 1) btn.classList.add('active');
            else if (status === 'paid' && index === 2) btn.classList.add('active');
            else btn.classList.remove('active');
        });

        const titles = { 'all': '전체 관리비 내역', 'unpaid': '미납 세대 목록', 'paid': '납부 완료 목록' };
        document.getElementById('listTitle').innerText = titles[status] || '관리비 내역';

        searchTable(false); // 탭을 변경하면 1페이지로 초기화
    }

    /* =========================================
       검색 및 페이징
       ========================================= */
    function searchTable(isPageMove = false) {
        if (!isPageMove) currentPage = 1;

        const keyword = document.getElementById('searchKeyword').value.toLowerCase().trim();
        const selectedDate = document.getElementById('searchYearMonth').value; // 'YYYY-MM'
        
        let selYear = null, selMonth = null;
        if (selectedDate) {
            [selYear, selMonth] = selectedDate.split('-').map(Number);
        }

        const filtered = feeData.filter(item => {
            // 탭 필터
            if (currentTab === 'unpaid' && item.paymentStatus === 1) return false;
            if (currentTab === 'paid' && item.paymentStatus === 0) return false;

            // 날짜 필터
            if (selYear && selMonth) {
                if (item.useYear !== selYear || item.useMonth !== selMonth) return false;
            }
            
            // 검색어 필터 (동/호수 혼합 검색)
            const unitStr = `${item.dong}-${item.ho}`; 
            if (keyword && !unitStr.includes(keyword) && !item.dong.includes(keyword) && !item.ho.includes(keyword)) return false;

            return true;
        });

        renderTable(filtered);
    }

    function renderTable(data) {
        const tbody = document.getElementById('feeTableBody');
        
        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="padding:40px; color:#999; text-align:center;">조건에 맞는 내역이 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        // 페이징 자르기 처리
        const totalPages = Math.ceil(data.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = data.slice(startIndex, startIndex + rowsPerPage);

        const today = new Date(); // 실제 오늘 날짜 적용

        tbody.innerHTML = paginatedData.map(item => {
            let statusBadge = '';
            let dateText = '';
            let btnHtml = '';

            // 연체 로직 (매월 25일을 마감일로 간주)
            const dueDate = new Date(item.useYear, item.useMonth - 1, 25); 
            const isOverdue = (item.paymentStatus === 0 && today > dueDate);

            if (item.paymentStatus === 1) { 
                statusBadge = '<span class="badge badge-success">납부완료</span>';
                dateText = `<span style="color:#333;">-</span>`; 
                btnHtml = `<button class="btn btn-secondary btn-xs" onclick="feeManager.openDetail(${item.feeId})"><i class="fa-solid fa-list"></i> 상세</button>`;
            } else if (isOverdue) {
                statusBadge = '<span class="badge badge-danger">연체</span>'; 
                dateText = `<span style="color:#D32F2F; font-weight:bold;">마감: ${item.useMonth}/25</span>`;
                btnHtml = `<button class="btn btn-secondary btn-xs" style="color:var(--danger); border-color:var(--danger);" onclick="feeManager.openDetail(${item.feeId})"><i class="fa-solid fa-bell"></i> 독촉</button>`;
            } else {
                statusBadge = '<span class="badge badge-secondary">미납</span>'; 
                dateText = `<span style="color:#666;">마감: ${item.useMonth}/25</span>`;
                btnHtml = `<button class="btn btn-secondary btn-xs" onclick="feeManager.openDetail(${item.feeId})"><i class="fa-solid fa-check"></i> 확인</button>`;
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

        renderPagination(data.length);
    }

    // 하단 페이징 렌더링
    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        const totalPages = Math.ceil(totalCount / rowsPerPage);
        if(totalPages <= 1) { container.innerHTML = ''; return; }

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="feeManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="feeManager.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="feeManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    function goToPage(page) {
        currentPage = page;
        searchTable(true);
    }

    /* =========================================
       모달 창 제어 로직
       ========================================= */
    function openDetail(id) {
        const item = feeData.find(d => d.feeId === id);
        if(!item) return;

        document.getElementById('modalDongHo').innerText = `${item.dong}동 ${item.ho}호`;
        document.getElementById('modalUseDate').innerText = `${item.useYear}년 ${item.useMonth}월`;
        document.getElementById('modalTotalCost').innerText = item.totalCost.toLocaleString() + '원';
        
        const badgeEl = document.getElementById('modalPaymentStatus');
        if(item.paymentStatus === 1) {
            badgeEl.innerHTML = '<span class="badge badge-success">납부완료</span>';
        } else {
            badgeEl.innerHTML = '<span class="badge badge-danger">미납</span>';
        }

        document.getElementById('modalCommonFee').innerText = (item.commonFee || 0).toLocaleString() + '원';
        document.getElementById('modalElecFee').innerText = (item.elecFee || 0).toLocaleString() + '원';
        document.getElementById('modalWaterFee').innerText = (item.waterFee || 0).toLocaleString() + '원';
        document.getElementById('modalEtcFee').innerText = (item.etcFee || 0).toLocaleString() + '원';

        const actionBtn = document.getElementById('modalActionBtn');
        if(item.paymentStatus === 1) {
            actionBtn.innerText = "납부 확인증 출력";
            actionBtn.className = "btn btn-secondary";
            actionBtn.onclick = () => alert(`[${item.dong}-${item.ho}] 납부 확인증을 출력합니다.`);
        } else {
            actionBtn.innerText = "납부 독촉 알림 발송";
            actionBtn.className = "btn btn-primary";
            // [실제 연동 시 여기서 AJAX 요청 전송]
            actionBtn.onclick = () => {
                alert(`[${item.dong}-${item.ho}] 세대로 알림이 발송되었습니다.`);
                closeModal();
            };
        }

        const modal = document.getElementById('feeModal');
        modal.style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('feeModal').style.display = 'none';
    }

    // 외부로 노출할 함수들 지정
    return {
        filterTab, searchTable, goToPage, openDetail, closeModal
    };

})();