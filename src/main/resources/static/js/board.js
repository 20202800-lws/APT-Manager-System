/* borad.js - 게시판 관련 스크립트 */

let currentBoard = 'free';
let currentPostIdx = null;
let boards = {
    free: [{ id: 1, title: "단지 소독 안내", content: "내일 소독합니다. 창문을 닫아주세요.", author: "관리소", date: "2026.01.25", hits: 125, imgs: [], isMine: false, comments: [] }],
    anon: [], complain: [], kidsNotice: [], kidsGallery: [], 
    kidsTalk: [{ id: 1, title: "의견", content: "선생님들 항상 친절하게 우리 아이들 돌봐주셔서 감사합니다!", author: "동심엄마", date: "2026.01.29 14:20", hits: 0, imgs: [], isMine: true, comments: [] }]
};
let currentImgs = [];
let currentPage = 1;
const itemsPerPage = 10;

function simulateClick(idx) {
    const sideItems = document.querySelectorAll('.side-item, .side-sub-item');
    if(sideItems[idx]) sideItems[idx].click();
}

function changeBoard(type, el) {
    currentBoard = type; currentPage = 1;
    document.querySelectorAll('.side-item, .side-sub-item').forEach(i => i.classList.remove('active'));
    el.classList.add('active');
    const root = document.getElementById('kidsMenuRoot');
    if(el.classList.contains('side-sub-item')) root.classList.add('is-active');
    else root.classList.remove('is-active');
    document.getElementById('boardTitle').innerText = el.innerText.replace('공지사항', '어린이집 공지사항').replace('활동갤러리', '어린이집 활동갤러리');
    document.getElementById('topWriteBtn').style.display = (type === 'kidsTalk') ? 'none' : 'block';
    showList();
}

function renderList() {
    const tableWrap = document.getElementById('tableWrapper');
    const gallWrap = document.getElementById('galleryWrapper');
    const talkWrap = document.getElementById('talkWrapper');
    tableWrap.style.display = 'none'; gallWrap.style.display = 'none'; talkWrap.style.display = 'none';
    const sourceData = boards[currentBoard];
    const pagedData = sourceData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    
    if (currentBoard === 'kidsGallery') {
        gallWrap.style.display = 'grid';
        gallWrap.innerHTML = pagedData.map(p => `<div style="cursor:pointer; border:1px solid #eee; border-radius:10px; overflow:hidden;" onclick="showDetail(${boards[currentBoard].indexOf(p)})"><img src="${p.imgs[0] || 'https://via.placeholder.com/400x300'}" style="width:100%; height:200px; object-fit:cover;"></div>`).join('');
    } else if (currentBoard === 'kidsTalk') {
        talkWrap.style.display = 'block';
        document.getElementById('talkList').innerHTML = pagedData.map(p => {
            const idx = boards[currentBoard].indexOf(p);
            return `
            <div class="talk-item">
                <div class="talk-date-top">${p.date}</div>
                <div class="talk-content-area" id="talkView-${idx}">
                    <span class="talk-nick">${p.author} :</span>
                    <div class="talk-text">${p.content}</div>
                    ${p.isMine ? `<div class="talk-btns"><button class="btn-sub" onclick="openInlineEdit(${idx})">수정</button> <button class="btn-danger" onclick="deletePost(${idx})">삭제</button></div>` : ''}
                </div>
                <div class="edit-inline-area" id="talkEdit-${idx}" style="display:none;">
                    <textarea id="editInput-${idx}">${p.content}</textarea>
                    <div style="text-align:right;"><button class="btn-sub" onclick="closeInlineEdit(${idx})">취소</button> <button class="btn-main" onclick="saveInlineEdit(${idx})">저장</button></div>
                </div>
            </div>`;
        }).join('');
    } else {
        tableWrap.style.display = 'block';
        document.getElementById('boardBody').innerHTML = pagedData.map(p => `<tr onclick="showDetail(${boards[currentBoard].indexOf(p)})" style="cursor:pointer;"><td>${p.id}</td><td class="title-cell">${p.title}</td><td>${currentBoard==='anon'?'익명':p.author}</td><td>${p.date}</td><td>${p.hits}</td></tr>`).join('');
    }
    renderPaginationUI(sourceData.length);
}

