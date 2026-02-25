/* =========================================
   /js/daycare/daycare_gallery.js - 활동 갤러리 전용
   ========================================= */

let currentPage = 1;
const itemsPerPage = 9; // 갤러리는 3x3=9개씩 보여주면 예쁩니다.

// 임시 데이터 (백엔드 연동 전 화면 확인용)
let boardData = [
    { id: 3, title: "봄맞이 딸기농장 체험학습 🍓", author: "햇님반 선생님", date: "2026.04.10", hits: 85, thumb: "https://images.unsplash.com/photo-1596431336582-8959f23cc723?w=500&auto=format&fit=crop" },
    { id: 2, title: "즐거운 체육활동 시간 🏃‍♂️", author: "체육 선생님", date: "2026.03.25", hits: 52, thumb: "https://images.unsplash.com/photo-1519340082725-b873a436be3c?w=500&auto=format&fit=crop" },
    { id: 1, title: "어린이집 오리엔테이션 풍경", author: "원장님", date: "2026.02.15", hits: 120, thumb: "https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?w=500&auto=format&fit=crop" }
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

/* 갤러리 카드 렌더링 */
function renderList() {
    const pagedData = boardData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    const wrapper = document.getElementById('galleryWrapper');
    
    wrapper.innerHTML = pagedData.map(p => `
        <div style="cursor:pointer; border:1px solid #eee; border-radius:10px; overflow:hidden; transition: transform 0.2s; box-shadow: 0 4px 6px rgba(0,0,0,0.05);" 
             onclick="showDetail(${p.id})"
             onmouseover="this.style.transform='translateY(-5px)'" 
             onmouseout="this.style.transform='translateY(0)'">
             
            <div style="height: 200px; overflow: hidden;">
                <img src="${p.thumb}" alt="썸네일" style="width:100%; height:100%; object-fit:cover;">
            </div>
            
            <div style="padding: 15px;">
                <h4 style="margin:0 0 10px 0; font-size:16px; color:#1a0b2e; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${p.title}</h4>
                <div style="display:flex; justify-content:space-between; font-size:13px; color:#888;">
                    <span>${p.author}</span>
                    <span>${p.date}</span>
                </div>
            </div>
        </div>
    `).join('') || '<p style="grid-column:1/4; text-align:center; padding:50px; color:#999;">등록된 사진이 없습니다.</p>';

    renderPaginationUI(boardData.length);
}

/* 상세보기 페이지 이동 */
function showDetail(id) {
    location.href = '/daycare/gallery/view?id=' + id;
}

/* 페이징 및 검색 (기존과 동일) */
function renderPaginationUI(total) {
    const totalPages = Math.ceil(total / itemsPerPage);
    const pBox = document.getElementById('paginationBox'); 
    pBox.innerHTML = '';
    if (totalPages <= 1) return;
    for (let i = 1; i <= totalPages; i++) {
        pBox.innerHTML += `<span class="${i === currentPage ? 'active' : ''}" onclick="movePage(${i})" style="cursor:pointer;">${i}</span>`;
    }
}

function movePage(p) { currentPage = p; renderList(); }

function searchPost() {
    const keyword = document.getElementById('searchInput').value.trim().toLowerCase();
    if (!keyword) { renderList(); return; }
    const filtered = boardData.filter(post => post.title.toLowerCase().includes(keyword));
    // 임시 검색 렌더링 (동일 로직 생략)
    boardData = filtered; // 프로토타입용 야매(?) 처리
    renderList();
}