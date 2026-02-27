/* =========================================
   /js/board/board_free.js - 자유게시판 전용 스크립트
   ========================================= */

let currentPostIdx = null;
let currentPage = 1;
const itemsPerPage = 10;
let currentImgs = [];

// 백엔드 연동 전 테스트용 임시 데이터 (자유게시판 전용)
let boardData = window.globalBoardList;

// 오늘 날짜 구하는 헬퍼 함수
function getTodayString() {
    const d = new Date();
    return `${d.getFullYear()}.${String(d.getMonth() + 1).padStart(2, '0')}.${String(d.getDate()).padStart(2, '0')}`;
}

document.addEventListener("DOMContentLoaded", () => {
	boardData = window.globalBoardList;
    renderList();
    
    // 검색창 엔터키 이벤트
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') searchPost();
        });
    }
});

/* 게시글 목록 렌더링 */
function renderList() {
    const tbody = document.getElementById('boardBody');
    if(!tbody) return;

    // 백엔드에서 이미 10개씩 끊어서 가져왔다면 slice 제거
    // 만약 전체 데이터를 다 가져왔다면 기존 slice 유지
    const displayData = boardData; 

    tbody.innerHTML = displayData.map((p) => {
        return `
        <tr>
            <td>${p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;" 
			 onclick="location.href='/board/free/view/${p.id}'"
			  style="cursor:pointer;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
        </tr>
    `}).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 게시글이 없습니다.</td></tr>';

    // 페이징 UI는 백엔드에서 넘어온 paging 객체 정보를 활용해야 합니다.
}
/*function renderList() {
    const tableWrap = document.getElementById('tableWrapper');
    tableWrap.style.display = 'block'; 

    const pagedData = boardData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    
    document.getElementById('boardBody').innerHTML = pagedData.map((p, index) => {
        const actualIdx = (currentPage - 1) * itemsPerPage + index;
        return `
        <tr onclick="showDetail(${actualIdx})" style="cursor:pointer;">
            <td>${p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
        </tr>
    `}).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 게시글이 없습니다.</td></tr>';

    renderPaginationUI(boardData.length);
}*/

/* 페이징 로직 */
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

/* 뷰 전환 로직 */
function showList() { 
    document.getElementById('listView').style.display = 'block'; 
    document.getElementById('writeView').style.display = 'none'; 
    document.getElementById('detailView').style.display = 'none'; 
    renderList(); 
}

function showWrite() {
    document.getElementById('listView').style.display = 'none'; 
    document.getElementById('detailView').style.display = 'none';
    document.getElementById('writeView').style.display = 'block';
    
    // 폼 초기화
    document.getElementById('editIndex').value = ''; 
    document.getElementById('inputTitle').value = ''; 
    document.getElementById('inputContent').value = ''; 
    document.getElementById('previewContainer').innerHTML = '';
    currentImgs = [];
}

/* 게시글 저장 (등록/수정) */
function savePost() {
    const t = document.getElementById('inputTitle').value.trim();
    const c = document.getElementById('inputContent').value.trim(); 
    const editIdx = document.getElementById('editIndex').value;
    
    if (!t) return alert("제목을 입력하세요.");
    if (!c) return alert("내용을 입력하세요.");
    
    if (editIdx !== "") { 
        // 수정
        boardData[editIdx].title = t; 
        boardData[editIdx].content = c;
        boardData[editIdx].imgs = [...currentImgs];
        showDetail(editIdx); 
    } else { 
        // 신규 등록
        boardData.unshift({ 
            id: boardData.length + 1, 
            title: t, 
            content: c, 
            author: "본인", // 추후 로그인된 유저 정보로 변경
            hits: 0, 
            isMine: true, 
            date: getTodayString(), 
            imgs: [...currentImgs], 
            comments: [] 
        });
        showList(); 
    }
}

function deletePost(idx) { 
    const targetIdx = (idx !== undefined) ? idx : currentPostIdx; 
    if (confirm("정말 삭제하시겠습니까?")) { 
        boardData.splice(targetIdx, 1); 
        showList();
    } 
}

