/* =========================================
   /js/daycare/daycare_notice.js - 어린이집 공지사항 전용
   ========================================= */

let currentPage = 1;
const itemsPerPage = 10;

// 임시 데이터 (백엔드 연동 전 화면 확인용)
let boardData = [
    { id: 3, title: "이번 주 금요일 어린이집 소풍 안내", author: "햇님반 선생님", date: "2026.02.24", hits: 42 },
    { id: 2, title: "3월 식단표 안내해 드립니다.", author: "영양사", date: "2026.02.20", hits: 85 },
    { id: 1, title: "어린이집 신입 원아 오리엔테이션 안내", author: "원장님", date: "2026.02.15", hits: 120 }
];

document.addEventListener("DOMContentLoaded", () => {
    renderList();
    
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') searchPost();
        });
    }
});

/* 게시글 목록 렌더링 */
function renderList() {
    const pagedData = boardData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    
    document.getElementById('boardBody').innerHTML = pagedData.map(p => `
        <tr onclick="showDetail(${p.id})" style="cursor:pointer;">
            <td><span style="background:#ef4444; color:white; padding:2px 8px; border-radius:10px; font-size:12px; font-weight:bold;">공지</span></td>
            <td class="title-cell" style="text-align:left; padding-left:15px; font-weight:600;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
        </tr>
    `).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 공지사항이 없습니다.</td></tr>';

    renderPaginationUI(boardData.length);
}

/* ★ 상세보기 페이지로 실제 URL 이동! */
function showDetail(id) {
    // 백엔드 연동 시 게시글 번호(id)를 달고 view 페이지로 넘어갑니다.
    location.href = '/daycare/notice/view?id=' + id;
}

/* 페이징 및 검색 로직 */
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
    if (!keyword) { renderList(); return; }

    const filtered = boardData.filter(post => post.title.toLowerCase().includes(keyword));

    document.getElementById('boardBody').innerHTML = filtered.map(p => `
        <tr onclick="showDetail(${p.id})" style="cursor:pointer;">
            <td>공지</td>
            <td class="title-cell" style="text-align:left; padding-left:15px; font-weight:600;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
        </tr>
    `).join('') || '<tr><td colspan="5" style="padding:50px; color:#999; text-align:center;">검색 결과가 없습니다.</td></tr>';
    
    document.getElementById('paginationBox').innerHTML = '';
}