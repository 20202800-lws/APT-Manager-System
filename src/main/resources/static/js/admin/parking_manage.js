/* =========================================
   1. 데이터 (Mock Data - ERD Mapped)
   ========================================= */

const parkingList = [
    // [MOD] RESIDENT -> USERS(User Info) + VEHICLE(Car Info)
    // PK: carNumber (VEHICLE table has car_number as PK)
    { 
        category: 'RESIDENT', 
        carNumber: '12가 3456',     // [MOD] carNum -> carNumber
        dong: '101', 
        ho: '1502', 
        userName: '홍길동',         // [MOD] memberName -> userName (USERS.user_name)
        phone: '010-1234-5678',     // [MOD] phoneNumber -> phone (USERS.phone)
        regDate: '2023-01-15',      // [MOD] VEHICLE.reg_date
        approvalStatus: 1           // [MOD] USERS.approval_status (1: 승인, 0: 대기 가정)
    },
    { 
        category: 'RESIDENT', 
        carNumber: '34나 7890', 
        dong: '103', 
        ho: '805', 
        userName: '김영희', 
        phone: '010-9876-5432', 
        regDate: '2023-03-20', 
        approvalStatus: 1 
    },
    
    // [MOD] VISITOR -> VISIT_VEHICLE Joined with USERS (Inviter)
    // PK: visitId
    { 
        visitId: 4,                 // [MOD] id -> visitId
        category: 'VISITOR', 
        carNumber: '78라 5678',     // [MOD] carNum -> carNumber
        dong: '101',                // [MOD] targetDong -> dong (Inviter's Address)
        ho: '502',                  // [MOD] targetHo -> ho
        userName: '박지성',         // [MOD] visitorName -> userName (Inviter's Name per ERD constraint)
        visitPurpose: '물품 배송',  // [MOD] visit_purpose
        visitDate: '2024-02-04',    // [MOD] visit_date
        visitStatus: 'APPR'         // [MOD] status -> visitStatus
    },
    
    // [MOD] VIOLATION - ERD에 테이블 없음. UI 유지를 위해 기존 구조 사용하되 Naming 통일
    { 
        violationId: 6,             // [MOD] id -> violationId
        category: 'VIOLATION', 
        carNumber: '01바 9999',     // [MOD] carNum -> carNumber
        location: '소방차 전용구역', 
        reason: '주차금지구역', 
        owner: '미등록', 
        violationDate: '2024-02-03', 
        status: 'WARN' 
    },
];

let currentCategory = 'RESIDENT'; 
const TAB_WIDTH = 140;

document.addEventListener('DOMContentLoaded', () => {
    updateStats();
    filterTab('RESIDENT', 0);
});

/* =========================================
   2. 통계 및 탭 기능
   ========================================= */
function updateStats() {
    const counts = {
        resident: parkingList.filter(p => p.category === 'RESIDENT').length,
        visitor: parkingList.filter(p => p.category === 'VISITOR').length,
        violation: parkingList.filter(p => p.category === 'VIOLATION').length
    };

    document.getElementById('statResidentCount').innerHTML = `${counts.resident}<span class="unit">대</span>`;
    document.getElementById('statVisitorCount').innerHTML = `${counts.visitor}<span class="unit">대</span>`;
    document.getElementById('statViolationCount').innerHTML = `${counts.violation}<span class="unit">건</span>`;
}

function filterTab(category, index) {
    currentCategory = category;

    const highlighter = document.getElementById('tabHighlighter');
    if (highlighter) highlighter.style.transform = `translateX(${index * TAB_WIDTH}px)`;
    
    document.querySelectorAll('.tab-btn').forEach((btn, i) => {
        if(i === index) btn.classList.add('active');
        else btn.classList.remove('active');
    });

    const titles = { 'RESIDENT': '입주민 차량 목록', 'VISITOR': '방문 차량 목록', 'VIOLATION': '단속/위반 차량 목록' };
    document.getElementById('tableTitle').innerText = titles[category] || '차량 목록';

    const btnResident = document.getElementById('btnRegResident');
    const btnVisitor = document.getElementById('btnRegVisitor');

    btnResident.style.display = 'none';
    btnVisitor.style.display = 'none';

    if(category === 'RESIDENT') {
        btnResident.style.display = 'inline-block';
    } else if (category === 'VISITOR') {
        btnVisitor.style.display = 'inline-block';
    }

    searchTable();
}

