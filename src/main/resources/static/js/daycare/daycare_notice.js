/* =========================================
   /js/daycare/daycare_notice.js - 실제 DB 연동 (Fetch API)
   ========================================= */

let currentPage = 1;
const itemsPerPage = 10;
let boardData = []; // 서버에서 받아올 진짜 데이터를 담을 빈 배열

document.addEventListener("DOMContentLoaded", () => {
    loadNotices(); // 화면이 열리면 가장 먼저 백엔드에 데이터를 요청함
    
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') searchPost();
        });
    }
});

/* 1. 백엔드에서 공지사항 데이터 가져오기 */
function loadNotices() {
    fetch('/api/daycare/notices')
        .then(res => res.json())
        .then(data => {
            boardData = data; // 서버가 준 진짜 데이터로 배열 채우기
            renderList();     // 화면에 그리기
        })
        .catch(err => console.error("공지사항 로드 에러:", err));
}

/* 2. 게시글 목록 렌더링 */
function renderList() {
    const pagedData = boardData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    const tbody = document.getElementById('boardBody');
    
    tbody.innerHTML = pagedData.map(p => `
        <tr onclick="showDetail(${p.id})" style="cursor:pointer; background-color: ${p.isTop ? '#fffbea' : 'transparent'};">
            <td>${p.isTop ? '<span style="background:#ef4444; color:white; padding:2px 8px; border-radius:10px; font-size:12px; font-weight:bold;">공지</span>' : p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px; font-weight:${p.isTop ? 'bold' : 'normal'};">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
        </tr>
    `).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 공지사항이 없습니다.</td></tr>';

    renderPaginationUI(boardData.length);
}

/* 3. 상세보기 페이지로 실제 URL 이동 */
function showDetail(id) {
    location.href = '/daycare/notice/view?id=' + id;
}

/* 4. 페이징 및 검색 로직 */
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
    if (!keyword) { loadNotices(); return; } // 검색어 없으면 전체 다시 로드

    const filtered = boardData.filter(post => post.title.toLowerCase().includes(keyword));
    boardData = filtered; // 필터링된 결과로 덮어쓰고
    currentPage = 1;
    renderList(); // 다시 그리기
}