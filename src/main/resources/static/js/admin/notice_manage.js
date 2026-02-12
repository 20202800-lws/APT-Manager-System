/* =========================================
   1. Mock Data (ERD NOTICE Table 기준)
   ========================================= */
// DB 컬럼: notice_id, writer_id, title, content, views, reg_date
// [참고] isImportant, isVisible은 ERD에 없으나 UI 구현을 위해 임시 사용
let noticeList = [
    { 
        noticeId: 10, 
        writerId: 'admin01', 
        title: '[긴급] 102동 승강기 점검 안내', 
        content: '승강기 점검 내용...', 
        views: 152, 
        regDate: '2024-02-10 09:00',
        isImportant: true, // DB 컬럼 추가 필요
        isVisible: true    // DB 컬럼 추가 필요
    },
    { 
        noticeId: 9, 
        writerId: 'manager02', 
        title: '분리수거 규정 변경 안내', 
        content: '변경된 규정...', 
        views: 84, 
        regDate: '2024-02-08 14:30',
        isImportant: false,
        isVisible: true
    },
    { 
        noticeId: 8, 
        writerId: 'admin01', 
        title: '커뮤니티 센터 휴관 공지', 
        content: '내부 수리 중...', 
        views: 12, 
        regDate: '2024-02-05 11:20',
        isImportant: false,
        isVisible: false // 비공개
    }
];

/* =========================================
   2. 초기화 및 렌더링
   ========================================= */
document.addEventListener('DOMContentLoaded', () => {
    updateStats();
    renderTable(noticeList);
});

// 통계 갱신
function updateStats() {
    // ERD 매핑: noticeList.length -> count(*)
    document.getElementById('statTotal').innerHTML = `${noticeList.length}<span class="unit">건</span>`;
    
    // [주의] 아래 로직은 DB에 isImportant/isVisible 컬럼이 추가되어야 정상 작동함
    const importantCount = noticeList.filter(n => n.isImportant).length;
    const hiddenCount = noticeList.filter(n => !n.isVisible).length;

    document.getElementById('statImportant').innerHTML = `${importantCount}<span class="unit">건</span>`;
    document.getElementById('statHidden').innerHTML = `${hiddenCount}<span class="unit">건</span>`;
}

// 테이블 렌더링 (DTO: NoticeVO 기준)
function renderTable(data) {
    const tbody = document.getElementById('noticeTableBody');
    
    if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="padding:30px; color:#999;">등록된 공지사항이 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = data.map(item => {
        // [UI] 중요 공지 강조 스타일 (DB 컬럼 부재로 임시 로직)
        const titlePrefix = item.isImportant ? '<span style="color:var(--danger); font-weight:700;">[필독]</span> ' : '';
        const statusBadge = item.isVisible ? '<span class="badge badge-green">공개</span>' : '<span class="badge badge-gray">비공개</span>';
        
        return `
            <tr>
                <td>${item.noticeId}</td>
                <td style="text-align:left; cursor:pointer;" onclick="openModal('edit', ${item.noticeId})">
                    ${titlePrefix}${item.title}
                </td>
                <td>${item.writerId}</td>
                <td>${item.regDate}</td>
                <td>${item.views}</td>
                <td>${statusBadge}</td>
            </tr>
        `;
    }).join('');
}

/* =========================================
   3. 검색 및 필터 기능
   ========================================= */
function searchTable() {
    const filter = document.getElementById('searchFilter').value; // 'all', 'public', 'private'
    const keyword = document.getElementById('searchKeyword').value.toLowerCase();

    const filtered = noticeList.filter(item => {
        // 1. 상태 필터 (DB 컬럼 부재로 가상 필터링)
        let statusMatch = true;
        if (filter === 'public') statusMatch = item.isVisible === true;
        if (filter === 'private') statusMatch = item.isVisible === false;

        // 2. 검색어 필터 (대상: title)
        const keywordMatch = item.title.toLowerCase().includes(keyword);

        return statusMatch && keywordMatch;
    });

    renderTable(filtered);
}

/* =========================================
   4. 모달 및 저장 로직 (DTO 매핑)
   ========================================= */
const modal = document.getElementById('noticeModal');

function openModal(type, id = null) {
    modal.style.display = 'flex';
    
    if (type === 'create') {
        document.getElementById('modalTitle').innerText = '공지사항 등록';
        document.getElementById('noticeForm').reset();
        document.getElementById('modalNoticeId').value = ''; // Empty for insert
    } else {
        document.getElementById('modalTitle').innerText = '공지사항 수정';
        // 데이터 조회 (실제로는 AJAX fetch('/admin/notice/detail?noticeId=' + id))
        const item = noticeList.find(n => n.noticeId === id);
        if (item) {
            // ERD -> Form 매핑
            document.getElementById('modalNoticeId').value = item.noticeId;
            document.getElementById('inputTitle').value = item.title;
            document.getElementById('inputContent').value = item.content;
            
            // [주의] DB 컬럼 없음
            document.getElementById('checkImportant').checked = item.isImportant;
            document.getElementById('checkVisible').checked = item.isVisible;
        }
    }
}

function closeModal() {
    modal.style.display = 'none';
}

function saveNotice() {
    // 폼 데이터 수집 (DTO 매핑)
    const noticeId = document.getElementById('modalNoticeId').value;
    
    // NoticeVO 구조 생성
    const saveData = {
        noticeId: noticeId ? parseInt(noticeId) : null, // PK
        title: document.getElementById('inputTitle').value,
        content: document.getElementById('inputContent').value,
        writerId: 'admin01', // 세션에서 가져왔다고 가정
        
        // [주의] 이 두 필드는 ERD Notice 테이블에 저장할 공간이 없음. 
        // DB에 `is_important`, `is_visible` 컬럼 추가 권장.
        isImportant: document.getElementById('checkImportant').checked,
        isVisible: document.getElementById('checkVisible').checked
    };

    if(!saveData.title) {
        alert('제목을 입력해주세요.');
        return;
    }

    console.log('Sending to Server:', JSON.stringify(saveData));
    
    /* [AJAX 요청 예시]
       const url = saveData.noticeId ? '/admin/notice/update' : '/admin/notice/insert';
       fetch(url, {
           method: 'POST',
           headers: {'Content-Type': 'application/json'},
           body: JSON.stringify(saveData)
       })...
    */

    alert('저장되었습니다. (Mock)');
    closeModal();
    // 리스트 새로고침 (Mock Data 갱신 생략)
}