function openInlineEdit(idx) { document.getElementById(`talkView-${idx}`).style.display = 'none'; document.getElementById(`talkEdit-${idx}`).style.display = 'block'; }
function closeInlineEdit(idx) { document.getElementById(`talkView-${idx}`).style.display = 'flex'; document.getElementById(`talkEdit-${idx}`).style.display = 'none'; }
function saveInlineEdit(idx) {
    const newVal = document.getElementById(`editInput-${idx}`).value;
    if(!newVal.trim()) return;
    boards.kidsTalk[idx].content = newVal; renderList();
}

function saveQuickTalk() {
    const val = document.getElementById('quickInput').value;
    if(!val.trim()) return alert("의견을 입력해주세요.");
    boards.kidsTalk.unshift({ id: boards.kidsTalk.length + 1, title: "의견", content: val, author: "본인", hits: 0, isMine: true, date: "2026.01.29 15:45", imgs: [], comments: [] });
    document.getElementById('quickInput').value = ''; renderList();
}

function renderPaginationUI(total) {
    const totalPages = Math.ceil(total / itemsPerPage);
    const pBox = document.getElementById('paginationBox'); pBox.innerHTML = '';
    for (let i = 1; i <= totalPages; i++) pBox.innerHTML += `<span class="${i===currentPage?'active':''}" onclick="movePage(${i})">${i}</span>`;
}

function movePage(p) { currentPage = p; renderList(); }
function showList() { document.getElementById('listView').style.display = 'block'; document.getElementById('writeView').style.display = 'none'; document.getElementById('detailView').style.display = 'none'; renderList(); }

function showWrite() {
    document.getElementById('listView').style.display = 'none'; document.getElementById('detailView').style.display = 'none';
    document.getElementById('writeView').style.display = 'block';
    document.getElementById('editIndex').value = ''; document.getElementById('inputTitle').value = ''; document.getElementById('inputContent').value = ''; document.getElementById('previewContainer').innerHTML = '';
    document.getElementById('formTitle').innerText = "새 게시글 작성";
}

function savePost() {
    const t = document.getElementById('inputTitle').value;
    const c = document.getElementById('inputContent').value; 
    const editIdx = document.getElementById('editIndex').value;
    if(!c) return alert("내용을 입력하세요.");
    if(editIdx !== "") { 
        boards[currentBoard][editIdx].content = c;
        boards[currentBoard][editIdx].title = t; 
        showDetail(editIdx); 
    }
    else { 
        boards[currentBoard].unshift({ id: boards[currentBoard].length + 1, title: t || "공지", content: c, author: "본인", hits: 0, isMine: true, date: "2026.01.29", imgs: [...currentImgs], comments: [] });
        showList(); 
    }
}

function deletePost(idx) { 
    const targetIdx = (idx !== undefined) ? idx : currentPostIdx; 
    if(confirm("정말 삭제하시겠습니까?")) { 
        boards[currentBoard].splice(targetIdx, 1); 
        if(currentBoard==='kidsTalk') renderList(); else showList();
    } 
}

function showDetail(idx) {
    if(currentBoard === 'kidsTalk') return;
    currentPostIdx = idx; const post = boards[currentBoard][idx]; post.hits++;
    document.getElementById('listView').style.display = 'none'; document.getElementById('detailView').style.display = 'block';
    document.getElementById('viewTitle').innerText = post.title;
    document.getElementById('viewAuthor').innerText = (currentBoard === 'anon' ? "익명" : post.author);
    document.getElementById('viewDate').innerText = post.date; document.getElementById('viewHits').innerText = post.hits; document.getElementById('viewContent').innerText = post.content;
    document.getElementById('viewImages').innerHTML = post.imgs.map(s => `<img src="${s}" style="max-width:100%; border-radius:10px; margin-top:10px;">`).join('');
    document.getElementById('commentArea').style.display = (currentBoard === 'kidsGallery' || currentBoard === 'kidsNotice') ? 'none' : 'block';
    renderComments();
}

