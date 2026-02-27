/* =========================================
   /js/board/board_comp.js - 민원게시판 전용
   ========================================= */
let currentPostIdx = null; let currentPage = 1; const itemsPerPage = 10; let currentImgs = [];
let boardData = [];

function getTodayString() {
    const d = new Date(); return `${d.getFullYear()}.${String(d.getMonth() + 1).padStart(2, '0')}.${String(d.getDate()).padStart(2, '0')}`;
}

document.addEventListener("DOMContentLoaded", () => {
    renderList();
    const searchInput = document.getElementById('searchInput');
    if (searchInput) searchInput.addEventListener('keypress', e => { if (e.key === 'Enter') searchPost(); });
});
 
function renderList() {
    const displayData = window.globalBoardList || []; 

    document.getElementById('boardBody').innerHTML = displayData.map((p) => {
        const isDone = (p.compStatus === 'DONE');
        const statusColor = isDone ? '#10b981' : '#ef4444';
        const statusText = isDone ? '처리완료' : '답변대기';

        return `
        <tr onclick="location.href='/board/comp/detail/${p.compId}'" style="cursor:pointer;">
            <td>${p.compId}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
            <td>${p.authorName}</td> 
            <td>${p.formattedDate}</td>
            <td style="font-weight:bold; color:${statusColor};">${statusText}</td>
        </tr>
    `}).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px;">등록된 민원이 없습니다.</td></tr>';
    
}
/*function renderList() {
    document.getElementById('tableWrapper').style.display = 'block';
    const pagedData = boardData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

    // 민원게시판: 처리상태 추가 (총 6열)
    document.getElementById('boardBody').innerHTML = pagedData.map((p, index) => {
        const actualIdx = (currentPage - 1) * itemsPerPage + index;
        const statusColor = p.status === '완료' ? '#10b981' : '#ef4444'; // 녹색 or 빨간색
		const statusText = p.compStatus === 'DONE' ? '처리완료' : '답변대기';
        return `
        <tr onclick="showDetail(${actualIdx})" style="cursor:pointer;">
            <td>${p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
            <td>${p.author}</td>
            <td>${p.date}</td>
            <td>${p.hits}</td>
            <td style="font-weight:bold; color:${statusColor};">${p.status}</td>
        </tr>
    `}).join('') || '<tr><td colspan="6" style="text-align:center; padding:50px; color:#999;">등록된 민원이 없습니다.</td></tr>';

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
    } else {
        // 신규 민원은 기본적으로 '대기' 상태
        boardData.unshift({ id: boardData.length + 1, title: t, content: c, author: "본인", hits: 0, status: "대기", isMine: true, date: getTodayString(), imgs: [...currentImgs], comments: [] }); showList();
    }
}
function deletePost(idx) { const targetIdx = (idx !== undefined) ? idx : currentPostIdx; if (confirm("삭제하시겠습니까?")) { boardData.splice(targetIdx, 1); showList(); } }

function showDetail(compId) {
    location.href = `/complaint/detail/${compId}`;
}

function renderComments() {
    const post = boardData[currentPostIdx]; document.getElementById('commentCount').innerText = post.comments.length;
    document.getElementById('commentList').innerHTML = post.comments.map((c, idx) => `
        <div class="comment-unit" style="border-bottom:1px solid #f1f1f1; padding:15px 0;"><div class="comment-info" style="margin-bottom:8px;"><b>${c.author}</b><span style="color:#bbb; margin-left:10px; font-size:13px;">${c.date}</span><a href="javascript:void(0)" onclick="deleteComment(${idx})" style="margin-left:8px; text-decoration:none; color:#e74c3c; font-size:12px;">삭제</a></div><div style="font-size:15px; color:#333; line-height:1.5;">${c.text}</div></div>
    `).join('') || '<p style="text-align:center; color:#ccc; padding:30px;">관리자 답변이 없습니다.</p>';
}
function addComment() { const input = document.getElementById('commentInput'); if (!input.value.trim()) return alert("답변을 입력해주세요."); boardData[currentPostIdx].comments.push({ author: "본인", text: input.value.trim(), date: getTodayString() }); input.value = ''; renderComments(); }
function deleteComment(idx) { if (confirm("답변을 삭제할까요?")) { boardData[currentPostIdx].comments.splice(idx, 1); renderComments(); } }
function previewImages(input) { const container = document.getElementById('previewContainer'); container.innerHTML = ''; currentImgs = []; Array.from(input.files).slice(0, 3).forEach(file => { const reader = new FileReader(); reader.onload = (e) => { currentImgs.push(e.target.result); container.innerHTML += `<img src="${e.target.result}" style="width:80px; height:80px; object-fit:cover; border-radius:5px;">`; }; reader.readAsDataURL(file); }); }
function searchPost() {
    const type = document.getElementById('searchType').value; const keyword = document.getElementById('searchInput').value.trim().toLowerCase(); if (!keyword) { renderList(); return; }
    const filtered = boardData.filter(post => { const targetValue = (type === 'title') ? post.title : post.author; return targetValue.toLowerCase().includes(keyword); });
    document.getElementById('boardBody').innerHTML = filtered.map(p => {
        const statusColor = p.status === '완료' ? '#10b981' : '#ef4444';
        return `<tr onclick="showDetail(${boardData.indexOf(p)})" style="cursor:pointer;"><td>${p.id}</td><td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td><td>${p.author}</td><td>${p.date}</td><td>${p.hits}</td><td style="font-weight:bold; color:${statusColor};">${p.status}</td></tr>`;
    }).join('') || '<tr><td colspan="6" style="padding:50px; color:#999; text-align:center;">검색 결과가 없습니다.</td></tr>'; document.getElementById('paginationBox').innerHTML = '';
}