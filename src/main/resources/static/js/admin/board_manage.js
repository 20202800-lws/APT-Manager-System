/* =========================================
   관리자 게시판 관리 로직
   Refactored based on ERD: BOARD Table
   ========================================= */

const boardManager = (function() {

    // 1. Mock Data (ERD Mapping Applied)
    // [Change Log]
    // postNo -> boardId (PK)
    // categoryCode -> category
    // writerName -> userName (Mapped to USERS.user_name)
    // viewCount -> views
    // reportCount -> reportCount (DTO Only, Not in ERD)
    // postStatus -> postStatus (DTO Only, Not in ERD)
    let boardList = [
        { boardId: 105, category: 'FREE', title: '단지 내 흡연 관련하여 부탁드립니다.', userName: '102동 505호', regDate: '2024-02-05', views: 45, reportCount: 3, postStatus: 'ACTIVE', content: '복도에서 담배 피우지 말아주세요. 냄새가 너무 들어옵니다.' },
        { boardId: 104, category: 'SECRET', title: ' 너무 시끄럽네요', userName: '익명', regDate: '2024-02-05', views: 120, reportCount: 0, postStatus: 'ACTIVE', content: '조용히좀해라.' },
        { boardId: 103, category: 'FREE', title: '관리실 직원분들 칭찬합니다 ^^', userName: '101동 302호', regDate: '2024-02-04', views: 88, reportCount: 0, postStatus: 'ACTIVE', content: '어제 눈 치우시느라 고생 많으셨습니다. 감사합니다.' },
        { boardId: 102, category: 'CLUB', title: '[등산동호회] 이번 주말 관악산 가실 분', userName: '등산회장', regDate: '2024-02-03', views: 56, reportCount: 0, postStatus: 'ACTIVE', content: '이번주 토요일 오전 9시 정문 집결입니다.' },
        { boardId: 101, category: 'MARKET', title: '중고 가전 팝니다 (급매)', userName: '외부인', regDate: '2024-02-01', views: 12, reportCount: 5, postStatus: 'BLIND', content: '냉장고 싸게 팝니다. 연락주세요.' } 
    ];

    // [Mapping Change] currentCategoryCode -> currentCategory
    let currentCategory = 'ALL'; 
    let currentBannedWords = "바보, 멍청이, 사기꾼, 도박, 불법"; 
    const TAB_WIDTH = 140;

    const modalMap = {
        'bannedModal': document.getElementById('bannedModal'),
        'detailModal': document.getElementById('detailModal')
    };

    document.addEventListener('DOMContentLoaded', () => {
        // Init Modals
        modalMap['bannedModal'] = document.getElementById('bannedModal');
        modalMap['detailModal'] = document.getElementById('detailModal');
        
        updateStats();
        filterTab('ALL', 0);

        // Window click for modal close
        window.onclick = function(event) {
            if (event.target.className.includes('modal-overlay')) {
                closeModal(event.target.id);
            }
        };
    });

    /* =========================================
       2. Logic Functions
       ========================================= */
    function updateStats() {
        document.getElementById('statTotalCount').innerHTML = `${boardList.length}<span class="unit">개</span>`;
        
        const today = "2024-02-05"; 
        const todayCount = boardList.filter(d => d.regDate === today).length;
        document.getElementById('statTodayCount').innerHTML = `${todayCount}<span class="unit">개</span>`;

        // Using DTO fields (reportCount, postStatus)
        const reportCount = boardList.filter(d => d.reportCount > 0 || d.postStatus === 'BLIND').length;
        document.getElementById('statReportCount').innerHTML = `${reportCount}<span class="unit">건</span>`;
    }

    // [Mapping Change] code -> category
    function filterTab(category, index) {
        currentCategory = category;
        
        const highlighter = document.getElementById('tabHighlighter');
        if(highlighter) highlighter.style.transform = `translateX(${index * TAB_WIDTH}px)`;

        document.querySelectorAll('.tab-btn').forEach((btn, i) => {
            if(i === index) btn.classList.add('active');
            else btn.classList.remove('active');
        });

        const titles = { 'ALL': '전체 게시글 목록', 'FREE': '자유게시판 목록', 'SECRET': '익명/장터 목록', 'REPORT': '신고 접수 내역' };
        document.getElementById('listTitle').innerText = titles[category] || '게시판 목록';

        searchTable();
    }

    function searchTable() {
        const keyword = document.getElementById('searchInput').value.toLowerCase();
        const searchFilter = document.getElementById('searchFilter').value; // 'title' or 'userName'
        
        const filtered = boardList.filter(item => {
            // 1. Tab Filter
            if (currentCategory === 'REPORT') {
                if (item.reportCount === 0 && item.postStatus !== 'BLIND') return false;
            } else if (currentCategory !== 'ALL' && item.category !== currentCategory) {
                // [Mapping Change] categoryCode -> category
                return false;
            }
            
            // 2. Search Filter
            if (keyword) {
                if(searchFilter === 'title' && !item.title.toLowerCase().includes(keyword)) return false;
                // [Mapping Change] writerName -> userName
                if(searchFilter === 'userName' && !item.userName.toLowerCase().includes(keyword)) return false;
            }
            
            return true;
        });

        renderTable(filtered);
    }

    function renderTable(data) {
        const tbody = document.getElementById('boardTableBody');
        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" style="padding:30px; color:#999;">조건에 맞는 게시글이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = data.map(item => {
            // [Mapping Change] categoryCode -> category
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

            // [Mapping Change] postNo -> boardId, writerName -> userName, viewCount -> views
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
        // [Mapping Change] postNo -> boardId
        const item = boardList.find(d => d.boardId === id);
        if(!item) return;

        // [Mapping Change] targetPostNo -> targetBoardId
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

    function executeAction(type) {
        // [Mapping Change] targetPostNo -> targetBoardId
        const id = parseInt(document.getElementById('targetBoardId').value);
        const reason = document.getElementById('blindReason').value;
        
        if (type === 'delete') {
            if(!confirm("정말 삭제하시겠습니까? 복구할 수 없습니다.")) return;
            // [Mapping Change] postNo -> boardId
            boardList = boardList.filter(d => d.boardId !== id);
            alert("게시글이 삭제되었습니다.");
        } else {
            const item = boardList.find(d => d.boardId === id);
            if(item) {
                item.postStatus = 'BLIND';
                alert(`[${reason}] 사유로 블라인드 처리되었습니다.`);
            }
        }
        
        closeModal('detailModal');
        updateStats();
        searchTable();
    }

    /* =========================================
       4. Common Modal Functions
       ========================================= */
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
        closeModal
    };

})();