function renderComments() {
    const post = boards[currentBoard][currentPostIdx];
    const list = document.getElementById('commentList');
    document.getElementById('commentCount').innerText = post.comments.length;
    list.innerHTML = post.comments.map((c, idx) => `
        <div class="comment-unit">
            <div class="comment-info"><b>${c.author}</b> <span style="color:#bbb; margin-left:10px;">${c.date}</span> <a href="javascript:void(0)" onclick="deleteComment(${idx})" style="margin-left:8px; text-decoration:none; color:#e74c3c; font-size:12px;">삭제</a></div>
            <div style="font-size:15px; color:#333; line-height:1.5;">${c.text}</div>
        </div>`).join('') || '<p style="text-align:center; color:#ccc; padding:30px;">아직 댓글이 없습니다.</p>';
}

function addComment() { 
    const input = document.getElementById('commentInput');
    if(!input.value.trim()) return alert("댓글 내용을 입력해주세요.");
    boards[currentBoard][currentPostIdx].comments.push({ author: "본인", text: input.value, date: "2026.01.29" });
    input.value = ''; renderComments();
}
function deleteComment(idx) { if(confirm("댓글을 삭제할까요?")) { boards[currentBoard][currentPostIdx].comments.splice(idx, 1); renderComments(); } }

function previewImages(input) { 
    const container = document.getElementById('previewContainer');
    container.innerHTML = ''; currentImgs = [];
    Array.from(input.files).slice(0, 3).forEach(file => { 
        const reader = new FileReader(); 
        reader.onload = (e) => { 
            currentImgs.push(e.target.result); 
            container.innerHTML += `<img src="${e.target.result}" style="width:80px; height:80px; object-fit:cover; border-radius:5px;">`; 
        }; 
        reader.readAsDataURL(file); 
    });
}

function searchPost() {
    const type = document.getElementById('searchType').value;
    const keyword = document.getElementById('searchInput').value.trim().toLowerCase();
    if (!keyword) { renderList(); return; }

    const tableWrap = document.getElementById('tableWrapper');
    const gallWrap = document.getElementById('galleryWrapper');
    const talkWrap = document.getElementById('talkWrapper');
    const talkList = document.getElementById('talkList');
    const boardBody = document.getElementById('boardBody');

    const filtered = boards[currentBoard].filter(post => {
        const targetValue = (type === 'title') ? post.title : post.author;
        return targetValue.toLowerCase().includes(keyword);
    });

    if (currentBoard === 'kidsGallery') {
        tableWrap.style.display = 'none'; talkWrap.style.display = 'none'; gallWrap.style.display = 'grid';
        gallWrap.innerHTML = filtered.map(p => `
            <div style="cursor:pointer; border:1px solid #eee; border-radius:10px; overflow:hidden;" onclick="showDetail(${boards[currentBoard].indexOf(p)})">
                <img src="${p.imgs[0] || 'https://via.placeholder.com/400x300'}" style="width:100%; height:200px; object-fit:cover;">
            </div>`).join('') || '<p style="grid-column:1/4; text-align:center; padding:50px; color:#999;">검색 결과가 없습니다.</p>';
    } else if (currentBoard === 'kidsTalk') {
        tableWrap.style.display = 'none'; gallWrap.style.display = 'none'; talkWrap.style.display = 'block';
        talkList.innerHTML = filtered.map(p => {
            const idx = boards[currentBoard].indexOf(p);
            return `
                <div class="talk-item">
                    <div class="talk-date-top">${p.date}</div>
                    <div class="talk-content-area">
                        <span class="talk-nick">${p.author} :</span>
                        <div class="talk-text">${p.content}</div>
                    </div>
                </div>`;
        }).join('') || '<p style="text-align:center; padding:50px; color:#999;">검색 결과가 없습니다.</p>';
    } else {
        gallWrap.style.display = 'none'; talkWrap.style.display = 'none'; tableWrap.style.display = 'block';
        boardBody.innerHTML = filtered.map(p => `
            <tr onclick="showDetail(${boards[currentBoard].indexOf(p)})" style="cursor:pointer;">
                <td>${p.id}</td>
                <td class="title-cell">${p.title}</td>
                <td>${currentBoard==='anon'?'익명':p.author}</td>
                <td>${p.date}</td>
                <td>${p.hits}</td>
            </tr>`).join('') || '<tr><td colspan="5" style="padding:50px; color:#999;">검색 결과가 없습니다.</td></tr>';
    }
    document.getElementById('paginationBox').innerHTML = '';
}

document.getElementById('searchInput').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') { searchPost(); }
});

window.onload = renderList;

