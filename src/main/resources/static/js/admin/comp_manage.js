/* =========================================
   민원 접수 현황 (Admin Complaint Logic)
   Refactored based on ERD: COMPLAINT Table (데이터 연동 및 페이징)
   ========================================= */

const complaintManager = (function() {

    // 1. Data Initialization (JSP에서 넘겨받은 전역 데이터 사용)
    let complaintList = window.globalComplaintList || [];

    // === 페이징 관련 변수 ===
    let currentPage = 1;
    const rowsPerPage = 10;

    document.addEventListener('DOMContentLoaded', () => {
        updateStats();
        searchTable(false); // 초기 렌더링
        
        // Modal Outside Click Close
        const modal = document.getElementById('complaintModal');
        window.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });
    });

    /* =========================================
       2. Logic Functions
       ========================================= */
    function updateStats() {
        const setHtml = (id, count) => {
            const el = document.getElementById(id);
            if(el) el.innerHTML = `${count}<span class="unit">건</span>`;
        };

        setHtml('statPendingCount', complaintList.filter(d => d.compStatus === 'PENDING').length);
        setHtml('statProcessingCount', complaintList.filter(d => d.compStatus === 'PROCESSING').length);
        setHtml('statCompletedCount', complaintList.filter(d => d.compStatus === 'COMPLETED').length);
        setHtml('statTotalCount', complaintList.length);
    }

    // === [수정] 페이징 유지를 위한 파라미터 추가 ===
    function searchTable(isPageMove = false) {
        if (!isPageMove) currentPage = 1;

        const categoryVal = document.getElementById('categoryFilter').value;
        const statusVal = document.getElementById('statusFilter').value;
        const keyword = document.getElementById('keyword').value.toLowerCase().trim();

        const filtered = complaintList.filter(item => {
            if (categoryVal && item.category !== categoryVal) return false;
            if (statusVal && item.compStatus !== statusVal) return false;
            
            if (keyword) {
                const matchTitle = item.title.toLowerCase().includes(keyword);
                const matchUser = item.userName.toLowerCase().includes(keyword);
                if (!matchTitle && !matchUser) return false;
            }
            return true;
        });
        
        renderTable(filtered);
    }

    // === [수정] 데이터 페이징 자르기 추가 ===
    function renderTable(data) {
        const tbody = document.getElementById('complaintTableBody');
        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="padding:40px; text-align:center; color:#999;">데이터가 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        // 페이징 계산
        const totalPages = Math.ceil(data.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = data.slice(startIndex, startIndex + rowsPerPage);

        tbody.innerHTML = paginatedData.map(item => {
            let catName = '기타';
            let catClass = 'badge-gray';
            
            switch(item.category) {
                case 'FACILITY': catName = '시설보수'; catClass = 'badge-red'; break;
                case 'NOISE': catName = '층간소음'; catClass = 'badge-blue'; break;
                case 'PARKING': catName = '주차문제'; catClass = 'badge-warning'; break;
                case 'ETC': catName = '기타'; catClass = 'badge-gray'; break;
            }

            let statusBadge = '';
            if(item.compStatus === 'PENDING') statusBadge = '<span class="badge badge-gray">접수</span>';
            else if(item.compStatus === 'PROCESSING') statusBadge = '<span class="badge badge-blue">진행중</span>';
            else if(item.compStatus === 'COMPLETED') statusBadge = '<span class="badge badge-green">완료</span>';

            return `
                <tr>
                    <td style="color:#666;">${item.compId}</td>
                    <td><span class="badge ${catClass}">${catName}</span></td>
                    <td style="text-align:left; padding-left:15px; font-weight:500; cursor:pointer; color:#333;" 
                        onclick="complaintManager.openModal(${item.compId})">
                        ${item.title}
                    </td>
                    <td>${item.userName}</td>
                    <td style="color:#666;">${item.regDate}</td>
                    <td>${statusBadge}</td>
                    <td>
                        <button class="btn btn-secondary btn-xs" onclick="complaintManager.openModal(${item.compId})">
                            <i class="fa-solid fa-pen-to-square"></i> 관리
                        </button>
                    </td>
                </tr>
            `;
        }).join('');

        renderPagination(data.length);
    }

    // === [추가] 하단 페이징 버튼 생성 함수 ===
    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        const totalPages = Math.ceil(totalCount / rowsPerPage);
        if(totalPages <= 1) { container.innerHTML = ''; return; }

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="complaintManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="complaintManager.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="complaintManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    // === [추가] 페이지 이동 함수 ===
    function goToPage(page) {
        currentPage = page;
        searchTable(true);
    }

    /* =========================================
       3. Modal Logic
       ========================================= */
    function openModal(id) {
        const item = complaintList.find(d => d.compId === id);
        if(!item) return;

        const catMap = { 'FACILITY': '시설보수', 'NOISE': '층간소음', 'PARKING': '주차문제', 'ETC': '기타' };

        document.getElementById('targetCompId').value = item.compId; 
        document.getElementById('modalCategory').innerText = catMap[item.category] || item.category;
        document.getElementById('modalUserName').innerText = item.userName; 
        document.getElementById('modalRegDate').innerText = item.regDate;
        document.getElementById('modalContent').innerText = item.content;
        
        document.getElementById('modalReply').value = item.reply || ''; 
        document.getElementById('modalCompStatus').value = item.compStatus;

        const modal = document.getElementById('complaintModal');
        if(modal) modal.classList.add('active');
    }

    function closeModal() {
        const modal = document.getElementById('complaintModal');
        if(modal) modal.classList.remove('active');
    }

    function saveComplaint() {
        const id = parseInt(document.getElementById('targetCompId').value);
        const replyText = document.getElementById('modalReply').value;
        const statusText = document.getElementById('modalCompStatus').value;
        
        const item = complaintList.find(d => d.compId === id);
        if(item) {
            // [실제 연동 시 여기서 AJAX 요청 전송]
            item.reply = replyText;
            item.compStatus = statusText;
            
            alert("답변 및 상태가 저장되었습니다.");
            closeModal();
            updateStats();
            searchTable(true); // === [수정] 저장 후 현재 페이지 유지 ===
        }
    }

    return { 
        openModal, closeModal, saveComplaint, searchTable,
        goToPage // === [추가] 외부에서 접근 가능하도록 노출 ===
    };

})();