/* =========================================
   /js/daycare/daycare_notice.js - 실제 DB 연동 (Fetch API)
   ========================================= */

let currentPage = 1;
const itemsPerPage = 10;
let boardData = []; 

document.addEventListener("DOMContentLoaded", () => {
    loadNotices(); 
    
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') searchPost();
        });
    }
});

function loadNotices() {
    fetch('/api/daycare/notices')
        .then(res => res.json())
        .then(data => {
            boardData = data; 
            renderList();     
        })
        .catch(err => console.error("공지사항 로드 에러:", err));
}

function renderList() {
    const pagedData = boardData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    const tbody = document.getElementById('boardBody');
    
    // ★ 프론트와 백엔드의 변수명(DTO) 차이로 인한 undefined 에러 완벽 방어
    tbody.innerHTML = pagedData.map(p => {
        const id = p.noticeId || p.id;
        const isTop = p.isTop === true;
        const title = p.title || '제목 없음';
        const author = p.writerName || p.author || '관리자';
        const date = p.regDate || p.date || '';
        const hits = p.views !== undefined ? p.views : (p.hits || 0);

        return `
        <tr onclick="showDetail(${id})" style="cursor:pointer; background-color: ${isTop ? '#fffbea' : 'transparent'};">
            <td>${isTop ? '<span style="background:#ef4444; color:white; padding:2px 8px; border-radius:10px; font-size:12px; font-weight:bold;">공지</span>' : id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px; font-weight:${isTop ? 'bold' : 'normal'};">${title}</td>
            <td>${author}</td>
            <td>${date}</td>
            <td>${hits}</td>
        </tr>
        `;
    }).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 공지사항이 없습니다.</td></tr>';

    renderPaginationUI(boardData.length);
}

function showDetail(id) {
    if(!id) return;
    location.href = '/daycare/notice/view?id=' + id;
}

function renderPaginationUI(total) {
    const totalPages = Math.ceil(total / itemsPerPage);
    const pBox = document.getElementById('paginationBox'); 
    pBox.innerHTML = '';
    if (totalPages <= 1) return;
    for (let i = 1; i <= totalPages; i++) {
        pBox.innerHTML += `<span class="${i === currentPage ? 'active' : ''}" onclick="movePage(${i})" style="cursor:pointer;">${i}</span>`;
    }
}

function movePage(p) { 
    currentPage = p; 
    renderList(); 
}

function searchPost() {
    const keyword = document.getElementById('searchInput').value.trim().toLowerCase();
    if (!keyword) { loadNotices(); return; } 

    const filtered = boardData.filter(post => (post.title || '').toLowerCase().includes(keyword));
    boardData = filtered; 
    currentPage = 1;
    renderList(); 
}