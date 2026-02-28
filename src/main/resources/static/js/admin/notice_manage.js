/* =========================================
   관리자 | 공지사항 관리 로직 (서버 페이징 연동 완료)
   ========================================= */

const noticeManager = (function() {

    // 1. 데이터 초기화 (JSP 전역 변수에서 호출)
    let noticeList = window.globalNoticeList || [];

    // 2. 초기 실행
    document.addEventListener('DOMContentLoaded', () => {
        // 서버에서 받은 데이터를 화면에 뿌려줍니다.
        renderTable(); 

        // 모달 외부 클릭 시 닫기
        const modal = document.getElementById('noticeModal');
        window.addEventListener('click', (event) => {
            if (event.target === modal) closeModal();
        });
    });

    /* =========================================
       로직 함수
       ========================================= */

    // 검색 및 필터링 (서버로 GET 요청)
    function searchTable() {
        const keywordInput = document.getElementById('searchKeyword');
        const keyword = keywordInput ? keywordInput.value.trim() : '';
        const filterEl = document.getElementById('searchType');
        const filter = filterEl ? filterEl.value : 'title';

        // 검색 시 1페이지(0번 인덱스)로 초기화하여 서버에 요청
        location.href = `?page=0&searchInput=${encodeURIComponent(keyword)}&searchType=${filter}`;
    }

    // 테이블 렌더링 (서버가 준 1페이지 분량의 데이터만 렌더링)
    function renderTable() {
        const tbody = document.getElementById('noticeTableBody');
        if (!tbody) return;
        
        const data = noticeList; 

        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="padding:40px; color:#999; text-align:center;">조건에 맞는 공지사항이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = data.map(item => {
            const titlePrefix = item.isImportant ? '<span style="color:var(--danger); font-weight:700; margin-right:5px;">[필독]</span>' : '';
            const statusBadge = item.isVisible ? '<span class="badge badge-success">공개</span>' : '<span class="badge badge-secondary">비공개</span>';
            
            // content가 줄바꿈이 있을 경우 스크립트 에러 방지를 위해 이스케이프 된 데이터를 사용해야 합니다.
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
    }

    /* =========================================
       모달 및 데이터 저장 (CRUD)
       ========================================= */
       
    // 모달 열기 (등록/수정)
    function openModal(type, id = null) {
        const modal = document.getElementById('noticeModal');
        if (!modal) return;
        
        if (type === 'create') {
            document.getElementById('modalTitle').innerText = '공지사항 등록';
            document.getElementById('noticeForm').reset(); // 폼 초기화
            document.getElementById('modalNoticeId').value = ''; 
            document.getElementById('checkVisible').checked = true; // 기본값
            // action 경로 작성 컨트롤러로 세팅
            document.getElementById('noticeForm').action = "/admin/notice/write_pro";
        } else {
            document.getElementById('modalTitle').innerText = '공지사항 수정';
            
            // 기존 데이터를 폼에 채워넣기
            const item = noticeList.find(n => n.noticeId === id);
            if (item) {
                document.getElementById('modalNoticeId').value = item.noticeId;
                document.getElementById('inputTitle').value = item.title;
                document.getElementById('inputContent').value = item.content || ''; 
                document.getElementById('checkImportant').checked = item.isImportant;
                document.getElementById('checkVisible').checked = item.isVisible;
                
                // TODO: 수정 기능 백엔드 개발 시 주석 해제 후 경로 변경
                // document.getElementById('noticeForm').action = "/admin/notice/edit_pro";
                alert("수정 기능은 현재 백엔드 API 연동이 필요합니다."); 
            }
        }

        modal.style.display = 'flex'; // admin.css 표준
    }

    function closeModal() {
        const modal = document.getElementById('noticeModal');
        if (modal) modal.style.display = 'none';
    }

    // 폼 전송 전 유효성 검사
    function saveNotice() {
        const titleInput = document.getElementById('inputTitle').value.trim();
        const contentInput = document.getElementById('inputContent').value.trim();
        const form = document.getElementById('noticeForm');

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

        // 브라우저 기본 form 전송(submit) 실행 -> 컨트롤러로 이동
        form.submit(); 
    }

    // 외부 노출
    return {
        searchTable,
        openModal,
        closeModal,
        saveNotice
    };

})();