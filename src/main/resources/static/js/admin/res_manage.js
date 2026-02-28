/**
 * community_manage.js (res_manage.js)
 * 커뮤니티 시설 관리 스크립트 (페이징 및 JS 렌더링 적용)
 */

const facilityManager = (function() {
    
    let currentViewType = '';
    const titles = { 
        profit: '💰 월별 수익 내역', 
        maintenance: '🛠️ 월별 지출 내역', 
        net: '📉 월별 순수익 내역', 
        users: '👥 월별 이용객 기록' 
    };

    let allResList = window.globalResList || [];
    let currentFilteredList = [];
    let currentFacFilter = 'ALL';
    let currentPage = 1;
    const rowsPerPage = 10; 

    const facNameMap = {
        'POOL': '수영장',
        'GYM': '헬스장',
        'GOLF': '골프장',
        'GUEST': '게스트하우스'
    };

    document.addEventListener('DOMContentLoaded', () => {
        filterRes('ALL');

        const historyModal = document.getElementById('historyModal');
        window.addEventListener('click', (event) => {
            if (event.target === historyModal) {
                closeModal();
            }
        });
    });

    function filterRes(facId, btn = null) {
        if (btn) {
            document.querySelectorAll('.tab-btn').forEach(t => t.classList.remove('active'));
            btn.classList.add('active');
        }

        currentFacFilter = facId;
        currentPage = 1; 

        if (facId === 'ALL') {
            currentFilteredList = [...allResList];
        } else {
            currentFilteredList = allResList.filter(res => res.facId === facId);
        }

        renderTable();
    }

    function renderTable() {
        const tbody = document.getElementById('res-body');
        if (!tbody) return;

        if (currentFilteredList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:40px; color:#999;">예약 내역이 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        const totalPages = Math.ceil(currentFilteredList.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = currentFilteredList.slice(startIndex, startIndex + rowsPerPage);

        tbody.innerHTML = paginatedData.map(res => {
            let statusHtml = '';
            let actionHtml = '';

            // ★ 백엔드에서 보낸 '이용완료' 상태 완벽 대응
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
            } else if (res.resStatus === 'COMPLETED') {
                // 이미 이용 시간이 지났을 때 깔끔한 회색 뱃지로 처리
                statusHtml = `<span class="badge badge-gray status-badge" style="background:#e0e0e0; color:#555;">● 이용완료</span>`;
                actionHtml = `
                    <span style="color:#999; font-size:0.85em; padding-top:4px; display:inline-block;">처리완료</span>
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

    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

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

    function approveRes(resId) {
        if (confirm("해당 예약을 승인하시겠습니까?")) {
            const target = allResList.find(r => String(r.resId) === String(resId));
            if (target) {
                target.resStatus = 'APPROVED';
                filterRes(currentFacFilter); 
            }
        }
    }

    function cancelWithReason(resId) {
        const reason = prompt("취소 사유를 입력해주세요:");
        if (reason === null) return; 
        if (reason.trim() === "") {
            alert("취소 사유를 입력해야 처리가 가능합니다.");
            return;
        }

        const target = allResList.find(r => String(r.resId) === String(resId));
        if (target) {
            target.resStatus = 'CANCELLED';
            target.reason = reason;
            filterRes(currentFacFilter);
        }
    }

    function removeRes(resId) {
        if(confirm("해당 취소 내역을 목록에서 완전히 지우시겠습니까?")) {
            allResList = allResList.filter(r => String(r.resId) !== String(resId));
            filterRes(currentFacFilter);
        }
    }

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
        filterRes, goToPage, approveRes, cancelWithReason, removeRes, toggleFac, openHistory, renderHistory, closeModal
    };

})();