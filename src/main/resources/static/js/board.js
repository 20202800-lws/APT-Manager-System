/* =========================================
   board.js - 사용자 사용자 게시판 관련 스크립트
   ========================================= */

let currentBoard = 'free';
let currentPostIdx = null;

// 백엔드 연동을 위해 임시 데이터 초기화 (빈 배열)
let boards = {
    free: [],
    anon: [], 
    complaint: [], 
    kidsNotice: [], 
    kidsGallery: [], 
    kidsTalk: []
};

let currentImgs = [];
let currentPage = 1;
const itemsPerPage = 10;

// 오늘 날짜 구하는 헬퍼 함수
function getTodayString() {
    const d = new Date();
    return `${d.getFullYear()}.${String(d.getMonth() + 1).padStart(2, '0')}.${String(d.getDate()).padStart(2, '0')}`;
}

document.addEventListener("DOMContentLoaded", () => {
    renderList();
    
    // 검색창 엔터키 이벤트
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') searchPost();
        });
    }
});

function simulateClick(idx) {
    const sideItems = document.querySelectorAll('.side-item, .side-sub-item');
    if(sideItems[idx]) sideItems[idx].click();
}

function changeBoard(type, el) {
    currentBoard = type; 
    currentPage = 1;

    // 사이드바 활성화 처리
    document.querySelectorAll('.side-item, .side-sub-item').forEach(i => i.classList.remove('active'));
    el.classList.add('active');

    // 어린이집 서브메뉴 폴딩 처리
    const root = document.getElementById('kidsMenuRoot');
    if (el.classList.contains('side-sub-item')) {
        root.classList.add('is-active');
    } else {
        root.classList.remove('is-active');
    }

    // 타이틀 변경
    let titleText = el.innerText;
    if (titleText === '공지사항') titleText = '어린이집 공지사항';
    if (titleText === '활동갤러리') titleText = '어린이집 활동갤러리';
    document.getElementById('boardTitle').innerText = titleText;

    // 학부모 의견란은 상단 글쓰기 버튼 숨김 (아래 퀵 작성 박스 이용)
    document.getElementById('topWriteBtn').style.display = (type === 'kidsTalk') ? 'none' : 'block';
    
    showList();
}

