/* =========================================
   /js/board/board_anon.js - 익명게시판 전용 (서버 연동형)
   ========================================= */

document.addEventListener("DOMContentLoaded", () => {
    // JSP에서 주입한 백엔드 진짜 데이터를 받아옵니다.
    const boardData = window.globalBoardList || [];
    renderList(boardData);
});

// 백엔드 데이터를 화면에 예쁘게 그리는 함수
function renderList(displayData) {
    const tbody = document.getElementById('boardBody');
    if(!tbody) return;

    tbody.innerHTML = displayData.map((p) => {
        // ★ 버그 수정: td가 아닌 tr 전체에 onclick을 걸어서 어디를 눌러도 글이 열리게 수정!
        return `
        <tr onclick="location.href='/board/anon/view/${p.id}'" style="cursor:pointer;">
            <td>${p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date.substring(0, 10)}</td>
            <td>${p.hits}</td>
        </tr>
        `;
    }).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 게시글이 없습니다.</td></tr>';
}

// 서버로 검색 요청 보내기
function searchPost() {
    const inputEl = document.getElementById('searchInput');
    const typeEl = document.getElementById('searchType');

    if (!inputEl) return;

    const keyword = inputEl.value.trim();
    // 익명게시판에 select 박스가 있다면 그 값을 쓰고, 없다면 무조건 'title'로 보냄
    const type = typeEl ? typeEl.value : 'title';

    // 스프링 부트 컨트롤러로 검색 파라미터 전송
    location.href = `?page=0&searchType=${type}&searchInput=${encodeURIComponent(keyword)}`;
}

// =========================================
// 글쓰기 화면 - 다중 이미지 미리보기 기능
// =========================================
function previewImages(input) {
    // JSP 파일의 id 컨테이너 찾기 (호환성을 위해 두 가지 id 모두 체크)
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