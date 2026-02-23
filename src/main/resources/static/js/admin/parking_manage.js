/* =========================================
   parking_manage.js
   관리자 - 주차 차량 관리 (페이징 및 DB 데이터 연동, 위반 차량 등록 연동 완료)
   ========================================= */

const parkingManager = (function() {

    let parkingList = window.globalParkingList || [];
    let currentFilteredList = []; 

    let currentCategory = 'RESIDENT'; 
    const TAB_WIDTH = 140;

    let currentPage = 1;
    const rowsPerPage = 10; 

    const modalMap = {
        'residentReg': document.getElementById('residentRegModal'),
        'visitorReg': document.getElementById('visitorRegModal'),
        'violationReg': document.getElementById('violationRegModal'), 
        'detail': document.getElementById('detailModal')
    };

    document.addEventListener('DOMContentLoaded', () => {
        updateStats();
        filterTab('RESIDENT', 0);

        // ★ 수정: 모달 바깥 클릭 시 닫기 (클래스 찌꺼기 제거 및 단순화)
        window.onclick = function(event) {
            if (event.target.classList.contains('modal-overlay')) {
                Object.keys(modalMap).forEach(key => {
                    closeModal(key);
                });
            }
        }
    });

    function updateStats() {
        const counts = {
            resident: parkingList.filter(p => p.category === 'RESIDENT').length,
            visitor: parkingList.filter(p => p.category === 'VISITOR').length,
            violation: parkingList.filter(p => p.category === 'VIOLATION').length
        };

        const resEl = document.getElementById('statResidentCount');
        const visEl = document.getElementById('statVisitorCount');
        const vioEl = document.getElementById('statViolationCount');

        if(resEl) resEl.innerHTML = `${counts.resident}<span class="unit">대</span>`;
        if(visEl) visEl.innerHTML = `${counts.visitor}<span class="unit">대</span>`;
        if(vioEl) vioEl.innerHTML = `${counts.violation}<span class="unit">건</span>`;
    }

    // 탭 필터링 및 버튼 토글 로직
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
        const btnViolation = document.getElementById('btnRegViolation'); 

        if(btnResident && btnVisitor && btnViolation) {
            btnResident.style.display = 'none';
            btnVisitor.style.display = 'none';
            btnViolation.style.display = 'none'; 

            if(category === 'RESIDENT') {
                btnResident.style.display = 'inline-block';
            } else if (category === 'VISITOR') {
                btnVisitor.style.display = 'inline-block';
            } else if (category === 'VIOLATION') { 
                btnViolation.style.display = 'inline-block';
            }
        }

        searchTable(true);
    }

    function searchTable(isResetPage = false) {
        if (isResetPage) currentPage = 1;

        const searchInput = document.getElementById('searchInput');
        const keyword = searchInput ? searchInput.value.toLowerCase().trim() : '';
        
        currentFilteredList = parkingList.filter(item => {
            if (item.category !== currentCategory) return false;
            
            if (keyword) {
                let unitInfo = String(item.dong || '') + String(item.ho || '');
                return String(item.carNumber).includes(keyword) || 
                       unitInfo.includes(keyword) || 
                       (item.userName && item.userName.includes(keyword)); 
            }
            return true;
        });

        renderTable();
    }

    function renderTable() {
        const thead = document.getElementById('dynamicTableHead');
        const tbody = document.getElementById('parkingTableBody');

        if (!thead || !tbody) return;

        let headerHtml = '';
        if (currentCategory === 'RESIDENT') {
            headerHtml = `<tr><th>구분</th><th>동/호수</th><th>차량번호</th><th>소유주</th><th>연락처</th><th>승인여부</th><th>관리</th></tr>`;
        } else if (currentCategory === 'VISITOR') {
            headerHtml = `<tr><th>구분</th><th>방문세대(초대자)</th><th>차량번호</th><th>방문목적</th><th>방문일자</th><th>예약상태</th><th>관리</th></tr>`;
        } else {
            headerHtml = `<tr><th>구분</th><th>위반장소</th><th>차량번호</th><th>참고사항</th><th>적발일시</th><th>조치상태</th><th>관리</th></tr>`;
        }
        thead.innerHTML = headerHtml;

        if (currentFilteredList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="padding:40px; color:#999; text-align:center;">조건에 맞는 차량 정보가 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        const totalPages = Math.ceil(currentFilteredList.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = currentFilteredList.slice(startIndex, startIndex + rowsPerPage);

        tbody.innerHTML = paginatedData.map(item => {
            let badgeClass = 'badge-blue';
            let typeName = '입주민';
            
            if(item.category === 'VISITOR') { badgeClass = 'badge-green'; typeName = '방문객'; }
            else if(item.category === 'VIOLATION') { badgeClass = 'badge-red'; typeName = '위반'; }

            let statusBadge = '';
            
            if (item.category === 'RESIDENT') {
                 statusBadge = item.approvalStatus === 1 
                     ? `<span class="text-success" style="font-weight:600;">정상</span>` 
                     : `<span class="badge badge-secondary">대기</span>`;
            } else if (item.category === 'VISITOR') {
                switch(item.visitStatus) {
                    case 'APPR': statusBadge = `<span class="badge badge-success">승인완료</span>`; break;
                    case 'WAIT': statusBadge = `<span class="badge badge-secondary">대기중</span>`; break;
                    default: statusBadge = `<span class="badge badge-secondary">${item.visitStatus || '-'}</span>`;
                }
            } else {
                statusBadge = item.status === 'WARN' 
                    ? `<span class="badge badge-red">경고</span>` 
                    : `<span class="badge badge-secondary">${item.status || '-'}</span>`;
            }

            let col2 = '', col4 = '', col5 = '';
            let uniqueId = item.visitId || item.violationId || item.carNumber; 

            if(item.category === 'RESIDENT') {
                col2 = `${item.dong}동 ${item.ho}호`;
                col4 = item.userName; 
                col5 = item.phone;    
            } else if(item.category === 'VISITOR') {
                col2 = `${item.dong}동 ${item.ho}호`; 
                col4 = item.visitPurpose; 
                col5 = item.visitDate;    
            } else {
                col2 = item.location;      
                col4 = item.reason;       
                col5 = item.violationDate; 
            }

            return `
                <tr>
                    <td><span class="badge ${badgeClass}">${typeName}</span></td>
                    <td style="font-weight:500;">${col2}</td>
                    <td><span class="car-num-badge">${item.carNumber}</span></td>
                    <td>${col4}</td>
                    <td style="color:#666;">${col5 || '-'}</td>
                    <td>${statusBadge}</td>
                    <td>
                        <button class="btn btn-secondary btn-xs" onclick="parkingManager.openModal('detail', '${uniqueId}')">
                            <i class="fa-solid fa-list"></i> 상세
                        </button>
                    </td>
                </tr>
            `;
        }).join('');

        renderPagination(currentFilteredList.length);
    }

    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        // ★ 수정: 데이터가 0개일 때만 비우고 1페이지는 무조건 표시
        if (totalCount === 0) { 
            container.innerHTML = ''; 
            return; 
        }

        const totalPages = Math.ceil(totalCount / rowsPerPage);

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="parkingManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="parkingManager.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="parkingManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    function goToPage(page) {
        currentPage = page;
        renderTable();
    }

    /* =========================================
       모달 제어
       ========================================= */
    function openModal(type, uniqueId = null) {
        const modal = modalMap[type];
        if(!modal) return;

        // 입력 폼 초기화
        if (['residentReg', 'visitorReg', 'violationReg'].includes(type)) {
            const inputs = modal.querySelectorAll('input');
            inputs.forEach(input => input.value = '');
        }

        // 상세 정보 세팅
        if(type === 'detail' && uniqueId !== null) {
            const item = parkingList.find(d => 
                String(d.visitId) === String(uniqueId) || 
                String(d.violationId) === String(uniqueId) || 
                String(d.carNumber) === String(uniqueId)
            );

            if(item) {
                document.getElementById('detailCarNumber').innerText = item.carNumber;
                document.getElementById('detailCategory').innerText = 
                    item.category === 'RESIDENT' ? '입주민 차량' : (item.category === 'VISITOR' ? '방문 차량' : '위반 차량');
                
                let displayState = '';
                if(item.category === 'RESIDENT') displayState = item.approvalStatus === 1 ? '정상' : '대기';
                else if(item.category === 'VISITOR') displayState = item.visitStatus;
                else displayState = item.status;

                document.getElementById('detailState').innerText = displayState;

                let infoText = '';
                let dateText = '';

                if(item.category === 'RESIDENT') {
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

        // ★ 수정: setTimeout 제거하고 즉시 flex
        modal.style.display = 'flex';
    }

    function closeModal(type) {
        const modal = modalMap[type];
        if(!modal) return;
        
        // ★ 수정: setTimeout 제거하고 즉시 none 처리
        modal.style.display = 'none';
    }

    return {
        filterTab,
        searchTable,
        goToPage,
        openModal,
        closeModal
    };

})();