/* =========================================
   3. 테이블 렌더링
   ========================================= */
function searchTable() {
    const keyword = document.getElementById('searchInput').value.toLowerCase();
    
    const filtered = parkingList.filter(item => {
        if (item.category !== currentCategory) return false;
        
        if (keyword) {
            // [MOD] 변수명 변경 반영
            let unitInfo = item.dong + item.ho; // Resident & Visitor 둘 다 dong/ho 사용
            
            return item.carNumber.includes(keyword) || 
                   unitInfo.includes(keyword) || 
                   (item.userName && item.userName.includes(keyword)); 
                   // Visitor의 경우 userName은 초대자 이름
        }
        return true;
    });

    renderTable(filtered);
}

function renderTable(data) {
    const thead = document.getElementById('dynamicTableHead');
    const tbody = document.getElementById('parkingTableBody');

    let headerHtml = '';
    if (currentCategory === 'RESIDENT') {
        headerHtml = `<tr><th>구분</th><th>동/호수</th><th>차량번호</th><th>소유주</th><th>연락처</th><th>승인여부</th><th>관리</th></tr>`;
    } else if (currentCategory === 'VISITOR') {
        headerHtml = `<tr><th>구분</th><th>방문세대(초대자)</th><th>차량번호</th><th>방문목적</th><th>방문일자</th><th>예약상태</th><th>관리</th></tr>`;
    } else {
        headerHtml = `<tr><th>구분</th><th>위반장소</th><th>차량번호</th><th>참고사항</th><th>적발일시</th><th>조치상태</th><th>관리</th></tr>`;
    }
    thead.innerHTML = headerHtml;

    if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="padding:30px; color:#999;">데이터가 없습니다.</td></tr>';
        return;
    }

    tbody.innerHTML = data.map(item => {
        let badgeClass = 'badge-blue';
        let typeName = '입주민';
        
        if(item.category === 'VISITOR') { badgeClass = 'badge-green'; typeName = '방문객'; }
        else if(item.category === 'VIOLATION') { badgeClass = 'badge-red'; typeName = '위반'; }

        // [MOD] Status Badge Mapping (ERD 값 기반)
        let statusBadge = '';
        let statusValue = ''; // 표시용 값

        if (item.category === 'RESIDENT') {
             // USERS.approval_status (1=승인)
             statusValue = item.approvalStatus === 1 ? '정상' : '승인대기';
             statusBadge = item.approvalStatus === 1 
                 ? `<span class="text-success" style="font-weight:600;">정상</span>` 
                 : `<span class="badge badge-secondary">대기</span>`;
        } else if (item.category === 'VISITOR') {
            // VISIT_VEHICLE.visit_status
            statusValue = item.visitStatus;
            switch(item.visitStatus) {
                case 'APPR': statusBadge = `<span class="badge badge-success">승인완료</span>`; break;
                case 'WAIT': statusBadge = `<span class="badge badge-secondary">대기중</span>`; break;
                default: statusBadge = `<span class="badge badge-secondary">${item.visitStatus}</span>`;
            }
        } else {
            // VIOLATION (Mock)
            statusValue = item.status;
            statusBadge = item.status === 'WARN' 
                ? `<span class="badge badge-red">경고</span>` 
                : `<span class="badge badge-secondary">${item.status}</span>`;
        }

        // [MOD] Column Data mapping based on ERD
        let col2 = '', col4 = '', col5 = '';
        // 식별자 선택 (Resident는 PK가 차번호, 나머지는 ID 존재)
        let uniqueId = item.visitId || item.violationId || item.carNumber; 

        if(item.category === 'RESIDENT') {
            col2 = `${item.dong}동 ${item.ho}호`;
            col4 = item.userName; // USERS.user_name
            col5 = item.phone;    // USERS.phone
        } else if(item.category === 'VISITOR') {
            col2 = `${item.dong}동 ${item.ho}호`; // Inviter info
            col4 = item.visitPurpose; // VISIT_VEHICLE.visit_purpose
            col5 = item.visitDate;    // VISIT_VEHICLE.visit_date
        } else {
            col2 = item.location;      
            col4 = item.reason;       
            col5 = item.violationDate; 
        }

        return `
            <tr>
                <td><span class="badge ${badgeClass}">${typeName}</span></td>
                <td>${col2}</td>
                <td><span class="car-num-badge">${item.carNumber}</span></td>
                <td>${col4}</td>
                <td style="color:#666;">${col5 || '-'}</td>
                <td>${statusBadge}</td>
                <td>
                    <button class="btn btn-secondary btn-xs" onclick="openModal('detail', '${uniqueId}')">
                        <i class="fa-solid fa-list"></i> 상세
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

/* =========================================
   4. 모달 통합 제어
   ========================================= */
const modalMap = {
    'residentReg': document.getElementById('residentRegModal'),
    'visitorReg': document.getElementById('visitorRegModal'),
    'detail': document.getElementById('detailModal')
};

function openModal(type, uniqueId = null) {
    const modal = modalMap[type];
    if(!modal) return;

    // 상세 조회 데이터 바인딩
    if(type === 'detail' && uniqueId !== null) {
        // [MOD] ID 검색 로직 수정
        const item = parkingList.find(d => 
            d.visitId == uniqueId || 
            d.violationId == uniqueId || 
            d.carNumber === uniqueId
        );

        if(item) {
            // Common Fields
            document.getElementById('detailCarNumber').innerText = item.carNumber;
            document.getElementById('detailCategory').innerText = 
                item.category === 'RESIDENT' ? '입주민 차량' : (item.category === 'VISITOR' ? '방문 차량' : '위반 차량');
            
            // Status Mapping
            let displayState = '';
            if(item.category === 'RESIDENT') displayState = item.approvalStatus === 1 ? '정상' : '대기';
            else if(item.category === 'VISITOR') displayState = item.visitStatus;
            else displayState = item.status;

            document.getElementById('detailState').innerText = displayState;

            // Conditional Fields
            let infoText = '';
            let dateText = '';

            if(item.category === 'RESIDENT') {
                // [MOD] 변수명 매핑
                infoText = `${item.dong}동 ${item.ho}호 / ${item.userName} (${item.phone})`;
                dateText = item.regDate;
            } else if(item.category === 'VISITOR') {
                infoText = `초대: ${item.dong}동 ${item.ho}호 (${item.userName}) / 목적: ${item.visitPurpose}`;
                dateText = item.visitDate;
            } else {
                infoText = `장소: ${item.location} / 사유: ${item.reason}`;
                dateText = item.violationDate;
            }

            document.getElementById('detailInfo').innerText = infoText;
            document.getElementById('detailDate').innerText = dateText;
        }
    }

    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('show'), 10);
}

function closeModal(type) {
    const modal = modalMap[type];
    if(!modal) return;

    modal.classList.remove('show');
    setTimeout(() => {
        modal.style.display = 'none';
    }, 300);
}

window.onclick = function(event) {
    if (event.target.classList.contains('modal-overlay')) {
        Object.values(modalMap).forEach(m => {
            if(m.style.display === 'flex') {
                m.classList.remove('show');
                setTimeout(() => m.style.display = 'none', 300);
            }
        });
    }
}