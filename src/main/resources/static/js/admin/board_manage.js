/* =========================================
   관리자 게시판 관리 로직 (Server Integrated + Pagination)
   ========================================= */

const boardManager = (function() {

    // 1. 상태 변수
    let boardList = [];
    let currentCategory = 'ALL'; 
    let currentBannedWords = ""; 
    
    // [Pagination Added] 현재 페이지 상태 변수 추가
    let currentPage = 1; 
    
    const TAB_WIDTH = 140;

    const API_URL = {
        LIST: '/api/admin/board/list',      
        STATS: '/api/admin/board/stats',    
        DELETE: '/api/admin/board/delete',  
        STATUS: '/api/admin/board/status',  
        BANNED: '/api/admin/board/banned'   
    };

    const modalMap = {};

    document.addEventListener('DOMContentLoaded', () => {
        modalMap['bannedModal'] = document.getElementById('bannedModal');
        modalMap['detailModal'] = document.getElementById('detailModal');
        
        loadStats();     
        loadBoardList(); 
        loadBannedWords(); 

        window.onclick = function(event) {
            if (event.target.className.includes('modal-overlay')) {
                closeModal(event.target.id);
            }
        };
    });

    /* =========================================
       2. Server Communication Logic
       ========================================= */

    async function loadBoardList() {
        const keyword = document.getElementById('searchInput').value;
        const searchFilter = document.getElementById('searchFilter').value;

        // [Pagination Added] 쿼리 파라미터에 page와 size 추가
        const params = new URLSearchParams({
            category: currentCategory,
            searchType: searchFilter,
            keyword: keyword,
            page: currentPage, // 현재 페이지 번호 전달
            size: 10           // 페이지당 10개
        });

        try {
            const response = await fetch(`${API_URL.LIST}?${params.toString()}`);
            
            // 여기서 404(Not Found)나 500 에러가 나면 예외 발생
            if (!response.ok) throw new Error("데이터 로드 실패");
            
            // 서버 응답 구조가 { content: [...], totalPages: 5 } 형태라고 가정
            // 만약 리스트만 온다면 boardList = await response.json(); 그대로 사용
            const data = await response.json();
            
            // 데이터 구조에 맞춰 바인딩 (여기서는 리스트가 바로 온다고 가정)
            boardList = Array.isArray(data) ? data : data.content || []; 
            
            renderTable(boardList);
            // renderPagination(data.totalPages); // (선택사항) 페이지 버튼 그리기 함수 필요 시 호출

        } catch (error) {
            console.error("게시글 로드 중 오류:", error);
            
            // [Bug Fix] 팝업 대신 테이블에 '로드 실패' 메시지 표시로 변경 (사용자 경험 개선)
            const tbody = document.getElementById('boardTableBody');
            tbody.innerHTML = '<tr><td colspan="8" style="padding:30px; color:red;">서버 연결에 실패했습니다.<br>( 데이터를 불러오지 못했습니다)</td></tr>';
            
            // alert("목록을 불러오지 못했습니다."); // 너무 자주 뜨면 불편하므로 주석 처리
        }
    }

    async function loadStats() {
        try {
            const response = await fetch(API_URL.STATS);
            if (!response.ok) return;
            const stats = await response.json();
            
            document.getElementById('statTotalCount').innerHTML = `${stats.totalCount}<span class="unit">개</span>`;
            document.getElementById('statTodayCount').innerHTML = `${stats.todayCount}<span class="unit">개</span>`;
            document.getElementById('statReportCount').innerHTML = `${stats.reportCount}<span class="unit">건</span>`;
        } catch (e) {
            console.log("통계 로드 실패");
        }
    }

    async function loadBannedWords() {
        try {
            const response = await fetch(API_URL.BANNED);
            if(response.ok) {
                const data = await response.json();
                currentBannedWords = data.bannedWords;
            }
        } catch(e) {}
    }

    /* =========================================
       3. UI & Handler Logic
       ========================================= */

    // [Pagination Added] 페이지 이동 함수 추가
    function movePage(pageNum) {
        if (pageNum < 1) return;
        // (필요 시 최대 페이지 체크 로직 추가)
        currentPage = pageNum;
        loadBoardList(); // 변경된 페이지로 재조회
    }

    function filterTab(category, index) {
        currentCategory = category;
        currentPage = 1; // [Pagination Added] 탭 변경 시 1페이지로 초기화
        
        const highlighter = document.getElementById('tabHighlighter');
        if(highlighter) highlighter.style.transform = `translateX(${index * TAB_WIDTH}px)`;

        document.querySelectorAll('.tab-btn').forEach((btn, i) => {
            if(i === index) btn.classList.add('active');
            else btn.classList.remove('active');
        });

        const titles = { 'ALL': '전체 게시글 목록', 'FREE': '자유게시판 목록', 'SECRET': '익명/장터 목록', 'REPORT': '신고 접수 내역' };
        document.getElementById('listTitle').innerText = titles[category] || '게시판 목록';

        loadBoardList(); 
    }

    function searchTable() {
        currentPage = 1; // [Pagination Added] 검색 시 1페이지로 초기화
        loadBoardList();
    }

    function renderTable(data) {
        const tbody = document.getElementById('boardTableBody');
        if (!data || data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" style="padding:30px; color:#999;">조건에 맞는 게시글이 없습니다.</td></tr>';
            return;
        }
        // ... (기존 렌더링 로직 동일) ...
        tbody.innerHTML = data.map(item => {
            let catBadge = '<span class="badge badge-gray">기타</span>';
            if(item.category === 'FREE') catBadge = '<span class="badge badge-blue">자유</span>';
            else if(item.category === 'MARKET') catBadge = '<span class="badge badge-green">장터</span>';
            else if(item.category === 'CLUB') catBadge = '<span class="badge badge-warning">동호회</span>';

            let statusHtml = '';
            if (item.postStatus === 'BLIND') {
                statusHtml = '<span class="badge badge-gray"><i class="fa-solid fa-eye-slash"></i> 숨김</span>';
            } else if (item.reportCount > 0) {
                statusHtml = `<span class="badge badge-red">신고 ${item.reportCount}</span>`;
            } else {
                statusHtml = '<span class="badge badge-success">정상</span>';
            }

            let titleStyle = item.postStatus === 'BLIND' ? 'color:#999; text-decoration:line-through;' : 'color:#333; font-weight:500; cursor:pointer;';

            return `
                <tr>
                    <td style="color:#666;">${item.boardId}</td>
                    <td>${catBadge}</td>
                    <td style="text-align:left; padding-left:15px; ${titleStyle}" onclick="boardManager.openDetailModal(${item.boardId})">
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
    }

    /* =========================================
       4. Modal & Action Logic
       ========================================= */

    function openBannedModal() {
        document.getElementById('bannedInput').value = currentBannedWords;
        openModalById('bannedModal');
    }

    async function saveBannedWords() {
        // ... (기존 로직 동일) ...
        const val = document.getElementById('bannedInput').value;
        if(!val.trim()) { alert("금지어를 입력해주세요."); return; }
        
        try {
            const response = await fetch(API_URL.BANNED, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ bannedWords: val })
            });
            if(response.ok) {
                currentBannedWords = val;
                alert("금지어 설정이 저장되었습니다.");
                closeModal('bannedModal');
            } else { alert("저장 실패"); }
        } catch(e) { console.error(e); }
    }

    function openDetailModal(id) {
        // ... (기존 로직 동일) ...
        const item = boardList.find(d => d.boardId === id);
        if(!item) return;

        document.getElementById('targetBoardId').value = item.boardId;
        const html = `
            <div class="info-group">
                <div class="info-label">제목</div>
                <div class="info-value">${item.title}</div>
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
                <div class="info-value" style="min-height:100px; line-height:1.6; background:#fafafa;">
                    ${item.content}
                </div>
            </div>
        `;
        document.getElementById('postDetailContent').innerHTML = html;
        openModalById('detailModal');
    }

    async function executeAction(type) {
        // ... (기존 로직 동일) ...
        const id = parseInt(document.getElementById('targetBoardId').value);
        const reason = document.getElementById('blindReason').value;
        
        if (type === 'delete') {
            if(!confirm("삭제하시겠습니까?")) return;
            try {
                const response = await fetch(`${API_URL.DELETE}/${id}`, { method: 'DELETE' });
                if(response.ok) {
                    alert("삭제되었습니다.");
                    closeModal('detailModal');
                    loadBoardList(); loadStats();
                } else { alert("삭제 실패"); }
            } catch(e) { console.error(e); }
        } else {
            try {
                const response = await fetch(API_URL.STATUS, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ boardId: id, status: 'BLIND', reason: reason })
                });
                if(response.ok) {
                    alert(`블라인드 처리됨`);
                    closeModal('detailModal');
                    loadBoardList(); loadStats();
                } else { alert("처리 실패"); }
            } catch(e) { console.error(e); }
        }
    }

    function openModalById(modalId) {
        const modal = modalMap[modalId];
        if(modal) {
            modal.style.display = 'flex';
            setTimeout(() => modal.classList.add('show'), 10);
        }
    }

    function closeModal(modalId) {
        const modal = modalMap[modalId];
        if(modal) {
            modal.classList.remove('show');
            setTimeout(() => modal.style.display = 'none', 300);
        }
    }

    return {
        filterTab,
        searchTable,
        openBannedModal,
        saveBannedWords,
        openDetailModal,
        executeAction,
        closeModal,
        movePage // [Pagination Added] 외부에서 호출 가능하도록 반환
    };

})();