/* =========================================
   관리자 | 공지사항 관리 로직 (페이징 연동 완료)
   ========================================= */

const noticeManager = (function() {

    // 1. 데이터 초기화 (JSP 전역 변수에서 호출)
    let noticeList = window.globalNoticeList || [];
    let currentFilteredList = [];

    // 2. 페이징 관련 변수
    let currentPage = 1;
    const rowsPerPage = 10; 

    // 3. 초기 실행 (DOM 로드 후 안전하게 실행)
    document.addEventListener('DOMContentLoaded', () => {
        updateStats();
        //searchTable(true); // 초기 렌더링 시 조건 없는 검색(전체) & 1페이지로 시작
		// 서버에서 받은 데이터를 화면에 뿌려주는 역할만 수행
		renderTable(); 
		renderPagination();
        // 모달 외부 클릭 시 닫기
        const modal = document.getElementById('noticeModal');
        window.addEventListener('click', (event) => {
            if (event.target === modal) closeModal();
        });
    });

    /* =========================================
       로직 함수
       ========================================= */

    // 통계 갱신
	function updateStats() {
	    // 1. 서버에서 보낸 통계 데이터 가져오기 (없으면 0)
	    const stats = window.serverStats || { total: 0, important: 0, hidden: 0 };

	    // 2. 화면의 각 요소에 값 넣어주기
	    const statTotal = document.getElementById('statTotal');
	    if(statTotal) statTotal.innerHTML = `${stats.total}<span class="unit">건</span>`;
	    
	    const statImportant = document.getElementById('statImportant');
	    if(statImportant) statImportant.innerHTML = `${stats.important}<span class="unit">건</span>`;
	    
	    const statHidden = document.getElementById('statHidden');
	    if(statHidden) statHidden.innerHTML = `${stats.hidden}<span class="unit">건</span>`;
	}

    // 검색 및 필터링
    function searchTable(isResetPage = false) {
        /*if (isResetPage) currentPage = 1;

        const filterEl = document.getElementById('searchFilter');
        const filter = filterEl ? filterEl.value : 'all'; */
		const keywordInput = document.getElementById('searchKeyword');
		const keyword = keywordInput ? keywordInput.value.trim() : '';
		const filterEl = document.getElementById('searchFilter');
		const filter = filterEl ? filterEl.value : 'all';

		    // 검색 버튼을 누를 때만 실행됨
		location.href = `?page=0&searchInput=${encodeURIComponent(keyword)}&searchType=${filter}`;
        /*currentFilteredList = noticeList.filter(item => {
            // 상태 필터
            let statusMatch = true;
            if (filter === 'public') statusMatch = item.isVisible === true;
            if (filter === 'private') statusMatch = item.isVisible === false;

            // 검색어 필터
            const keywordMatch = item.title.toLowerCase().includes(keyword);

            return statusMatch && keywordMatch;
        });

        // 중요(필독) 공지가 상단에 오도록 정렬
        currentFilteredList.sort((a, b) => {
            if (a.isImportant && !b.isImportant) return -1;
            if (!a.isImportant && b.isImportant) return 1;
            return b.noticeId - a.noticeId; // 최신글(ID가 큰 것)이 위로 오도록
        });*/

        //renderTable();
    }

    // 테이블 렌더링 (페이징 적용)
	function renderTable() {
	    const tbody = document.getElementById('noticeTableBody');
	    if (!tbody) return;
	    
	    const data = window.globalNoticeList; // slice하지 않고 서버가 준 데이터 전체 사용

	    tbody.innerHTML = data.map(item => {
	        const titlePrefix = item.isImportant ? '<span style="color:var(--danger); font-weight:700; margin-right:5px;">[필독]</span>' : '';
	        const statusBadge = item.isVisible ? '<span class="badge badge-success">공개</span>' : '<span class="badge badge-secondary">비공개</span>';
	        
	        return `
	            <tr>
	                <td>${item.noticeId}</td>
	                <td style="text-align:left; font-weight:500; cursor:pointer;" class="td-title" onclick="noticeManager.openModal('edit', ${item.noticeId})">
	                    ${titlePrefix}${item.title}
	                </td>
	                <td>${item.writerId}</td>
	                <td>${item.regDate}</td>
	                <td>${item.views}</td>
	                <td>${statusBadge}</td>
	            </tr>
	        `;
	    }).join('');

	    //renderPagination(); // 아래에서 수정할 함수 호출
	}
    /*function renderTable() {
        const tbody = document.getElementById('noticeTableBody');
        if (!tbody) return;
        
        if (currentFilteredList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="padding:40px; color:#999; text-align:center;">조건에 맞는 공지사항이 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        const totalPages = Math.ceil(currentFilteredList.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = currentFilteredList.slice(startIndex, startIndex + rowsPerPage);

        tbody.innerHTML = paginatedData.map(item => {
            const titlePrefix = item.isImportant ? '<span style="color:var(--danger); font-weight:700; margin-right:5px;">[필독]</span>' : '';
            const statusBadge = item.isVisible ? '<span class="badge badge-success">공개</span>' : '<span class="badge badge-secondary">비공개</span>';
            
            return `
                <tr>
                    <td>${item.noticeId}</td>
                    <td style="text-align:left; font-weight:500; cursor:pointer;" class="td-title" onclick="noticeManager.openModal('edit', ${item.noticeId})">
                        ${titlePrefix}${item.title}
                    </td>
                    <td>${item.writerId}</td>
                    <td>${item.regDate}</td>
                    <td>${item.views}</td>
                    <td>${statusBadge}</td>
                </tr>
            `;
        }).join('');

        renderPagination(currentFilteredList.length);
    }*/

    // 페이징 버튼 렌더링
	function renderPagination() {
	    const container = document.getElementById('paginationWrapper');
	    const info = window.serverPaging; // 서버에서 넘겨준 정보 사용
	    
	    if (!container || info.totalPages <= 1) {
	        container.innerHTML = ''; 
	        return;
	    }

	    let html = '';
	    // 이전 버튼
	    const prevPage = info.currentPage - 1;
	    html += `<button class="btn btn-secondary btn-xs" ${info.currentPage === 0 ? 'disabled' : `onclick="noticeManager.goToPage(${prevPage})"`}>&lt;</button> `;

	    // 페이지 번호
	    for (let i = 0; i < info.totalPages; i++) {
	        const activeClass = i === info.currentPage ? 'btn-primary' : 'btn-secondary';
	        html += `<button class="btn ${activeClass} btn-xs" onclick="noticeManager.goToPage(${i})">${i + 1}</button> `;
	    }

	    // 다음 버튼
	    const nextPage = info.currentPage + 1;
	    html += `<button class="btn btn-secondary btn-xs" ${info.currentPage >= info.totalPages - 1 ? 'disabled' : `onclick="noticeManager.goToPage(${nextPage})"`}>&gt;</button>`;
	    
	    container.innerHTML = html;
	}

	// 페이지 이동 시 서버에 새로 요청
	function goToPage(page) {
		alert(page + "페이지로 이동 시도!"); // 이 창이 뜨는지 확인
	        const info = window.serverPaging;
	        if (!info) return;
	        
	        // 컨트롤러가 받는 파라미터명(searchInput)과 동일하게 맞춤
	        const keyword = info.keyword || "";
	        const type = info.searchType || "title";
	        
	        // 주소창을 변경하여 서버에 해당 페이지 데이터를 요청함
	        location.href = `?page=${page}&searchInput=${encodeURIComponent(keyword)}&searchType=${type}`;
	    }
	/*function goToPage(page) {
	    const info = window.serverPaging;
	    location.href = `?page=${page}&searchInput=${info.keyword}&searchType=${info.searchType}`;
	}*/
    /*function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        // ★ 수정: 데이터가 0개일 때만 비우고, 1페이지라도 있으면 [1] 버튼 유지
        if (totalCount === 0) { 
            container.innerHTML = ''; 
            return; 
        }

        const totalPages = Math.ceil(totalCount / rowsPerPage);

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="noticeManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="noticeManager.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="noticeManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }*/

    // 페이지 이동 함수
    function goToPage(page) {
        currentPage = page;
        renderTable(); // 필터링 조건은 그대로 유지한 채로 리렌더링
    }

    /* =========================================
       모달 및 데이터 저장 (CRUD)
       ========================================= */
    function openModal(type, id = null) {
        const modal = document.getElementById('noticeModal');
        if (!modal) return;
        
        if (type === 'create') {
            document.getElementById('modalTitle').innerText = '공지사항 등록';
            document.getElementById('noticeForm').reset();
            document.getElementById('modalNoticeId').value = ''; 
            document.getElementById('checkVisible').checked = true; // 기본값
        } else {
            document.getElementById('modalTitle').innerText = '공지사항 수정';
            
            // 실제 서버 연결 시 fetch로 상세 데이터 조회 처리
            const item = noticeList.find(n => n.noticeId === id);
            if (item) {
                document.getElementById('modalNoticeId').value = item.noticeId;
                document.getElementById('inputTitle').value = item.title;
                document.getElementById('inputContent').value = item.content || ''; 
                document.getElementById('checkImportant').checked = item.isImportant;
                document.getElementById('checkVisible').checked = item.isVisible;
            }
        }

        // ★ 수정: admin.css 애니메이션 표준화 (setTimeout 클래스 조작 제거)
        modal.style.display = 'flex';
    }

    function closeModal() {
        const modal = document.getElementById('noticeModal');
        if (!modal) return;
        // ★ 수정: 즉시 닫기 처리
        modal.style.display = 'none';
    }

	function saveNotice() {
	    const titleInput = document.getElementById('inputTitle').value.trim();
	    const contentInput = document.getElementById('inputContent').value.trim();
	    const form = document.getElementById('noticeForm');

	    // 1. 유효성 검사 (스타일 유지)
	    if(!titleInput) {
	        alert('제목을 입력해주세요.');
	        document.getElementById('inputTitle').focus();
	        return;
	    }

	    if(!contentInput) {
	        alert('내용을 입력해주세요.');
	        document.getElementById('inputContent').focus();
	        return;
	    }

	    // 2. 서버 전송
	    // 만약 수정 기능도 같이 쓰고 싶다면 조건문을 추가할 수 있습니다.
	    const noticeId = document.getElementById('modalNoticeId').value;
	    if(noticeId) {
	        form.action = "/admin/edit_pro"; // 수정 컨트롤러가 따로 있을 경우
	    } else {
	        form.action = "/admin/notice/write_pro"; // 작성 컨트롤러
	    }

	    form.submit(); // 컨트롤러로 데이터 전송 및 페이지 이동(redirect)
	}
	
    /*function saveNotice() {
        const noticeId = document.getElementById('modalNoticeId').value;
        const titleInput = document.getElementById('inputTitle').value.trim();
        const contentInput = document.getElementById('inputContent').value.trim();

        if(!titleInput) {
            alert('제목을 입력해주세요.');
            return;
        }

        if(!contentInput) {
            alert('내용을 입력해주세요.');
            return;
        }

        const saveData = {
            noticeId: noticeId ? parseInt(noticeId) : null,
            title: titleInput,
            content: contentInput,
            isImportant: document.getElementById('checkImportant').checked,
            isVisible: document.getElementById('checkVisible').checked
        };

        // 실제 서버 연결 시 이 부분에 fetch(POST/PUT) 로직 구현

        alert('정상적으로 저장되었습니다.');
        closeModal();
        searchTable(false); // 저장 후 리스트 갱신 (실제로는 fetch 후 호출)
    }*/

    // 외부 노출
	return {
	        searchTable,
	        goToPage,  // ★ 이 줄이 누락되면 페이지 번호 클릭 시 반응이 없습니다.
	        openModal,
	        closeModal,
	        saveNotice
	    };

})();