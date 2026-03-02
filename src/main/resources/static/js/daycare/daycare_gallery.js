/* =========================================
   /js/daycare/daycare_gallery.js - 실제 DB 연동 (Fetch API)
   ========================================= */

let currentPage = 1;
const itemsPerPage = 9; // 갤러리는 3x3=9개씩 보여주면 예쁩니다.
let boardData = []; // 진짜 데이터를 담을 빈 배열

document.addEventListener("DOMContentLoaded", () => {
    loadGalleries(); // 화면 열리면 데이터 로드
    
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') searchPost();
        });
    }
});

/* 1. 백엔드에서 갤러리 데이터 가져오기 */
function loadGalleries() {
    fetch('/api/daycare/galleries')
        .then(res => res.json())
        .then(data => {
            boardData = data;
            renderList();
        })
        .catch(err => console.error("갤러리 로드 에러:", err));
}

/* 2. 갤러리 카드 렌더링 */
function renderList() {
    const pagedData = boardData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    const wrapper = document.getElementById('galleryWrapper');
    
    wrapper.innerHTML = pagedData.map(p => `
        <div style="cursor:pointer; border:1px solid #eee; border-radius:10px; overflow:hidden; transition: transform 0.2s; box-shadow: 0 4px 6px rgba(0,0,0,0.05);" 
             onclick="showDetail(${p.id})"
             onmouseover="this.style.transform='translateY(-5px)'" 
             onmouseout="this.style.transform='translateY(0)'">
             
            <div style="height: 200px; overflow: hidden; background-color:#f8f9fa;">
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

/* 3. 상세보기 페이지 이동 */
function showDetail(id) {
    location.href = '/daycare/gallery/view?id=' + id;
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

function movePage(p) { currentPage = p; renderList(); }

function searchPost() {
    const keyword = document.getElementById('searchInput').value.trim().toLowerCase();
    if (!keyword) { loadGalleries(); return; }
    
    const filtered = boardData.filter(post => post.title.toLowerCase().includes(keyword));
    boardData = filtered;
    currentPage = 1;
    renderList();
}