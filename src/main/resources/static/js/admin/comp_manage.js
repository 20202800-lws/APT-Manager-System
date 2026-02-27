/* =========================================
   민원 접수 현황 (Admin Complaint Logic)
   Refactored based on ERD: COMPLAINT Table (데이터 연동 및 페이징)
   ========================================= */

   const complaintManager = (function() {
       let complaintList = window.globalComplaintList || [];

       document.addEventListener('DOMContentLoaded', () => {
           // updateStats(); // 서버에서 값을 찍어주므로 호출 불필요 (필요시 제거)
           renderTable(complaintList); // 필터링 없이 받은 데이터 그대로 렌더링
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

    // === 페이징 유지를 위한 파라미터 추가 ===
	function searchTable() {
	    const type = document.getElementById('searchType').value;
	    const kw = document.getElementById('keyword').value;
	    
	    
	    const cat = document.getElementById('categoryFilter').value;
	    const stat = document.getElementById('statusFilter').value;

	    
	    location.href = `?page=0&searchType=${type}&keyword=${encodeURIComponent(kw)}&category=${cat}&status=${stat}`;
	}

    // === 데이터 페이징 자르기 추가 ===
	function renderTable(data) {
	    const tbody = document.getElementById('complaintTableBody');
	    if (!tbody) return;

	    if (!data || data.length === 0) {
	        tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:30px; color:#999;">접수된 민원이 없습니다.</td></tr>';
	        return;
	    }

	    const catMap = { 'FACILITY': '시설보수', 'NOISE': '층간소음', 'PARKING': '주차문제', 'ETC': '기타' };

		tbody.innerHTML = data.map(item => {
			let statusBadge = '';
			const status = (item.compStatus || "").toUpperCase();

			if (status === 'WAIT') {
			    statusBadge = '<span class="badge badge-gray">대기</span>'; // 아직 접수 전
			} else if (status === 'PENDING') {
			    statusBadge = '<span class="badge badge-danger">접수</span>'; // 접수됨 (시간기록됨)
			} else if (status === 'PROCESSING') {
			    statusBadge = '<span class="badge badge-info">진행중</span>';
			} else if (status === 'COMPLETED') {
			    statusBadge = '<span class="badge badge-success">완료</span>';
			}

	        return `
	            <tr>
	                <td>${item.compId}</td>
	                <td><span class="category-tag">${catMap[item.category] || item.category}</span></td>
	                <td class="text-left" style="cursor:pointer; font-weight:500;" onclick="complaintManager.openModal(${item.compId})">
	                    ${item.title}
	                </td>
	                <td>${item.userName} <span style="font-size:0.8rem; color:#888;">(${item.userId})</span></td>
	                <td>${item.regDate}</td>
	                <td>${statusBadge}</td>
	                <td>
	                    <button class="btn btn-xs btn-outline-primary" onclick="complaintManager.openModal(${item.compId})">
	                        <i class="fa-solid fa-pen-to-square"></i> 관리
	                    </button>
	                </td>
	            </tr>
	        `;
	    }).join('');
	}

    // === 하단 페이징 버튼 생성 함수 ===
    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        // ★ 수정: 데이터가 0개일 때만 숨기고, 1페이지면 [1] 버튼 표시 유지
        if (totalCount === 0) {
            container.innerHTML = ''; 
            return; 
        }

        const totalPages = Math.ceil(totalCount / rowsPerPage);

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="complaintManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="complaintManager.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="complaintManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    // === 페이지 이동 함수 ===
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
        // ★ 수정: admin.css 표준 모달 방식으로 변경
        if(modal) modal.style.display = 'flex';
    }

    function closeModal() {
        const modal = document.getElementById('complaintModal');
        // ★ 수정: admin.css 표준 모달 방식으로 변경
        if(modal) modal.style.display = 'none';
    }

	function saveComplaint() {
	    const id = document.getElementById('targetCompId').value;
	    const reply = document.getElementById('modalReply').value;
	    const status = document.getElementById('modalCompStatus').value; // 상태값 가져오기

	    fetch('/admin/reply', {
	        method: 'POST',
	        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	        // 파라미터에 &status= 추가
	        body: `compId=${id}&replyContent=${encodeURIComponent(reply)}&status=${status}`
	    })
	    .then(res => res.text())
	    .then(data => {
	        if(data === 'success') {
	            alert("저장되었습니다.");
	            location.reload(); 
	        }
	    });
	}

    return { 
        openModal, closeModal, saveComplaint, searchTable
    };

})();