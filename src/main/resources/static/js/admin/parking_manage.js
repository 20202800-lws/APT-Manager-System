/* =========================================
   parking_manage.js
   관리자 - 주차 차량 관리 (JSP EL 충돌 완벽 방어 버전)
   ========================================= */

const parkingManager = (function() {

    let parkingList = window.globalParkingList || [];
    let currentFilteredList = []; 

    let currentCategory = 'RESIDENT'; 

    let currentPage = 1;
    const rowsPerPage = 10; 
    let currentSelectedUniqueId = null;

    const modalMap = {
        'detail': document.getElementById('detailModal')
    };

    document.addEventListener('DOMContentLoaded', () => {
        updateStats();
        filterTab('RESIDENT');

        window.onclick = function(event) {
            if (event.target.classList.contains('modal-overlay')) {
                closeModal('detail');
            }
        }
    });

    function updateStats() {
        const todayStr = new Date().toISOString().split('T')[0];

        const counts = {
            resident: parkingList.filter(p => p.category === 'RESIDENT').length,
            // ★ 수정: 카테고리가 방문이면서, 대기중(WAIT)이고, 기간이 만료되지 않은(오늘 이후) 차량만 카운트!
            visitor: parkingList.filter(p => p.category === 'VISITOR' && p.visitStatus === 'WAIT' && p.visitDate >= todayStr).length,
            violation: parkingList.filter(p => p.category === 'VIOLATION').length
        };

        const resEl = document.getElementById('statResidentCount');
        const visEl = document.getElementById('statVisitorCount');
        const vioEl = document.getElementById('statViolationCount');

        if(resEl) resEl.innerHTML = counts.resident + '<span class="unit">대</span>';
        if(visEl) visEl.innerHTML = counts.visitor + '<span class="unit">대</span>';
        if(vioEl) vioEl.innerHTML = counts.violation + '<span class="unit">건</span>';
    }

    // ★ 탭 애니메이션 로직 교체 (admin.css 스타일에 맞춤)
    function filterTab(category) {
        currentCategory = category;

        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        const activeTab = document.getElementById('tab-' + category);
        if(activeTab) activeTab.classList.add('active');

        const titles = { 'RESIDENT': '입주민 차량 목록', 'VISITOR': '방문 차량 목록', 'VIOLATION': '단속/위반 차량 목록' };
        document.getElementById('tableTitle').innerText = titles[category] || '차량 목록';

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
            headerHtml = '<tr><th>구분</th><th>동/호수</th><th>차량번호</th><th>소유주</th><th>연락처</th><th>승인여부</th><th>관리</th></tr>';
        } else if (currentCategory === 'VISITOR') {
            headerHtml = '<tr><th>구분</th><th>방문세대(초대자)</th><th>차량번호</th><th>방문목적</th><th>방문일자</th><th>예약상태</th><th>관리</th></tr>';
        } else {
            headerHtml = '<tr><th>구분</th><th>위반장소</th><th>차량번호</th><th>참고사항</th><th>적발일시</th><th>조치상태</th><th>관리</th></tr>';
        }
        thead.innerHTML = headerHtml;

        if (currentFilteredList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="padding:40px; color:#999; text-align:center; font-size:1.1rem;">조건에 맞는 차량 정보가 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        const totalPages = Math.ceil(currentFilteredList.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = currentFilteredList.slice(startIndex, startIndex + rowsPerPage);

        const todayStr = new Date().toISOString().split('T')[0];

        let bodyHtml = '';
        paginatedData.forEach(item => {
            let badgeClass = 'badge-blue';
            let typeName = '입주민';
            let isExpired = false;
            let trStyle = '';
            
            if(item.category === 'VISITOR') { 
                badgeClass = 'badge-green'; 
                typeName = '방문객'; 
                if (item.visitDate && item.visitDate < todayStr) {
                    isExpired = true;
                    trStyle = 'opacity: 0.5; background-color: #f8fafc;'; 
                }
            }
            else if(item.category === 'VIOLATION') { 
                badgeClass = 'badge-red'; 
                typeName = '위반'; 
            }

            let statusBadge = '';
            if (item.category === 'RESIDENT') {
                 statusBadge = item.approvalStatus === 1 
                     ? '<span class="text-success" style="font-weight:600;">승인완료</span>' 
                     : '<span class="badge badge-warning" style="background:#fff3cd; color:#f57c00;">승인대기</span>';
            } else if (item.category === 'VISITOR') {
                if (isExpired) {
                    statusBadge = '<span class="badge badge-secondary" style="text-decoration:line-through;">기간만료</span>';
                } else if (item.visitStatus === 'APPR') {
                    statusBadge = '<span class="badge badge-success">승인완료</span>'; 
                } else {
                    statusBadge = '<span class="badge badge-warning" style="background:#fff3cd; color:#f57c00;">승인대기</span>';
                }
            } else {
                statusBadge = item.status === 'WARN' 
                    ? '<span class="badge badge-red">경고조치</span>' 
                    : '<span class="badge badge-secondary">' + (item.status || '-') + '</span>';
            }

            let col2 = '', col4 = '', col5 = '';
            let uniqueId = item.visitId || item.violationId || item.carNumber; 

            if(item.category === 'RESIDENT') {
                col2 = item.dong + '동 ' + item.ho + '호';
                col4 = item.userName; 
                col5 = item.phone;    
            } else if(item.category === 'VISITOR') {
                col2 = item.dong + '동 ' + item.ho + '호'; 
                col4 = item.visitPurpose; 
                col5 = item.visitDate;    
            } else {
                col2 = item.location;      
                col4 = item.reason;       
                col5 = item.violationDate; 
            }

            bodyHtml += '<tr style="' + trStyle + '">' +
                '<td><span class="badge ' + badgeClass + '">' + typeName + '</span></td>' +
                '<td style="font-weight:500;">' + col2 + '</td>' +
                '<td><span class="car-num-badge">' + item.carNumber + '</span></td>' +
                '<td>' + col4 + '</td>' +
                '<td style="color:#666;">' + (col5 || '-') + '</td>' +
                '<td>' + statusBadge + '</td>' +
                '<td>' +
                    '<button class="btn btn-secondary btn-xs" onclick="parkingManager.openModal(\'detail\', \'' + uniqueId + '\')">' +
                        '<i class="fa-solid fa-list"></i> 상세' +
                    '</button>' +
                '</td>' +
            '</tr>';
        });
        tbody.innerHTML = bodyHtml;

        renderPagination(currentFilteredList.length);
    }

    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        if (totalCount === 0) { 
            container.innerHTML = ''; 
            return; 
        }

        const totalPages = Math.ceil(totalCount / rowsPerPage);

        let html = '<button class="btn btn-secondary btn-xs" ';
        if (currentPage === 1) html += 'disabled';
        else html += 'onclick="parkingManager.goToPage(' + (currentPage - 1) + ')"';
        html += '>&lt;</button> ';

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += '<button class="btn ' + activeClass + ' btn-xs" onclick="parkingManager.goToPage(' + i + ')">' + i + '</button> ';
        }

        html += '<button class="btn btn-secondary btn-xs" ';
        if (currentPage === totalPages) html += 'disabled';
        else html += 'onclick="parkingManager.goToPage(' + (currentPage + 1) + ')"';
        html += '>&gt;</button>';
        
        container.innerHTML = html;
    }

    function goToPage(page) {
        currentPage = page;
        renderTable();
    }

    function openModal(type, uniqueId = null) {
        const modal = modalMap[type];
        if(!modal) return;

        if(type === 'detail' && uniqueId !== null) {
            currentSelectedUniqueId = uniqueId; 
            
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
                let showApproveBtn = false; 
                const btnApprove = document.getElementById('btnModalApprove');

                if(item.category === 'RESIDENT') {
                    if (item.approvalStatus === 1) {
                        displayState = '승인 완료';
                    } else {
                        displayState = '승인 대기 중';
                        showApproveBtn = true; 
                    }
                } else if(item.category === 'VISITOR') {
                    if (item.visitStatus === 'APPR') {
                        displayState = '방문 승인 완료';
                    } else {
                        displayState = '예약 대기 중';
                        const todayStr = new Date().toISOString().split('T')[0];
                        if (!item.visitDate || item.visitDate >= todayStr) {
                            showApproveBtn = true;
                        } else {
                            displayState = '기간 만료 (승인 불가)';
                        }
                    }
                } else {
                    displayState = item.status === 'WARN' ? '경고 조치됨' : item.status;
                }

                document.getElementById('detailState').innerText = displayState;
                if(btnApprove) btnApprove.style.display = showApproveBtn ? 'inline-block' : 'none';

                let infoText = '';
                let dateText = '';

                if(item.category === 'RESIDENT') {
                    infoText = item.dong + '동 ' + item.ho + '호 / ' + item.userName + ' (' + item.phone + ')';
                    dateText = '등록 신청일: ' + item.regDate;
                } else if(item.category === 'VISITOR') {
                    infoText = '초대: ' + item.dong + '동 ' + item.ho + '호 (' + item.userName + ') / 목적: ' + item.visitPurpose;
                    dateText = '방문 예정일: ' + item.visitDate;
                } else {
                    infoText = '장소: ' + item.location + ' / 사유: ' + item.reason;
                    dateText = '적발 일시: ' + item.violationDate;
                }

                document.getElementById('detailInfo').innerText = infoText;
                document.getElementById('detailDate').innerText = dateText;
            }
        }

        modal.style.display = 'flex';
    }

    function closeModal(type) {
        const modal = modalMap[type];
        if(!modal) return;
        modal.style.display = 'none';
        currentSelectedUniqueId = null;
    }

    function approveAction() {
        if (!currentSelectedUniqueId) return;
        if (!confirm("해당 차량을 승인 처리하시겠습니까?")) return;

        const data = new URLSearchParams();
        data.append('id', currentSelectedUniqueId);
        data.append('category', currentCategory);

        fetch('/admin/parking/approve', {
            method: 'POST',
            body: data
        })
        .then(response => response.text())
        .then(msg => {
            alert(msg);
            location.reload(); 
        })
        .catch(error => {
            alert('승인 처리 중 오류가 발생했습니다.');
            console.error(error);
        });
    }

    function deleteAction() {
        if (!currentSelectedUniqueId) return;
        if (!confirm("해당 데이터를 정말 삭제(또는 단속 처리) 하시겠습니까?")) return;

        const data = new URLSearchParams();
        data.append('id', currentSelectedUniqueId);
        data.append('category', currentCategory);

        fetch('/admin/parking/delete', {
            method: 'POST',
            body: data
        })
        .then(response => response.text())
        .then(msg => {
            alert(msg);
            location.reload(); 
        })
        .catch(error => {
            alert('삭제 처리 중 오류가 발생했습니다.');
            console.error(error);
        });
    }

    return {
        filterTab,
        searchTable,
        goToPage,
        openModal,
        closeModal,
        approveAction,
        deleteAction
    };

})();