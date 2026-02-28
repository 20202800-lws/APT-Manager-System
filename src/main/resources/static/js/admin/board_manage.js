/* =========================================
   관리자 게시판 관리 로직 (서버 연동형)
   ========================================= */

const boardManager = (function() {

    // 1. 데이터 초기화
    let boardList = window.globalBoardList || [];
    const modalMap = {};

    document.addEventListener('DOMContentLoaded', () => {
        // 모달 요소 매핑
        modalMap['bannedModal'] = document.getElementById('bannedModal');
        modalMap['detailModal'] = document.getElementById('detailModal');
        
        // 통계 업데이트
        updateStats();
        
        // 서버에서 받아온 리스트 화면 출력
        renderTable(boardList); 

        // 모달 바깥 배경 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target.classList && event.target.classList.contains('modal-overlay')) {
                const modalId = event.target.id;
                closeModal(modalId);
            }
        };
    });

    /* =========================================
       2. Logic Functions (서버 통신형)
       ========================================= */
    
    // 상단 통계 카드 업데이트
    function updateStats() {
        const s = window.adminStats || { total: 0, newPost: 0, report: 0 };
        
        if(document.getElementById('statTotalCount')) 
            document.getElementById('statTotalCount').innerHTML = `${s.total}<span class="unit">개</span>`;
        if(document.getElementById('statTodayCount')) 
            document.getElementById('statTodayCount').innerHTML = `${s.newPost}<span class="unit">개</span>`;
        if(document.getElementById('statReportCount')) 
            document.getElementById('statReportCount').innerHTML = `${s.report}<span class="unit">건</span>`;
    }

    // 탭(카테고리) 클릭 시 서버 이동
    function filterTab(category) {
        const filter = document.getElementById('searchFilter').value;
        const input = document.getElementById('searchInput').value.trim();
        // 검색 조건과 함께 0페이지로 이동
        location.href = `?page=0&category=${category}&searchType=${filter}&searchInput=${encodeURIComponent(input)}`;
    }

    // 검색 버튼 클릭 시 서버 이동
    function searchTable() {
        const filterEl = document.getElementById('searchFilter');
        const inputEl = document.getElementById('searchInput');
        const urlParams = new URLSearchParams(window.location.search);
        
        const category = urlParams.get('category') || 'ALL';
        const filter = filterEl.value;
        const input = inputEl.value.trim();
        
        location.href = `?page=0&category=${category}&searchType=${filter}&searchInput=${encodeURIComponent(input)}`;
    }

    // 테이블 렌더링
    function renderTable(data) {
        const tbody = document.getElementById('boardTableBody');
        if(!tbody) return;

        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" style="padding:40px; color:#999; text-align:center;">조건에 맞는 게시글이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = data.map(item => {
            let catBadge = (item.category === 'FREE') ? 
                '<span class="badge badge-blue">자유</span>' : 
                '<span class="badge badge-warning">익명</span>';
            
            let statusHtml = '';
            if (item.postStatus === 'BLIND') {
                statusHtml = '<span class="badge badge-gray">숨김</span>';
            } else if (item.reportCount > 0) {
                statusHtml = `<span class="badge badge-red">신고 ${item.reportCount}</span>`;
            } else {
                statusHtml = '<span class="badge badge-success">정상</span>';
            }

            return `
                <tr>
                    <td>${item.boardId}</td>
                    <td>${catBadge}</td>
                    <td style="text-align:left; cursor:pointer;" onclick="boardManager.openDetailModal(${item.boardId})">${item.title}</td>
                    <td>${item.userName}</td>
                    <td>${item.regDate}</td>
                    <td>${item.views}</td>
                    <td>${statusHtml}</td>
                    <td>
                        <button class="btn btn-secondary btn-xs" onclick="boardManager.openDetailModal(${item.boardId})">관리</button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    /* =========================================
       3. Modal Logic
       ========================================= */

    function openBannedModal() {
        openModalById('bannedModal');
    }

    function saveBannedWords() {
        const val = document.getElementById('bannedInput').value;
        if(!val.trim()) { alert("금지어를 입력해주세요."); return; }
        alert("금지어 설정이 저장되었습니다. (서버 연동 예정)");
        closeModal('bannedModal');
    }

    function openDetailModal(id) {
        const item = boardList.find(d => d.boardId === id);
        if(!item) return;

        document.getElementById('targetBoardId').value = item.boardId;
        
        const html = `
            <div class="info-group" style="margin-bottom:15px;">
                <div class="info-label" style="color:#888; font-size:12px;">제목</div>
                <div class="info-value" style="font-weight:700; font-size:16px;">${item.title}</div>
            </div>
            <div style="display:flex; gap:20px; margin-bottom:15px;">
                <div style="flex:1;">
                    <div class="info-label" style="color:#888; font-size:12px;">작성자</div>
                    <div class="info-value">${item.userName}</div>
                </div>
                <div style="flex:1;">
                    <div class="info-label" style="color:#888; font-size:12px;">작성일</div>
                    <div class="info-value">${item.regDate}</div>
                </div>
            </div>
            <div class="info-group">
                <div class="info-label" style="color:#888; font-size:12px;">내용</div>
                <div class="info-value" style="min-height:100px; line-height:1.6; background:#f9f9f9; border:1px solid #eee; border-radius:8px; padding:15px; white-space:pre-wrap;">
                    ${item.content}
                </div>
            </div>
        `;
        document.getElementById('postDetailContent').innerHTML = html;
        openModalById('detailModal');
    }

    function executeAction(type) {
        const id = document.getElementById('targetBoardId').value;
        const reason = document.getElementById('blindReason').value;
        
        if (type === 'delete') {
            if(!confirm("정말 삭제하시겠습니까? 복구할 수 없습니다.")) return;
            alert(`게시글 ${id}번이 삭제되었습니다. (API 연동 필요)`);
        } else {
            alert(`[${reason}] 사유로 블라인드 처리되었습니다. (API 연동 필요)`);
        }
        closeModal('detailModal');
    }

    function openModalById(modalId) {
        const modal = modalMap[modalId];
        if(modal) modal.style.display = 'flex';
    }

    function closeModal(modalId) {
        const modal = modalMap[modalId];
        if(modal) modal.style.display = 'none';
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