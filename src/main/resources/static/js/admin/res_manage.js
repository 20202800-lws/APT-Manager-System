/**
 * community_manage.js (res_manage.js)
 * 커뮤니티 시설 관리 스크립트 (페이징 및 JS 렌더링 적용)
 */

const facilityManager = (function() {
    
    // 모달 관련
    let currentViewType = '';
    const titles = { 
        profit: '💰 월별 수익 내역', 
        maintenance: '🛠️ 월별 지출 내역', 
        net: '📉 월별 순수익 내역', 
        users: '👥 월별 이용객 기록' 
    };

    // 페이징 관련 변수
    let allResList = window.globalResList || [];
    let currentFilteredList = [];
    let currentFacFilter = 'ALL';
    let currentPage = 1;
    const rowsPerPage = 10; // 한 페이지당 표시할 예약 수

    // 시설명 맵핑
    const facNameMap = {
        'POOL': '수영장',
        'GYM': '헬스장',
        'GOLF': '골프장',
        'GUEST': '게스트하우스'
    };

    // 초기화 함수
    document.addEventListener('DOMContentLoaded', () => {
        filterRes('ALL');

        // ★ 수정: 모달 바깥 배경 클릭 시 닫기 기능 추가 (통일성 확보)
        const historyModal = document.getElementById('historyModal');
        window.addEventListener('click', (event) => {
            if (event.target === historyModal) {
                closeModal();
            }
        });
    });

    // =========================================
    // 1. 예약 관리 로직 (페이징 & 렌더링)
    // =========================================

    // 탭 필터링 로직
    function filterRes(facId, btn = null) {
        if (btn) {
            document.querySelectorAll('.tab-btn').forEach(t => t.classList.remove('active'));
            btn.classList.add('active');
        }

        currentFacFilter = facId;
        currentPage = 1; // 필터 변경 시 1페이지로 리셋

        if (facId === 'ALL') {
            currentFilteredList = [...allResList];
        } else {
            currentFilteredList = allResList.filter(res => res.facId === facId);
        }

        renderTable();
    }

    // 테이블 그리기
    function renderTable() {
        const tbody = document.getElementById('res-body');
        if (!tbody) return;

        if (currentFilteredList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:40px; color:#999;">예약 내역이 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        // 페이징 인덱스 계산
        const totalPages = Math.ceil(currentFilteredList.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = currentFilteredList.slice(startIndex, startIndex + rowsPerPage);

        // 테이블 행 생성
        tbody.innerHTML = paginatedData.map(res => {
            let statusHtml = '';
            let actionHtml = '';

            // 상태 배지 및 버튼 로직
            if (res.resStatus === 'WAITING') {
                statusHtml = `<span class="badge badge-warning status-badge">● 대기중</span>`;
                actionHtml = `
                    <button class="btn btn-primary btn-xs" onclick="facilityManager.approveRes('${res.resId}')">승인</button>
                    <button class="btn btn-secondary btn-xs" onclick="facilityManager.cancelWithReason('${res.resId}')">취소</button>
                `;
            } else if (res.resStatus === 'APPROVED') {
                statusHtml = `<span class="badge badge-success status-badge">● 승인완료</span>`;
                actionHtml = `
                    <button class="btn btn-secondary btn-xs text-danger" onclick="facilityManager.cancelWithReason('${res.resId}')">예약취소</button>
                `;
            } else if (res.resStatus === 'CANCELLED') {
                statusHtml = `<span class="badge badge-red status-badge">● 취소됨 <span style="font-size:0.8em; opacity:0.8;">(${res.reason || ''})</span></span>`;
                actionHtml = `
                    <button class="btn btn-secondary btn-xs" onclick="facilityManager.removeRes('${res.resId}')">목록제거</button>
                `;
            }

            return `
                <tr>
                    <td style="font-weight:600;">${facNameMap[res.facId] || res.facId}</td>
                    <td>${res.userName}</td>
                    <td>${res.dongHo}</td>
                    <td>${res.useTime}</td>
                    <td>${statusHtml}</td>
                    <td class="action-td" style="display:flex; justify-content:center; gap:5px;">${actionHtml}</td>
                </tr>
            `;
        }).join('');

        renderPagination(currentFilteredList.length);
    }

    // 페이징 버튼 생성
    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        // ★ 수정: 데이터가 0개일 때만 비우고, 1개 이상이면 1페이지 표시 유지
        if (totalCount === 0) { 
            container.innerHTML = ''; 
            return; 
        }

        const totalPages = Math.ceil(totalCount / rowsPerPage);

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="facilityManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="facilityManager.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="facilityManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    function goToPage(page) {
        currentPage = page;
        renderTable();
    }

    // 승인 로직 (JS 배열 업데이트 후 리렌더링)
    function approveRes(resId) {
        if (confirm("해당 예약을 승인하시겠습니까?")) {
            // 서버 통신 부분 (추후 적용)
            /* fetch... */
            
            // UI 반영
            const target = allResList.find(r => String(r.resId) === String(resId));
            if (target) {
                target.resStatus = 'APPROVED';
                filterRes(currentFacFilter); // 현재 탭 상태 유지하며 리렌더링
            }
        }
    }

    // 취소 로직 (JS 배열 업데이트 후 리렌더링)
    function cancelWithReason(resId) {
        const reason = prompt("취소 사유를 입력해주세요:");
        
        // 사용자가 취소를 누르거나 빈 칸을 입력한 경우 처리
        if (reason === null) return; 
        if (reason.trim() === "") {
            alert("취소 사유를 입력해야 처리가 가능합니다.");
            return;
        }

        // 서버 통신 부분 (추후 적용)
        /* fetch... */

        // UI 반영
        const target = allResList.find(r => String(r.resId) === String(resId));
        if (target) {
            target.resStatus = 'CANCELLED';
            target.reason = reason;
            filterRes(currentFacFilter);
        }
    }

    // 목록에서 완전히 제거 (JS 배열에서 삭제)
    function removeRes(resId) {
        if(confirm("해당 취소 내역을 목록에서 완전히 지우시겠습니까?")) {
            allResList = allResList.filter(r => String(r.resId) !== String(resId));
            filterRes(currentFacFilter);
        }
    }


    // =========================================
    // 2. 시설 제어 로직 (Facility Control)
    // =========================================

    function toggleFac(facId) {
        const item = document.getElementById('fac-card-' + facId);
        if (!item) return;

        const label = item.querySelector('.tgl-label');
        const currentAvailable = parseInt(item.dataset.available, 10);
        const newAvailable = currentAvailable === 1 ? 0 : 1;

        item.dataset.available = newAvailable.toString();

        if (newAvailable === 1) {
            item.classList.remove('on');
            item.style.background = ''; 
            item.style.border = '1px solid var(--border-color)';
            label.innerText = '운영 중';
            label.className = 'badge badge-green tgl-label';
        } else {
            item.classList.add('on');
            item.style.background = '#fff5f5'; 
            item.style.border = '1px solid #ffebee';
            label.innerText = '점검 중';
            label.className = 'badge badge-red tgl-label';
        }
    }

    // =========================================
    // 3. 모달 및 통계 로직 (AJAX)
    // =========================================

    function openHistory(type) {
        currentViewType = type;
        const titleEl = document.getElementById('modalTitle');
        if (titleEl) titleEl.innerText = titles[type];
        
        const modal = document.getElementById('historyModal');
        if (modal) modal.style.display = 'flex';
        
        renderHistory();
    }

    function renderHistory() {
        const yearSelect = document.getElementById('yearSelector');
        const year = yearSelect ? yearSelect.value : new Date().getFullYear().toString();
        const body = document.getElementById('modal-body');
        if (!body) return;

        body.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:30px;">데이터를 불러오는 중입니다...</td></tr>';

        // 서버 연동 시 아래 경로 수정
        fetch(`/admin/facility/history?type=${currentViewType}&year=${year}`)
            .then(res => res.json())
            .then(data => {
                let html = '';
                if (!data || data.length === 0) {
                    html = '<tr><td colspan="4" style="text-align:center; padding:40px; color:#999;">해당 연도의 기록이 없습니다.</td></tr>';
                } else {
                    data.forEach(d => {
                        html += `
                            <tr>
                                <td>${d.y}년 ${d.m}월</td>
                                <td style="font-weight:600;">${currentViewType.toUpperCase()}</td>
                                <td class="text-primary" style="font-weight:700;">${d.v.toLocaleString()}</td>
                                <td><span class="badge badge-gray">${d.n || '-'}</span></td>
                            </tr>`;
                    });
                }
                body.innerHTML = html;
            })
            .catch(err => {
                console.error("통계 로딩 실패", err);
                body.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:30px; color:var(--danger);">통계를 불러오지 못했습니다. (서버 연결 오류)</td></tr>';
            });
    }

    function closeModal() {
        const modal = document.getElementById('historyModal');
        if (modal) modal.style.display = 'none';
    }

    return {
        filterRes,
        goToPage,
        approveRes,
        cancelWithReason,
        removeRes,
        toggleFac,
        openHistory,
        renderHistory,
        closeModal
    };

})();