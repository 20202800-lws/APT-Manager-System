/**
 * community_manage.js
 * 커뮤니티 시설 관리 스크립트 (Refactored for ERD alignment)
 * * [ERD Reference]
 * - FACILITY: fac_id (PK), available (0/1)
 * - FACILITY_RES: res_id (PK), res_status (WAITING, APPROVED, CANCELLED)
 */

const facilityManager = (function() {
    
    // =========================================
    // 1. Mock Data (통계용 가상 데이터)
    // =========================================
    let currentViewType = '';
    const rawData = {
        profit: [ 
            {y:'2026', m:'02', v:'₩4,250,000', n:'진행중'}, 
            {y:'2026', m:'01', v:'₩5,100,000', n:'마감'}
        ],
        maintenance: [ 
            {y:'2026', m:'02', v:'₩1,120,000', n:'필터교체'}, 
            {y:'2026', m:'01', v:'₩850,000', n:'기구수리'}
        ],
        net: [
            {y:'2026', m:'02', v:'₩3,130,000', n:'-'}, 
            {y:'2026', m:'01', v:'₩4,250,000', n:'최고순익'}
        ],
        users: [ 
            {y:'2026', m:'02', v:'1,242명', n:'진행중'}, 
            {y:'2026', m:'01', v:'1,580명', n:'방학특수'}
        ]
    };

    const titles = { 
        profit: '💰 월별 수익 내역', 
        maintenance: '🛠️ 월별 지출 내역', 
        net: '📉 월별 순수익 내역', 
        users: '👥 월별 이용객 기록' 
    };

    // =========================================
    // 2. 예약 관리 로직 (Reservation Logic)
    // =========================================

    /**
     * 예약 승인
     * [DB Action] UPDATE FACILITY_RES SET res_status = 'APPROVED' WHERE res_id = ?
     */
    function approveRes(btn) {
        if (confirm("해당 예약을 승인하시겠습니까?")) {
            const tr = btn.closest('tr');
            const resId = tr.dataset.resId; // JSP: data-res-id
            
            // [TODO: AJAX/Fetch call to Server]
            console.log(`[DB Query] UPDATE FACILITY_RES SET res_status = 'APPROVED' WHERE res_id = ${resId};`);

            // UI Optimistic Update
            updateResStatusUI(tr, 'APPROVED');
        }
    }

    /**
     * 예약 취소 (사유 입력)
     * [DB Action] UPDATE FACILITY_RES SET res_status = 'CANCELLED' WHERE res_id = ?
     */
    function cancelWithReason(btn) {
        const reason = prompt("취소 사유를 입력해주세요:");
        if (reason !== null) {
            if (reason.trim() === "") {
                alert("취소 사유를 입력해야 합니다.");
                return;
            }

            const tr = btn.closest('tr');
            const resId = tr.dataset.resId; // JSP: data-res-id

            // [TODO: AJAX/Fetch call to Server with reason]
            console.log(`[DB Query] UPDATE FACILITY_RES SET res_status = 'CANCELLED' WHERE res_id = ${resId};`);
            console.log(`[Log] Reason: ${reason}`);

            // UI Optimistic Update
            updateResStatusUI(tr, 'CANCELLED', reason);
        }
    }

    /**
     * 내부 함수: UI 상태 변경 처리
     */
    function updateResStatusUI(tr, status, reason = '') {
        const statusBadge = tr.querySelector('.status-badge');
        const actionTd = tr.querySelector('.action-td');
        
        tr.dataset.resStatus = status; // 데이터 속성 업데이트

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

    /**
     * 탭 필터링 (시설별 보기)
     */
    function filterRes(facId, btn) {
        // 1. 탭 버튼 활성화 상태 변경
        document.querySelectorAll('.tab-btn').forEach(t => t.classList.remove('active'));
        btn.classList.add('active');

        // 2. 테이블 행 필터링
        const rows = document.querySelectorAll('#res-body tr');
        rows.forEach(row => { 
            const rowFacId = row.dataset.facId; // JSP: data-fac-id
            // 'ALL' 이거나 ID가 일치하면 표시
            if (facId === 'ALL' || rowFacId === facId) {
                row.style.display = '';
            } else {
                row.style.display = 'none'; 
            }
        });
    }

    // =========================================
    // 3. 시설 제어 로직 (Facility Control)
    // =========================================

    /**
     * 시설 상태 토글 (운영 중 <-> 점검 중)
     * [DB Action] UPDATE FACILITY SET available = ? WHERE fac_id = ?
     */
    function toggleFac(facId) {
        const item = document.getElementById('fac-card-' + facId); // ID Selector
        if (!item) return;

        const label = item.querySelector('.tgl-label');
        
        // 현재 상태값 파싱 (String -> Int)
        const currentAvailable = parseInt(item.dataset.available, 10);
        
        // 상태 반전 (1 -> 0, 0 -> 1)
        const newAvailable = currentAvailable === 1 ? 0 : 1;

        // [TODO: AJAX/Fetch call to Server]
        console.log(`[DB Query] UPDATE FACILITY SET available = ${newAvailable} WHERE fac_id = '${facId}';`);

        // UI Update
        item.dataset.available = newAvailable.toString();

        if (newAvailable === 1) {
            // Available (운영 중)
            item.classList.remove('on'); // 빨간 배경 제거
            item.style.background = ''; 
            item.style.border = '1px solid var(--border-color)';
            
            label.innerText = '운영 중';
            label.className = 'badge badge-green tgl-label';
        } else {
            // Unavailable (점검 중)
            item.classList.add('on'); // 빨간 배경 추가
            item.style.background = '#fff5f5'; 
            item.style.border = '1px solid #ffebee';
            
            label.innerText = '점검 중';
            label.className = 'badge badge-red tgl-label';
        }
    }

    // =========================================
    // 4. 모달 및 통계 로직 (Modal & Stats)
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

        // 해당 연도 데이터 필터링
        const data = rawData[currentViewType].filter(item => item.y === year);
        
        let html = '';
        if (data.length === 0) {
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
    }

    function closeModal() {
        const modal = document.getElementById('historyModal');
        if (modal) modal.style.display = 'none';
    }

    // 외부에서 호출 가능하도록 Return
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