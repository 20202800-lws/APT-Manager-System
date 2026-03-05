/* =========================================
   관리자 | 관리비 관리 로직 (데이터 연동 & 페이징)
   ========================================= */

const feeManager = (function() {

    let feeData = window.globalFeeList || [];
    let currentTab = 'all';

    let currentPage = 1;
    const rowsPerPage = 10;

    document.addEventListener('DOMContentLoaded', () => {
        const monthInput = document.getElementById('searchYearMonth'); 
        if(monthInput && !monthInput.value) {
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            monthInput.value = `${yyyy}-${mm}`; 
        }

        updateStats();        
        filterTab('all');

        const modal = document.getElementById('feeModal');
        const regModal = document.getElementById('registerModal');
        window.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
            if (e.target === regModal) closeRegisterModal();
        });
    });

    function updateStats() {
        const totalAmount = feeData.reduce((acc, cur) => acc + cur.totalCost, 0);
        document.getElementById('statTotalAmount').innerHTML = totalAmount.toLocaleString() + '<span style="font-size:1rem; color:#888; font-weight:400;">원</span>';

        const unpaidItems = feeData.filter(d => d.paymentStatus === 0);
        const unpaidAmount = unpaidItems.reduce((acc, cur) => acc + cur.totalCost, 0);
        
        document.getElementById('statUnpaidCount').innerText = unpaidItems.length;
        
        const unpaidAmountEl = document.getElementById('statUnpaidAmount');
        if(unpaidAmountEl) {
            unpaidAmountEl.innerText = '총 ' + unpaidAmount.toLocaleString() + '원';
        }

        const paidCount = feeData.filter(d => d.paymentStatus === 1).length;
        const rate = feeData.length > 0 ? Math.round((paidCount / feeData.length) * 100) : 0;
        document.getElementById('statPaymentRate').innerHTML = rate + '<span style="font-size:1rem; color:#888; font-weight:400;">%</span>';
    }

    function filterTab(status) {
        currentTab = status;

        const tabs = document.querySelectorAll('.tab-wrapper .tab-btn');
        tabs.forEach(btn => btn.classList.remove('active'));
        
        if (status === 'all' && tabs[0]) tabs[0].classList.add('active');
        else if (status === 'unpaid' && tabs[1]) tabs[1].classList.add('active');
        else if (status === 'paid' && tabs[2]) tabs[2].classList.add('active');

        const titles = { 'all': '전체 관리비 내역', 'unpaid': '미납 세대 목록', 'paid': '납부 완료 목록' };
        document.getElementById('listTitle').innerText = titles[status] || '관리비 내역';

        searchTable(false); 
    }

    function searchTable(isPageMove = false) {
        if (!isPageMove) currentPage = 1;

        const keyword = document.getElementById('searchKeyword').value.toLowerCase().trim();
        const selectedDate = document.getElementById('searchYearMonth').value; 
        
        let selYear = null, selMonth = null;
        if (selectedDate) {
            [selYear, selMonth] = selectedDate.split('-').map(Number);
        }

        const filtered = feeData.filter(item => {
            if (currentTab === 'unpaid' && item.paymentStatus === 1) return false;
            if (currentTab === 'paid' && item.paymentStatus === 0) return false;

            if (selYear && selMonth) {
                if (item.useYear !== selYear || item.useMonth !== selMonth) return false;
            }
            
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

        const totalPages = Math.ceil(data.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = data.slice(startIndex, startIndex + rowsPerPage);

        const today = new Date(); 

        tbody.innerHTML = paginatedData.map(item => {
            let statusBadge = '';
            let dateText = '';
            let btnHtml = '';

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

    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        if (totalCount === 0) { 
            container.innerHTML = ''; 
            return; 
        }

        const totalPages = Math.ceil(totalCount / rowsPerPage);

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
       상세 모달 (기존 유지)
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

    /* =========================================
       ★ 수동 부과 (등록) 모달 로직 추가
       ========================================= */
    function openRegisterModal() {
        // 기본값 세팅 (이번달 기준)
        const today = new Date();
        document.getElementById('regYear').value = today.getFullYear();
        document.getElementById('regMonth').value = today.getMonth() + 1; // 이번 달
        
        document.getElementById('regDong').value = '';
        document.getElementById('regHo').value = '';
        document.getElementById('regCommon').value = '';
        document.getElementById('regElec').value = '';
        document.getElementById('regWater').value = '';
        document.getElementById('regEtc').value = '';

        document.getElementById('registerModal').style.display = 'flex';
    }

    function closeRegisterModal() {
        document.getElementById('registerModal').style.display = 'none';
    }

    // 서버로 데이터 전송 (자동 로그 저장됨)
    function submitRegisterFee() {
        const dong = document.getElementById('regDong').value.trim();
        const ho = document.getElementById('regHo').value.trim();
        const year = document.getElementById('regYear').value;
        const month = document.getElementById('regMonth').value;

        if(!dong || !ho || !year || !month) {
            alert("동, 호수, 연도, 월을 모두 입력해주세요.");
            return;
        }

        const data = {
            dong: dong,
            ho: ho,
            useYear: parseInt(year),
            useMonth: parseInt(month),
            commonFee: parseInt(document.getElementById('regCommon').value) || 0,
            elecFee: parseInt(document.getElementById('regElec').value) || 0,
            waterFee: parseInt(document.getElementById('regWater').value) || 0,
            etcFee: parseInt(document.getElementById('regEtc').value) || 0
        };

        fetch('/admin/fee/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
        .then(response => {
            if(!response.ok) {
                return response.text().then(msg => { throw new Error(msg); });
            }
            return response.text();
        })
        .then(msg => {
            alert(msg);
            location.reload(); // 성공 시 새로고침하여 데이터 반영
        })
        .catch(error => {
            alert("부과 실패: " + error.message);
        });
    }

    return { filterTab, searchTable, goToPage, openDetail, closeModal, openRegisterModal, closeRegisterModal, submitRegisterFee };

})();