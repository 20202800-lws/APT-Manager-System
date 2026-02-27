/* =========================================
   /js/board/board_anon.js - 익명게시판 전용
   ========================================= */
let currentPostIdx = null; let currentPage = 1; const itemsPerPage = 10; let currentImgs = [];
let boardData = window.globalBoardList;

function getTodayString() {
    const d = new Date(); return `${d.getFullYear()}.${String(d.getMonth() + 1).padStart(2, '0')}.${String(d.getDate()).padStart(2, '0')}`;
}

document.addEventListener("DOMContentLoaded", () => {
	boardData = window.globalBoardList;
    renderList();
    /*const searchInput = document.getElementById('searchInput');
    if (searchInput) searchInput.addEventListener('keypress', e => { if (e.key === 'Enter') searchPost(); });*/
});

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
			 onclick="location.href='/board/anon/view/${p.id}'" style="cursor:pointer;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
        </tr>
    `}).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 게시글이 없습니다.</td></tr>';

    // 페이징 UI는 백엔드에서 넘어온 paging 객체 정보를 활용해야 합니다.
}
/*function renderList() {
    document.getElementById('tableWrapper').style.display = 'block';
    const pagedData = boardData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

    // 익명게시판: 작성자 <td> 제거 (총 4열)
    document.getElementById('boardBody').innerHTML = pagedData.map((p, index) => {
        const actualIdx = (currentPage - 1) * itemsPerPage + index;
        return `
        <tr onclick="showDetail(${actualIdx})" style="cursor:pointer;">
            <td>${p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
        </tr>
    `}).join('') || '<tr><td colspan="4" style="text-align:center; padding:50px; color:#999;">등록된 게시글이 없습니다.</td></tr>';

    renderPaginationUI(boardData.length);
}*/

function renderPaginationUI(total) {
    const totalPages = Math.ceil(total / itemsPerPage);
    const pBox = document.getElementById('paginationBox'); pBox.innerHTML = '';
    if (totalPages <= 1) return;
    for (let i = 1;i <= totalPages;i++) pBox.innerHTML += `<span class="${i === currentPage ? 'active' : ''}" onclick="movePage(${i})" style="cursor:pointer;">${i}</span>`;
}
function movePage(p) { currentPage = p; renderList(); }
function showList() { document.getElementById('listView').style.display = 'block'; document.getElementById('writeView').style.display = 'none'; document.getElementById('detailView').style.display = 'none'; renderList(); }
function showWrite() { document.getElementById('listView').style.display = 'none'; document.getElementById('detailView').style.display = 'none'; document.getElementById('writeView').style.display = 'block'; document.getElementById('editIndex').value = ''; document.getElementById('inputTitle').value = ''; document.getElementById('inputContent').value = ''; document.getElementById('previewContainer').innerHTML = ''; currentImgs = []; }

function savePost() {
    const t = document.getElementById('inputTitle').value.trim(); const c = document.getElementById('inputContent').value.trim(); const editIdx = document.getElementById('editIndex').value;
    if (!t || !c) return alert("제목과 내용을 입력하세요.");
    if (editIdx !== "") {
        boardData[editIdx].title = t; boardData[editIdx].content = c; boardData[editIdx].imgs = [...currentImgs]; showDetail(editIdx);
    } else { boardData.unshift({ id: boardData.length + 1, title: t, content: c, author: "익명", hits: 0, isMine: true, date: getTodayString(), imgs: [...currentImgs], comments: [] }); showList(); }
}
function deletePost(idx) { const targetIdx = (idx !== undefined) ? idx : currentPostIdx; if (confirm("삭제하시겠습니까?")) { boardData.splice(targetIdx, 1); showList(); } }

function showDetail(idx) {
    currentPostIdx = idx; const post = boardData[idx]; post.hits++;
    document.getElementById('listView').style.display = 'none'; document.getElementById('detailView').style.display = 'block';
    document.getElementById('viewTitle').innerText = post.title;
    document.getElementById('viewuser_id').innerText = "익명"; // 강제 익명 처리
    document.getElementById('viewDate').innerText = post.date; document.getElementById('viewHits').innerText = post.hits; document.getElementById('viewContent').innerText = post.content;
    document.getElementById('viewImages').innerHTML = post.imgs.map(s => `<img src="${s}" style="max-width:100%; border-radius:10px; margin-top:10px;">`).join('');
    document.getElementById('commentArea').style.display = 'block'; renderComments();
}

function renderComments() {
    const post = boardData[currentPostIdx]; document.getElementById('commentCount').innerText = post.comments.length;
    document.getElementById('commentList').innerHTML = post.comments.map((c, idx) => `
        <div class="comment-unit" style="border-bottom:1px solid #f1f1f1; padding:15px 0;">
            <div class="comment-info" style="margin-bottom:8px;"><b>익명</b><span style="color:#bbb; margin-left:10px; font-size:13px;">${c.date}</span><a href="javascript:void(0)" onclick="deleteComment(${idx})" style="margin-left:8px; text-decoration:none; color:#e74c3c; font-size:12px;">삭제</a></div>
            <div style="font-size:15px; color:#333; line-height:1.5;">${c.text}</div></div>
    `).join('') || '<p style="text-align:center; color:#ccc; padding:30px;">아직 댓글이 없습니다.</p>';
}
function addComment() { const input = document.getElementById('commentInput'); if (!input.value.trim()) return alert("댓글 내용을 입력해주세요."); boardData[currentPostIdx].comments.push({ author: "익명", text: input.value.trim(), date: getTodayString() }); input.value = ''; renderComments(); }
function deleteComment(idx) { if (confirm("댓글을 삭제할까요?")) { boardData[currentPostIdx].comments.splice(idx, 1); renderComments(); } }
function previewImages(input) { const container = document.getElementById('previewContainer'); container.innerHTML = ''; currentImgs = []; Array.from(input.files).slice(0, 3).forEach(file => { const reader = new FileReader(); reader.onload = (e) => { currentImgs.push(e.target.result); container.innerHTML += `<img src="${e.target.result}" style="width:80px; height:80px; object-fit:cover; border-radius:5px;">`; }; reader.readAsDataURL(file); }); }

function searchPost() {
    // 1. 요소 가져오기
    const inputEl = document.getElementById('searchInput');
    const typeEl = document.getElementById('searchType');

    if (!inputEl) return;

    // 2. 값 추출
    const keyword = inputEl.value.trim();
    // 익명게시판에 select 박스가 있다면 그 값을 쓰고, 없다면 무조건 'title'로 보냄
    const type = typeEl ? typeEl.value : 'title';

    // 3. 실행 (콘솔로 확인 가능)
    console.log("익명 검색 실행:", type, keyword);

    // 4. 서버 이동
    location.href = `?page=0&searchType=${type}&searchInput=${encodeURIComponent(keyword)}`;
}
/*function searchPost() {
    const keyword = document.getElementById('searchInput').value.trim().toLowerCase(); if (!keyword) { renderList(); return; }
    const filtered = boardData.filter(post => post.title.toLowerCase().includes(keyword));
    document.getElementById('boardBody').innerHTML = filtered.map(p => `
        <tr onclick="showDetail(${boardData.indexOf(p)})" style="cursor:pointer;">
				<td>${p.id}</td>
		           <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
		           <td>${p.author}</td>
		           <td>${p.date}</td>
		           <td>${p.hits}</td>
		</tr>
    `).join('') || '<tr><td colspan="5" style="padding:50px; color:#999; text-align:center;">검색 결과가 없습니다.</td></tr>'; document.getElementById('paginationBox').innerHTML = '';
}*/