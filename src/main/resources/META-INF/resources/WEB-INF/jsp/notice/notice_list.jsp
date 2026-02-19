<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>입주민 공지사항 | APARTNERS</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <style>
        :root { --primary-color: #1a0b2e; --accent-color: #d4af37; --bg-light: #f9f9fb; --text-main: #333; }
        html, body { margin: 0; padding: 0; font-family: 'Pretendard', sans-serif; background: #fff; color: var(--text-main); }
        
        .container { max-width: 1000px; margin: 0 auto; padding: 60px 20px; box-sizing: border-box; }

        /* --- 헤더 --- */
        .header { border-bottom: 2px solid var(--primary-color); padding-bottom: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: flex-end; }
        .header h2 { margin: 0; font-size: 28px; letter-spacing: -1px; }

        /* --- 게시판 테이블 --- */
        .board-table { width: 100%; border-collapse: collapse; }
        .board-table th { padding: 18px 10px; background: #fafafa; border-bottom: 1px solid #ddd; font-size: 15px; color: #666; }
        .board-table td { padding: 20px 10px; border-bottom: 1px solid #eee; text-align: center; font-size: 16px; }
        
        .title-cell { text-align: left !important; cursor: pointer; transition: 0.2s; }
        .title-cell:hover { color: var(--primary-color); text-decoration: underline; }
        
        /* 중요 공지 스타일 */
        .pinned-row { background: #fffcf5; }
        .pinned-row td { border-bottom: 1px solid #f2e6c4; }
        .badge-pinned { background: #ff4757; color: #fff; padding: 3px 10px; border-radius: 4px; font-size: 12px; font-weight: 800; margin-right: 10px; }
        .pinned-text { font-weight: 700; color: #000; }

        /* --- 상세보기 --- */
        .content-box { background: var(--bg-light); padding: 40px; border-radius: 16px; border: 1px solid #eef0f2; }
        .view-header { border-bottom: 1px solid #ddd; padding-bottom: 25px; margin-bottom: 30px; }
        .view-header h3 { margin: 0 0 15px 0; font-size: 24px; line-height: 1.4; }
        .view-meta { font-size: 14px; color: #888; }
        .view-content { line-height: 1.8; font-size: 17px; min-height: 200px; white-space: pre-wrap; color: #444; }
        .detail-img { max-width: 100%; border-radius: 12px; margin-top: 20px; border: 1px solid #ddd; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

        /* --- 검색창 --- */
        .search-area { margin-top: 40px; display: flex; justify-content: center; gap: 8px; }
        .search-area input { width: 300px; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; outline: none; font-size: 14px; }
        .search-area input:focus { border-color: var(--primary-color); }

        /* --- 버튼 --- */
        .btn-main { background: var(--primary-color); color: #fff; border: none; padding: 12px 30px; border-radius: 8px; cursor: pointer; font-weight: 600; font-size: 15px; }
        .btn-sub { background: #fff; color: #555; border: 1px solid #ddd; padding: 12px 25px; border-radius: 8px; cursor: pointer; font-weight: 600; }
        
        /* 페이지네이션 */
        .pagination { display: flex; justify-content: center; gap: 5px; margin-top: 30px; }
        .page-btn { padding: 8px 14px; border: 1px solid #eee; background: #fff; cursor: pointer; border-radius: 4px; }
        .page-btn.active { background: var(--primary-color); color: #fff; border-color: var(--primary-color); }
    </style>
</head>
<body>

<div class="container">
    <div id="listView">
        <div class="header">
            <h2>📢 단지 공지사항</h2>
            <span style="color:#888; font-size:14px;">우리 단지의 소식을 전해드립니다.</span>
        </div>
        
        <table class="board-table">
            <thead>
                <tr>
                    <th width="100">번호</th>
                    <th>제목</th>
                    <th width="150">작성일</th>
                </tr>
            </thead>
            <tbody id="boardBody">
                </tbody>
        </table>

        <div class="search-area">
            <input type="text" id="searchInput" placeholder="공지 제목을 입력하세요..." onkeypress="if(event.key==='Enter') searchNotice()">
            <button class="btn-main" onclick="searchNotice()">검색</button>
        </div>
    </div>

    <div id="detailView" style="display:none;">
        <div class="header">
            <h2>공지사항 확인</h2>
        </div>
        <div class="content-box">
            <div class="view-header">
                <h3 id="viewTitle"></h3>
                <div class="view-meta">
                    관리사무소 | <span id="viewDate"></span>
                </div>
            </div>
            <div id="viewContent" class="view-content"></div>
            <div id="viewImageArea"></div>

            <div style="text-align:center; margin-top:40px; padding-top:30px; border-top:1px solid #eee;">
                <button class="btn-sub" onclick="showList()">목록으로 돌아가기</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 샘플 공지 데이터
    let notices = [
        { id: 4, title: "단지 내 지하주차장 바닥 도색 작업 안내", content: "지하 1층 주차장 도색 작업이 예정되어 있습니다.\n작업 일시: 2월 1일 ~ 2월 3일\n해당 구역의 차량은 지상 주차장으로 이동 부탁드립니다.", date: "2026-01-29", isPinned: true, imgs: [] },
        { id: 3, title: "설 연휴 쓰레기 배출 시간 조정 안내", content: "설 연휴 기간 동안은 쓰레기 수거가 중단되오니\n연휴 마지막 날 저녁부터 배출해 주시기 바랍니다.", date: "2026-01-28", isPinned: true, imgs: [] },
        { id: 2, title: "단지 커뮤니티 센터 헬스장 기구 교체", content: "노후된 러닝머신 3대를 최신형으로 교체 완료하였습니다.", date: "2026-01-20", isPinned: false, imgs: [] },
        { id: 1, title: "동절기 화재 예방 수칙 준수 안내", content: "개인 전열기구 사용 시 화재 예방에 각별히 유의해 주세요.", date: "2026-01-15", isPinned: false, imgs: [] }
    ];

    function renderList(data = notices) {
        const tbody = document.getElementById('boardBody');
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
        const keyword = document.getElementById('searchInput').value.trim().toLowerCase();
        const filtered = notices.filter(n => n.title.toLowerCase().includes(keyword));
        renderList(filtered);
    }

    function showDetail(id) {
        const post = notices.find(n => n.id === id);
        if(!post) return;

        document.getElementById('listView').style.display = 'none';
        document.getElementById('detailView').style.display = 'block';
        
        document.getElementById('viewTitle').innerText = post.title;
        document.getElementById('viewDate').innerText = post.date;
        document.getElementById('viewContent').innerText = post.content;
        
        // 이미지 영역 (샘플 데이터에는 없지만 구조는 유지)
        const imgArea = document.getElementById('viewImageArea');
        imgArea.innerHTML = post.imgs.map(src => `<img src="${src}" class="detail-img">`).join('');
        
        window.scrollTo(0,0);
    }

    function showList() {
        document.getElementById('listView').style.display = 'block';
        document.getElementById('detailView').style.display = 'none';
        document.getElementById('searchInput').value = '';
        renderList();
    }

    window.onload = () => renderList();
</script>
</body>
</html>