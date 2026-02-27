/* =========================================
   notice.js - 공지사항 로직
========================================= */

// 샘플 공지 데이터
let notices = [
    { id: 4, title: "단지 내 지하주차장 바닥 도색 작업 안내", content: "지하 1층 주차장 도색 작업이 예정되어 있습니다.\n작업 일시: 2월 1일 ~ 2월 3일\n해당 구역의 차량은 지상 주차장으로 이동 부탁드립니다.", date: "2026-01-29", isPinned: true, imgs: [] },
    { id: 3, title: "설 연휴 쓰레기 배출 시간 조정 안내", content: "설 연휴 기간 동안은 쓰레기 수거가 중단되오니\n연휴 마지막 날 저녁부터 배출해 주시기 바랍니다.", date: "2026-01-28", isPinned: true, imgs: [] },
    { id: 2, title: "단지 커뮤니티 센터 헬스장 기구 교체", content: "노후된 러닝머신 3대를 최신형으로 교체 완료하였습니다.", date: "2026-01-20", isPinned: false, imgs: [] },
    { id: 1, title: "동절기 화재 예방 수칙 준수 안내", content: "개인 전열기구 사용 시 화재 예방에 각별히 유의해 주세요.", date: "2026-01-15", isPinned: false, imgs: [] }
];

function renderList(data = notices) {
    const tbody = document.getElementById('boardBody');
    if (!tbody) return;
    
    tbody.innerHTML = '';

    if(data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="3" style="padding:60px; color:#999;">검색 결과가 없습니다.</td></tr>';
        return;
    }

    // 중요 공지(isPinned)를 먼저 정렬
    const sortedData = [...data].sort((a, b) => b.isPinned - a.isPinned);

    sortedData.forEach((post) => {
        const tr = document.createElement('tr');
        if(post.isPinned) tr.className = 'pinned-row';
        
        tr.innerHTML = `
            <td>${post.isPinned ? '<span class="badge-pinned">중요</span>' : post.id}</td>
            <td class="title-cell ${post.isPinned ? 'pinned-text' : ''}" onclick="showDetail(${post.id})">
                ${post.title}
            </td>
            <td style="color:#888;">${post.date}</td>
        `;
        tbody.appendChild(tr);
    });
}

function searchNotice() {
    const keyword = document.getElementById('searchInput').value.trim();
    if(keyword) {
        location.href = '/notice/notice_list?keyword=' + encodeURIComponent(keyword);
    }
}
/*function searchNotice() {
    const keyword = document.getElementById('searchInput').value.trim().toLowerCase();
    const filtered = notices.filter(n => n.title.toLowerCase().includes(keyword));
    renderList(filtered);
}*/

function showDetail(id) {
    const post = notices.find(n => n.id === id);
    if(!post) return;

    document.getElementById('listView').style.display = 'none';
    document.getElementById('detailView').style.display = 'block';
    
    document.getElementById('viewTitle').innerText = post.title;
    document.getElementById('viewDate').innerText = post.date;
    document.getElementById('viewContent').innerText = post.content;
    
    // 이미지 영역
    const imgArea = document.getElementById('viewImageArea');
    if (imgArea) {
        imgArea.innerHTML = post.imgs.map(src => `<img src="${src}" class="detail-img">`).join('');
    }
    
    window.scrollTo(0,0);
}

function showList() {
    document.getElementById('listView').style.display = 'block';
    document.getElementById('detailView').style.display = 'none';
    document.getElementById('searchInput').value = '';
    renderList();
}

window.onload = () => renderList();