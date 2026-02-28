/* =========================================
   /js/board/board_free.js - 자유게시판 전용 스크립트 (서버 연동형)
   ========================================= */

document.addEventListener("DOMContentLoaded", () => {
    // JSP에서 주입한 백엔드 진짜 데이터를 받아옵니다.
    const boardData = window.globalBoardList || [];
    renderList(boardData);
    
    // 검색창 엔터키 이벤트 (엔터 누르면 바로 서버로 검색 요청)
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') searchPost();
        });
    }
});

/* 게시글 목록 렌더링 */
function renderList(displayData) {
    const tbody = document.getElementById('boardBody');
    if(!tbody) return;

    tbody.innerHTML = displayData.map((p) => {
        // ★ 버그 수정: td가 아닌 tr 전체에 onclick을 걸어서 어디를 눌러도 글이 열리게 수정!
        return `
        <tr onclick="location.href='/board/free/view/${p.id}'" style="cursor:pointer;">
            <td>${p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date.substring(0, 10)}</td>
            <td>${p.hits}</td>
        </tr>
        `;
    }).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 게시글이 없습니다.</td></tr>';
}

/* 검색 로직 (서버로 파라미터 전송) */
function searchPost() {
    const typeEl = document.getElementById('searchType');
    const inputEl = document.getElementById('searchInput');

    if (!inputEl) return;

    const type = typeEl ? typeEl.value : 'title';
    const keyword = inputEl.value.trim();
    
    // 검색 파라미터를 붙여서 '페이지 이동' 시킴 (스프링 부트가 받아서 처리)
    location.href = `?page=0&searchType=${type}&searchInput=${encodeURIComponent(keyword)}`;
}

// =========================================
// 글쓰기 화면 - 다중 이미지 미리보기 기능
// =========================================
function previewImages(input) { 
    // 호환성을 위해 두 가지 id 모두 체크 (JSP에서 어떤 걸 쓰든 작동하게 방어)
    const container = document.getElementById('imagePreviewContainer') || document.getElementById('previewContainer');
    if (!container) return;

    container.innerHTML = ''; 
    
    if (input.files && input.files.length > 0) {
        Array.from(input.files).forEach(file => {
            if (file.type.startsWith('image/')) {
                const img = document.createElement('img');
                img.src = URL.createObjectURL(file);
                img.style.width = '120px';
                img.style.height = '120px';
                img.style.objectFit = 'cover';
                img.style.borderRadius = '8px';
                img.style.border = '1px solid #ddd';
                img.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';
                
                container.appendChild(img);
            }
        });
    }
}