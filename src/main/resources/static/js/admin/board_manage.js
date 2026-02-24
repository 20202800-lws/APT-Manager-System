/* =========================================
   관리자 게시판 관리 로직
   ========================================= */

const boardManager = (function() {

    // 1. Data Initialization (JSP에서 넘겨받은 전역 데이터 사용)
    let boardList = window.globalBoardList || [];

    let currentCategory = 'ALL'; 
    let currentBannedWords = "바보, 멍청이, 사기꾼, 도박, 불법"; 
    const TAB_WIDTH = 140;

    // === 페이징 관련 변수 ===
    let currentPage = 1;
    const rowsPerPage = 10;

    const modalMap = {};

    document.addEventListener('DOMContentLoaded', () => {
        // Init Modals
        modalMap['bannedModal'] = document.getElementById('bannedModal');
        modalMap['detailModal'] = document.getElementById('detailModal');
        
        updateStats();
        filterTab('ALL', 0);

        // 모달 바깥 배경 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target.className && event.target.className.includes('modal-overlay')) {
                closeModal(event.target.id);
            }
        };
    });

    /* =========================================
       2. Logic Functions
       ========================================= */
    function updateStats() {
        const totalEl = document.getElementById('statTotalCount');
        if(totalEl) totalEl.innerHTML = `${boardList.length}<span class="unit">개</span>`;
        
        // 오늘 날짜를 기준으로 오늘 작성된 글 계산
        const today = new Date().toISOString().split('T')[0]; 
        const todayCount = boardList.filter(d => d.regDate && d.regDate.startsWith(today)).length;
        const todayEl = document.getElementById('statTodayCount');
        if(todayEl) todayEl.innerHTML = `${todayCount}<span class="unit">개</span>`;

        const reportCount = boardList.filter(d => d.reportCount > 0 || d.postStatus === 'BLIND').length;
        const reportEl = document.getElementById('statReportCount');
        if(reportEl) reportEl.innerHTML = `${reportCount}<span class="unit">건</span>`;
    }

    function filterTab(category, index) {
        currentCategory = category;
        
        // 탭 하이라이터 이동
        const highlighter = document.getElementById('tabHighlighter');
        if(highlighter) highlighter.style.transform = `translateX(${index * TAB_WIDTH}px)`;

        // 탭 버튼 색상 변경
        document.querySelectorAll('.tab-btn').forEach((btn, i) => {
            if(i === index) btn.classList.add('active');
            else btn.classList.remove('active');
        });

        // 타이틀 변경
        const titles = { 'ALL': '전체 게시글 목록', 'FREE': '자유게시판 목록', 'SECRET': '익명게시판 목록', 'REPORT': '신고 접수 내역' };
        const titleEl = document.getElementById('listTitle');
        if(titleEl) titleEl.innerText = titles[category] || '게시판 목록';

        searchTable(false); // 탭 이동 시 무조건 1페이지로 리셋
    }

    function searchTable(isPageMove = false) {
        if (!isPageMove) currentPage = 1;

        const searchInput = document.getElementById('searchInput');
        const searchFilterEl = document.getElementById('searchFilter');
        
        const keyword = searchInput ? searchInput.value.toLowerCase().trim() : '';
        const searchFilter = searchFilterEl ? searchFilterEl.value : 'title';
        
        const filtered = boardList.filter(item => {
            // 1. Tab Filter
            if (currentCategory === 'REPORT') {
                if (item.reportCount === 0 && item.postStatus !== 'BLIND') return false;
            } else if (currentCategory !== 'ALL' && item.category !== currentCategory) {
                return false;
            }
            
            // 2. Search Filter
            if (keyword) {
                if(searchFilter === 'title' && !item.title.toLowerCase().includes(keyword)) return false;
                if(searchFilter === 'userName' && !item.userName.toLowerCase().includes(keyword)) return false;
            }
            
            return true;
        });

        renderTable(filtered);
    }

    function renderTable(data) {
        const tbody = document.getElementById('boardTableBody');
        if(!tbody) return;

        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" style="padding:40px; color:#999; text-align:center;">조건에 맞는 게시글이 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        // 페이징 계산
        const totalPages = Math.ceil(data.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const endIndex = startIndex + rowsPerPage;
        const paginatedData = data.slice(startIndex, endIndex);

        tbody.innerHTML = paginatedData.map(item => {
            // ★ 수정됨: JSP 탭(FREE, SECRET)에 맞게 뱃지 매핑 수정
            let catBadge = '<span class="badge badge-gray">기타</span>';
            if(item.category === 'FREE') catBadge = '<span class="badge badge-blue">자유</span>';
            else if(item.category === 'SECRET') catBadge = '<span class="badge badge-warning">익명</span>'; // MARKET/CLUB 제거, 익명 추가

            // 상태 뱃지
            let statusHtml = '';
            if (item.postStatus === 'BLIND') {
                statusHtml = '<span class="badge badge-gray"><i class="fa-solid fa-eye-slash"></i> 숨김</span>';
            } else if (item.reportCount > 0) {
                statusHtml = `<span class="badge badge-red">신고 ${item.reportCount}</span>`;
            } else {
                statusHtml = '<span class="badge badge-success">정상</span>';
            }

            // 숨김 처리된 글은 제목 회색선 긋기
            let titleStyle = item.postStatus === 'BLIND' ? 'color:#999; text-decoration:line-through;' : 'color:#333; font-weight:500; cursor:pointer;';

            return `
                <tr>
                    <td style="color:#666;">${item.boardId}</td>
                    <td>${catBadge}</td>
                    <td style="text-align:left; padding-left:15px; ${titleStyle}" class="td-title" onclick="boardManager.openDetailModal(${item.boardId})">
                        ${item.title}
                    </td>
                    <td>${item.userName}</td>
                    <td style="color:#666;">${item.regDate}</td>
                    <td style="color:#888;">${item.views}</td>
                    <td>${statusHtml}</td>
                    <td>
                        <button class="btn btn-secondary btn-xs" onclick="boardManager.openDetailModal(${item.boardId})">
                            <i class="fa-solid fa-gear"></i> 관리
                        </button>
                    </td>
                </tr>
            `;
        }).join('');

        renderPagination(data.length);
    }

    function renderPagination(totalCount) {
        const paginationContainer = document.getElementById('paginationWrapper');
        if (!paginationContainer) return;

        if (totalCount === 0) {
            paginationContainer.innerHTML = '';
            return;
        }

        const totalPages = Math.ceil(totalCount / rowsPerPage);
        let html = '';

        if (currentPage > 1) {
            html += `<button class="btn btn-secondary btn-xs" onclick="boardManager.goToPage(${currentPage - 1})">&lt;</button> `;
        } else {
            html += `<button class="btn btn-secondary btn-xs" disabled>&lt;</button> `;
        }

        for (let i = 1; i <= totalPages; i++) {
            if (i === currentPage) {
                html += `<button class="btn btn-primary btn-xs">${i}</button> `;
            } else {
                html += `<button class="btn btn-secondary btn-xs" onclick="boardManager.goToPage(${i})">${i}</button> `;
            }
        }

        if (currentPage < totalPages) {
            html += `<button class="btn btn-secondary btn-xs" onclick="boardManager.goToPage(${currentPage + 1})">&gt;</button>`;
        } else {
            html += `<button class="btn btn-secondary btn-xs" disabled>&gt;</button>`;
        }

        paginationContainer.innerHTML = html;
    }

    function goToPage(page) {
        currentPage = page;
        searchTable(true);
    }

    /* =========================================
       3. Modal Logic
       ========================================= */

    function openBannedModal() {
        document.getElementById('bannedInput').value = currentBannedWords;
        openModalById('bannedModal');
    }

    function saveBannedWords() {
        const val = document.getElementById('bannedInput').value;
        if(!val.trim()) { alert("금지어를 입력해주세요."); return; }
        
        currentBannedWords = val;
        alert("금지어 설정이 저장되었습니다.");
        closeModal('bannedModal');
    }

    function openDetailModal(id) {
        const item = boardList.find(d => d.boardId === id);
        if(!item) return;

        document.getElementById('targetBoardId').value = item.boardId;
        
        const html = `
            <div class="info-group">
                <div class="info-label">제목</div>
                <div class="info-value" style="font-weight:700;">${item.title}</div>
            </div>
            <div style="display:flex; gap:20px;">
                <div class="info-group" style="flex:1;">
                    <div class="info-label">작성자</div>
                    <div class="info-value">${item.userName}</div>
                </div>
                <div class="info-group" style="flex:1;">
                    <div class="info-label">작성일</div>
                    <div class="info-value">${item.regDate}</div>
                </div>
            </div>
            <div class="info-group">
                <div class="info-label">내용</div>
                <div class="info-value" style="min-height:100px; line-height:1.6; background:#fafafa; border:1px solid #eee; border-radius:8px; padding:15px; white-space:pre-wrap;">
                    ${item.content}
                </div>
            </div>
        `;
        document.getElementById('postDetailContent').innerHTML = html;

        openModalById('detailModal');
    }

    function executeAction(type) {
        const id = parseInt(document.getElementById('targetBoardId').value);
        const reason = document.getElementById('blindReason').value;
        
        if (type === 'delete') {
            if(!confirm("정말 삭제하시겠습니까? 복구할 수 없습니다.")) return;
            // TODO: 실제 서버로 삭제 AJAX 요청 보내기
            boardList = boardList.filter(d => d.boardId !== id);
            alert("게시글이 삭제되었습니다.");
        } else {
            const item = boardList.find(d => d.boardId === id);
            if(item) {
                // TODO: 실제 서버로 블라인드 처리 AJAX 요청 보내기
                item.postStatus = 'BLIND';
                alert(`[${reason}] 사유로 블라인드 처리되었습니다.`);
            }
        }
        
        closeModal('detailModal');
        updateStats();
        searchTable(true); // 현재 페이지 유지하며 리로드
    }

    /* =========================================
       4. Common Modal Functions
       ========================================= */
    function openModalById(modalId) {
        const modal = modalMap[modalId];
        if(modal) {
            modal.style.display = 'flex'; // admin.css의 애니메이션이 자동으로 작동합니다.
        }
    }

    function closeModal(modalId) {
        const modal = modalMap[modalId];
        if(modal) {
            modal.style.display = 'none';
        }
    }

    // 외부에서 호출할 함수들만 노출 (IIFE 패턴)
    return {
        filterTab,
        searchTable,
        openBannedModal,
        saveBannedWords,
        openDetailModal,
        executeAction,
        closeModal,
        goToPage
    };

})();