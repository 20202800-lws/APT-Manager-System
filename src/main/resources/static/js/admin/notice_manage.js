/* =========================================
   관리자 | 공지사항 관리 로직 (페이징 연동 완료)
   ========================================= */

const noticeManager = (function() {

    // 1. 데이터 초기화 (JSP 전역 변수에서 호출)
    let noticeList = window.globalNoticeList || [];
    let currentFilteredList = [];

    const modal = document.getElementById('noticeModal');

    // 2. 페이징 관련 변수
    let currentPage = 1;
    const rowsPerPage = 10; 

    // 3. 초기 실행
    document.addEventListener('DOMContentLoaded', () => {
        updateStats();
        searchTable(true); // 초기 렌더링 시 조건 없는 검색(전체) & 1페이지로 시작

        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target === modal) {
                closeModal();
            }
        }
    });

    // 통계 갱신
    function updateStats() {
        document.getElementById('statTotal').innerHTML = `${noticeList.length}<span class="unit">건</span>`;
        
        const importantCount = noticeList.filter(n => n.isImportant).length;
        const hiddenCount = noticeList.filter(n => !n.isVisible).length;

        document.getElementById('statImportant').innerHTML = `${importantCount}<span class="unit">건</span>`;
        document.getElementById('statHidden').innerHTML = `${hiddenCount}<span class="unit">건</span>`;
    }

    // 검색 및 필터링 (isResetPage: true면 1페이지로 초기화)
    function searchTable(isResetPage = false) {
        if (isResetPage) currentPage = 1;

        const filter = document.getElementById('searchFilter').value; // 'all', 'public', 'private'
        const keywordInput = document.getElementById('searchKeyword');
        const keyword = keywordInput ? keywordInput.value.toLowerCase() : '';

        currentFilteredList = noticeList.filter(item => {
            // 상태 필터
            let statusMatch = true;
            if (filter === 'public') statusMatch = item.isVisible === true;
            if (filter === 'private') statusMatch = item.isVisible === false;

            // 검색어 필터
            const keywordMatch = item.title.toLowerCase().includes(keyword);

            return statusMatch && keywordMatch;
        });

        // 중요(필독) 공지가 상단에 오도록 정렬 (선택 사항이지만 공지사항 특성상 유용함)
        currentFilteredList.sort((a, b) => {
            if (a.isImportant && !b.isImportant) return -1;
            if (!a.isImportant && b.isImportant) return 1;
            return b.noticeId - a.noticeId; // 최신글(ID가 큰 것)이 위로 오도록
        });

        renderTable();
    }

    // 테이블 렌더링 (페이징 적용)
    function renderTable() {
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
            const titlePrefix = item.isImportant ? '<span style="color:var(--danger); font-weight:700;">[필독]</span> ' : '';
            const statusBadge = item.isVisible ? '<span class="badge badge-success">공개</span>' : '<span class="badge badge-secondary">비공개</span>';
            
            return `
                <tr>
                    <td>${item.noticeId}</td>
                    <td style="text-align:left; cursor:pointer;" onclick="noticeManager.openModal('edit', ${item.noticeId})">
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
    }

    // 페이징 버튼 렌더링
    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        const totalPages = Math.ceil(totalCount / rowsPerPage);
        if (totalPages <= 1) { container.innerHTML = ''; return; }

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="noticeManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="noticeManager.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="noticeManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    // 페이지 이동 함수
    function goToPage(page) {
        currentPage = page;
        renderTable();
    }

    /* =========================================
       모달 및 데이터 저장 (CRUD)
       ========================================= */
    function openModal(type, id = null) {
        if (!modal) return;
        
        if (type === 'create') {
            document.getElementById('modalTitle').innerText = '공지사항 등록';
            document.getElementById('noticeForm').reset();
            document.getElementById('modalNoticeId').value = ''; 
            document.getElementById('checkVisible').checked = true; // 기본값
        } else {
            document.getElementById('modalTitle').innerText = '공지사항 수정';
            
            // 실제 서버 연결 시 이 부분에 fetch로 상세 데이터 조회 (fetch('/admin/notice/detail?noticeId=' + id))
            const item = noticeList.find(n => n.noticeId === id);
            if (item) {
                document.getElementById('modalNoticeId').value = item.noticeId;
                document.getElementById('inputTitle').value = item.title;
                document.getElementById('inputContent').value = item.content || ''; // content가 없을 경우 빈 문자열
                document.getElementById('checkImportant').checked = item.isImportant;
                document.getElementById('checkVisible').checked = item.isVisible;
            }
        }

        modal.style.display = 'flex';
        setTimeout(() => modal.classList.add('show'), 10);
    }

    function closeModal() {
        if (!modal) return;
        modal.classList.remove('show');
        setTimeout(() => {
            modal.style.display = 'none';
        }, 300);
    }

    function saveNotice() {
        const noticeId = document.getElementById('modalNoticeId').value;
        
        const saveData = {
            noticeId: noticeId ? parseInt(noticeId) : null,
            title: document.getElementById('inputTitle').value.trim(),
            content: document.getElementById('inputContent').value.trim(),
            // writerId는 서버 측 컨트롤러에서 세션 기반으로 설정하는 것이 안전합니다.
            isImportant: document.getElementById('checkImportant').checked,
            isVisible: document.getElementById('checkVisible').checked
        };

        if(!saveData.title) {
            alert('제목을 입력해주세요.');
            return;
        }

        if(!saveData.content) {
            alert('내용을 입력해주세요.');
            return;
        }

        // 실제 서버 연결 시 이 부분에 AJAX / fetch 로직 구현
        // const url = saveData.noticeId ? '/admin/notice/update' : '/admin/notice/insert';
        // fetch(url, { ... })

        alert('정상적으로 저장되었습니다.');
        
        // UI 임시 업데이트 및 닫기
        // (실제로는 저장 후 location.reload() 하거나 서버에서 새 리스트를 받아와서 화면을 갱신합니다.)
        closeModal();
    }

    // 외부 노출
    return {
        searchTable,
        goToPage,
        openModal,
        closeModal,
        saveNotice
    };

})();