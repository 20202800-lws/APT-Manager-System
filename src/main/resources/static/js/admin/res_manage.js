/**
 * community_manage.js
 * 커뮤니티 시설 관리 스크립트 (Refactored for Server-Side Rendering & AJAX)
 */

const facilityManager = (function() {
    
    let currentViewType = '';
    const titles = { 
        profit: '💰 월별 수익 내역', 
        maintenance: '🛠️ 월별 지출 내역', 
        net: '📉 월별 순수익 내역', 
        users: '👥 월별 이용객 기록' 
    };

    // =========================================
    // 1. 예약 관리 로직 (Reservation Logic)
    // =========================================

    function approveRes(btn) {
        if (confirm("해당 예약을 승인하시겠습니까?")) {
            const tr = btn.closest('tr');
            const resId = tr.dataset.resId; 
            
            // 실제 서버 연동 시 아래 주석 해제 후 사용
            /*
            fetch(`/admin/facility/approve/${resId}`, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    if(data.success) updateResStatusUI(tr, 'APPROVED');
                });
            */
            
            // 낙관적 UI 업데이트 (임시)
            updateResStatusUI(tr, 'APPROVED');
        }
    }

    function cancelWithReason(btn) {
        const reason = prompt("취소 사유를 입력해주세요:");
        if (reason !== null) {
            if (reason.trim() === "") {
                alert("취소 사유를 입력해야 합니다.");
                return;
            }

            const tr = btn.closest('tr');
            const resId = tr.dataset.resId;

            // 실제 서버 연동 시 아래 주석 해제 후 사용
            /*
            fetch(`/admin/facility/cancel/${resId}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ reason: reason })
            })
            .then(res => res.json())
            .then(data => {
                if(data.success) updateResStatusUI(tr, 'CANCELLED', reason);
            });
            */

            // 낙관적 UI 업데이트 (임시)
            updateResStatusUI(tr, 'CANCELLED', reason);
        }
    }

    function updateResStatusUI(tr, status, reason = '') {
        const statusBadge = tr.querySelector('.status-badge');
        const actionTd = tr.querySelector('.action-td');
        
        tr.dataset.resStatus = status;

        if (status === 'APPROVED') {
            statusBadge.innerHTML = "● 승인완료";
            statusBadge.className = "badge badge-success status-badge"; 
            actionTd.innerHTML = `<button class="btn btn-secondary btn-xs text-danger" onclick="facilityManager.cancelWithReason(this)">예약취소</button>`;
        } else if (status === 'CANCELLED') {
            statusBadge.innerHTML = `● 취소됨 <span style="font-size:0.8em; opacity:0.8;">(${reason})</span>`;
            statusBadge.className = "badge badge-red status-badge";
            actionTd.innerHTML = `<button class="btn btn-secondary btn-xs" onclick="this.closest('tr').remove()">목록제거</button>`;
        }
    }

    function filterRes(facId, btn) {
        document.querySelectorAll('.tab-btn').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');

        const rows = document.querySelectorAll('#res-body tr');
        rows.forEach(row => { 
            const rowFacId = row.dataset.facId;
            if (facId === 'ALL' || rowFacId === facId) {
                row.style.display = '';
            } else {
                row.style.display = 'none'; 
            }
        });
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

        // 실제 서버 연동 부분
        /*
        fetch(`/admin/facility/toggle`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ facId: facId, available: newAvailable })
        }).then(res => {
            if(res.ok) { // 상태 변경 성공 시 UI 업데이트 }
        });
        */

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
    // 3. 모달 및 통계 로직 (AJAX Fetch 방식으로 변경)
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
        const year = yearSelect ? yearSelect.value : '2026';
        const body = document.getElementById('modal-body');
        if (!body) return;

        // 가짜 데이터 대신 서버에 요청을 보냅니다 (이전 로그 페이지에서 했던 방식과 동일)
        body.innerHTML = '<tr><td colspan="4" style="text-align:center;">데이터를 불러오는 중입니다...</td></tr>';

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
                                <td>${d.y}-${d.m}</td>
                                <td>${currentViewType.toUpperCase()}</td>
                                <td class="text-primary" style="font-weight:700;">${d.v}</td>
                                <td><span class="badge badge-gray">${d.n}</span></td>
                            </tr>`;
                    });
                }
                body.innerHTML = html;
            })
            .catch(err => {
                console.error("통계 로딩 실패", err);
                body.innerHTML = '<tr><td colspan="4" style="text-align:center; color:red;">통계를 불러오지 못했습니다. (서버 연결 대기중)</td></tr>';
            });
    }

    function closeModal() {
        const modal = document.getElementById('historyModal');
        if (modal) modal.style.display = 'none';
    }

    return {
        approveRes,
        cancelWithReason,
        filterRes,
        toggleFac,
        openHistory,
        renderHistory,
        closeModal
    };

})();