/* 게시글 상세 보기 */
function showDetail(idx) {
    currentPostIdx = idx; 
    const post = boardData[idx]; 
    post.hits++; // 조회수 증가
    
    document.getElementById('listView').style.display = 'none'; 
    document.getElementById('detailView').style.display = 'block';
    
    document.getElementById('viewTitle').innerText = post.title;
    document.getElementById('viewuser_id').innerText = post.author;
    document.getElementById('viewDate').innerText = post.date; 
    document.getElementById('viewHits').innerText = post.hits; 
    document.getElementById('viewContent').innerText = post.content;
    
    document.getElementById('viewImages').innerHTML = post.imgs.map(s => `
        <img src="${s}" style="max-width:100%; border-radius:10px; margin-top:10px;">
    `).join('');
    
    // 자유게시판은 항상 댓글창 표시
    document.getElementById('commentArea').style.display = 'block';
    renderComments();
}

/* 댓글 렌더링 */
function renderComments() {
    const post = boardData[currentPostIdx];
    const list = document.getElementById('commentList');
    
    document.getElementById('commentCount').innerText = post.comments.length;
    
    list.innerHTML = post.comments.map((c, idx) => `
        <div class="comment-unit" style="border-bottom:1px solid #f1f1f1; padding:15px 0;">
            <div class="comment-info" style="margin-bottom:8px;">
                <b>${c.author}</b> 
                <span style="color:#bbb; margin-left:10px; font-size:13px;">${c.date}</span> 
                <a href="javascript:void(0)" onclick="deleteComment(${idx})" style="margin-left:8px; text-decoration:none; color:#e74c3c; font-size:12px;">삭제</a>
            </div>
            <div style="font-size:15px; color:#333; line-height:1.5;">${c.text}</div>
        </div>
    `).join('') || '<p style="text-align:center; color:#ccc; padding:30px;">아직 댓글이 없습니다.</p>';
}

function addComment() { 
    const input = document.getElementById('commentInput');
    if (!input.value.trim()) return alert("댓글 내용을 입력해주세요.");
    
    boardData[currentPostIdx].comments.push({ 
        author: "본인", 
        text: input.value.trim(), 
        date: getTodayString() 
    });
    
    input.value = ''; 
    renderComments();
}

function deleteComment(idx) { 
    if (confirm("댓글을 삭제할까요?")) { 
        boardData[currentPostIdx].comments.splice(idx, 1); 
        renderComments(); 
    } 
}

/* 이미지 첨부 미리보기 */
function previewImages(input) { 
    const container = document.getElementById('previewContainer');
    container.innerHTML = ''; 
    currentImgs = [];
    
    Array.from(input.files).slice(0, 3).forEach(file => { 
        const reader = new FileReader(); 
        reader.onload = (e) => { 
            currentImgs.push(e.target.result); 
            container.innerHTML += `<img src="${e.target.result}" style="width:80px; height:80px; object-fit:cover; border-radius:5px;">`; 
        }; 
        reader.readAsDataURL(file); 
    });
}

/* 검색 로직 */
function searchPost() {
    const type = document.getElementById('searchType').value;
    const keyword = document.getElementById('searchInput').value.trim();
    
    // 검색어가 없으면 전체 목록으로, 있으면 검색 파라미터를 붙여서 '페이지 이동'을 시킴
    // 이렇게 하면 JSP가 다시 로드되면서 서버에서 페이징 바를 새로 그려줍니다.
    location.href = `?page=0&searchType=${type}&searchInput=${encodeURIComponent(keyword)}`;
}
/*function searchPost() {
    const type = document.getElementById('searchType').value;
    const keyword = document.getElementById('searchInput').value.trim().toLowerCase();
    
    if (!keyword) { renderList(); return; }

    const filtered = boardData.filter(post => {
        const targetValue = (type === 'title') ? post.title : post.author;
        return targetValue.toLowerCase().includes(keyword);
    });

    document.getElementById('boardBody').innerHTML = filtered.map(p => `
        <tr onclick="showDetail(${boardData.indexOf(p)})" style="cursor:pointer;">
            <td>${p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
        </tr>
    `).join('') || '<tr><td colspan="5" style="padding:50px; color:#999; text-align:center;">검색 결과가 없습니다.</td></tr>';
    
    document.getElementById('paginationBox').innerHTML = '';
}*/