function renderList() {
    const tableWrap = document.getElementById('tableWrapper');
    const gallWrap = document.getElementById('galleryWrapper');
    const talkWrap = document.getElementById('talkWrapper');
    
    // 초기화
    tableWrap.style.display = 'none'; 
    gallWrap.style.display = 'none'; 
    talkWrap.style.display = 'none';

    const sourceData = boards[currentBoard];
    const pagedData = sourceData.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    
    if (currentBoard === 'kidsGallery') {
        gallWrap.style.display = 'grid';
        gallWrap.innerHTML = pagedData.map(p => `
            <div style="cursor:pointer; border:1px solid #eee; border-radius:10px; overflow:hidden;" onclick="showDetail(${boards[currentBoard].indexOf(p)})">
                <img src="${p.imgs[0] || 'https://via.placeholder.com/400x300'}" style="width:100%; height:200px; object-fit:cover;">
            </div>
        `).join('') || '<p style="grid-column:1/4; text-align:center; padding:50px; color:#999;">등록된 사진이 없습니다.</p>';

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
                    ${p.isMine ? `
                        <div class="talk-btns">
                            <button class="btn-sub" onclick="openInlineEdit(${idx})">수정</button> 
                            <button class="btn-danger" onclick="deletePost(${idx})">삭제</button>
                        </div>` : ''}
                </div>
                <div class="edit-inline-area" id="talkEdit-${idx}" style="display:none;">
                    <textarea id="editInput-${idx}">${p.content}</textarea>
                    <div style="text-align:right; margin-top:10px;">
                        <button class="btn-sub" onclick="closeInlineEdit(${idx})">취소</button> 
                        <button class="btn-main" onclick="saveInlineEdit(${idx})">저장</button>
                    </div>
                </div>
            </div>`;
        }).join('') || '<p style="text-align:center; padding:50px; color:#999;">등록된 의견이 없습니다.</p>';

    } else {
        tableWrap.style.display = 'block';
        document.getElementById('boardBody').innerHTML = pagedData.map(p => `
            <tr onclick="showDetail(${boards[currentBoard].indexOf(p)})" style="cursor:pointer;">
                <td>${p.id}</td>
                <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
                <td>${currentBoard === 'anon' ? '익명' : p.author}</td>
                <td>${p.date}</td>
                <td>${p.hits}</td>
            </tr>
        `).join('') || '<tr><td colspan="5" style="text-align:center; padding:50px; color:#999;">등록된 게시글이 없습니다.</td></tr>';
    }

    renderPaginationUI(sourceData.length);
}

/* 톡(Talk) 인라인 수정 로직 */
function openInlineEdit(idx) { 
    document.getElementById(`talkView-${idx}`).style.display = 'none'; 
    document.getElementById(`talkEdit-${idx}`).style.display = 'block'; 
}

function closeInlineEdit(idx) { 
    document.getElementById(`talkView-${idx}`).style.display = 'flex'; 
    document.getElementById(`talkEdit-${idx}`).style.display = 'none'; 
}

function saveInlineEdit(idx) {
    const newVal = document.getElementById(`editInput-${idx}`).value;
    if (!newVal.trim()) return alert("내용을 입력해주세요.");
    boards.kidsTalk[idx].content = newVal; 
    renderList();
}

function saveQuickTalk() {
    const val = document.getElementById('quickInput').value;
    if (!val.trim()) return alert("의견을 입력해주세요.");
    
    boards.kidsTalk.unshift({ 
        id: boards.kidsTalk.length + 1, 
        title: "의견", 
        content: val, 
        author: "본인", 
        hits: 0, 
        isMine: true, 
        date: getTodayString(), 
        imgs: [], 
        comments: [] 
    });
    
    document.getElementById('quickInput').value = ''; 
    renderList();
}

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
    document.getElementById('formTitle').innerText = "새 게시글 작성";
}

/* 게시글 저장 (등록/수정) */
function savePost() {
    const t = document.getElementById('inputTitle').value.trim();
    const c = document.getElementById('inputContent').value.trim(); 
    const editIdx = document.getElementById('editIndex').value;
    
    if (!t && currentBoard !== 'kidsGallery') return alert("제목을 입력하세요.");
    if (!c) return alert("내용을 입력하세요.");
    
    if (editIdx !== "") { 
        boards[currentBoard][editIdx].content = c;
        boards[currentBoard][editIdx].title = t; 
        showDetail(editIdx); 
    } else { 
        boards[currentBoard].unshift({ 
            id: boards[currentBoard].length + 1, 
            title: t || "사진 갤러리", 
            content: c, 
            author: "본인", 
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
        boards[currentBoard].splice(targetIdx, 1); 
        if (currentBoard === 'kidsTalk') {
            renderList(); 
        } else {
            showList();
        }
    } 
}

/* 게시글 상세 보기 */
function showDetail(idx) {
    if (currentBoard === 'kidsTalk') return; // 의견란은 상세보기가 없음
    
    currentPostIdx = idx; 
    const post = boards[currentBoard][idx]; 
    post.hits++;
    
    document.getElementById('listView').style.display = 'none'; 
    document.getElementById('detailView').style.display = 'block';
    
    document.getElementById('viewTitle').innerText = post.title;
    // ★ 수정: JSP의 id("viewuser_id")와 일치시킴
    document.getElementById('viewuser_id').innerText = (currentBoard === 'anon' ? "익명" : post.author);
    document.getElementById('viewDate').innerText = post.date; 
    document.getElementById('viewHits').innerText = post.hits; 
    document.getElementById('viewContent').innerText = post.content;
    
    document.getElementById('viewImages').innerHTML = post.imgs.map(s => `
        <img src="${s}" style="max-width:100%; border-radius:10px; margin-top:10px;">
    `).join('');
    
    // 갤러리나 공지사항은 댓글 창 숨김
    document.getElementById('commentArea').style.display = (currentBoard === 'kidsGallery' || currentBoard === 'kidsNotice') ? 'none' : 'block';
    
    renderComments();
}

/* 댓글 렌더링 */
function renderComments() {
    const post = boards[currentBoard][currentPostIdx];
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
    
    boards[currentBoard][currentPostIdx].comments.push({ 
        author: "본인", 
        text: input.value.trim(), 
        date: getTodayString() 
    });
    
    input.value = ''; 
    renderComments();
}

function deleteComment(idx) { 
    if (confirm("댓글을 삭제할까요?")) { 
        boards[currentBoard][currentPostIdx].comments.splice(idx, 1); 
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
        tableWrap.style.display = 'none'; 
        talkWrap.style.display = 'none'; 
        gallWrap.style.display = 'grid';
        
        gallWrap.innerHTML = filtered.map(p => `
            <div style="cursor:pointer; border:1px solid #eee; border-radius:10px; overflow:hidden;" onclick="showDetail(${boards[currentBoard].indexOf(p)})">
                <img src="${p.imgs[0] || 'https://via.placeholder.com/400x300'}" style="width:100%; height:200px; object-fit:cover;">
            </div>
        `).join('') || '<p style="grid-column:1/4; text-align:center; padding:50px; color:#999;">검색 결과가 없습니다.</p>';
        
    } else if (currentBoard === 'kidsTalk') {
        tableWrap.style.display = 'none'; 
        gallWrap.style.display = 'none'; 
        talkWrap.style.display = 'block';
        
        talkList.innerHTML = filtered.map(p => {
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
        gallWrap.style.display = 'none'; 
        talkWrap.style.display = 'none'; 
        tableWrap.style.display = 'block';
        
        boardBody.innerHTML = filtered.map(p => `
            <tr onclick="showDetail(${boards[currentBoard].indexOf(p)})" style="cursor:pointer;">
                <td>${p.id}</td>
                <td class="title-cell" style="text-align:left; padding-left:15px;">${p.title}</td>
                <td>${currentBoard === 'anon' ? '익명' : p.author}</td>
                <td>${p.date}</td>
                <td>${p.hits}</td>
            </tr>
        `).join('') || '<tr><td colspan="5" style="padding:50px; color:#999; text-align:center;">검색 결과가 없습니다.</td></tr>';
    }
    
    // 검색 시 페이징 숨김 처리 (단순 프로토타입 용도)
    document.getElementById('paginationBox').innerHTML = '';
}