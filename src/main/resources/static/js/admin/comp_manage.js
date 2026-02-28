/* =========================================
   관리자 민원 관리 로직 (서버 연동형)
   ========================================= */

const complaintManager = (function() {
    
    // JSP에서 넘어온 전역 데이터
    let complaintList = window.globalComplaintList || [];

    document.addEventListener('DOMContentLoaded', () => {
        // 서버에서 받은 데이터 즉시 렌더링
        renderTable(complaintList);

        // 모달 바깥 배경 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target.classList && event.target.classList.contains('modal-overlay')) {
                closeModal();
            }
        };
    });

    // === 검색 필터 및 서버 이동 ===
    function searchTable() {
        const type = document.getElementById('searchType').value;
        const kw = document.getElementById('keyword').value.trim();
        
        // 추후 백엔드 필터 추가를 대비한 파라미터 수집
        const cat = document.getElementById('categoryFilter') ? document.getElementById('categoryFilter').value : '';
        const stat = document.getElementById('statusFilter') ? document.getElementById('statusFilter').value : '';

        // 검색 시 항상 1페이지(index 0)로 이동
        location.href = `?page=0&searchType=${type}&keyword=${encodeURIComponent(kw)}&category=${cat}&status=${stat}`;
    }

    // === 테이블 렌더링 ===
    function renderTable(data) {
        const tbody = document.getElementById('complaintTableBody');
        if (!tbody) return;

        if (!data || data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:40px; color:#999;">조건에 맞는 민원이 없습니다.</td></tr>';
            return;
        }

        const catMap = { 'FACILITY': '시설보수', 'NOISE': '층간소음', 'PARKING': '주차문제', 'ETC': '기타' };

        tbody.innerHTML = data.map(item => {
            let statusBadge = '';
            const status = (item.compStatus || "").toUpperCase();

            // 백엔드 상태값에 따른 뱃지 디자인 일치화
            if (status === 'WAIT') {
                statusBadge = '<span class="badge badge-gray">대기</span>'; 
            } else if (status === 'PENDING') {
                statusBadge = '<span class="badge badge-danger">접수</span>'; 
            } else if (status === 'PROCESSING') {
                statusBadge = '<span class="badge badge-info">진행중</span>';
            } else if (status === 'COMPLETED') {
                statusBadge = '<span class="badge badge-success">완료</span>';
            }

            return `
                <tr>
                    <td style="color:#666;">${item.compId}</td>
                    <td><span class="badge badge-gray" style="background:#eee; color:#555;">${catMap[item.category] || item.category}</span></td>
                    <td style="text-align:left; font-weight:500; cursor:pointer;" onclick="complaintManager.openModal(${item.compId})">
                        ${item.title}
                    </td>
                    <td>${item.userName} <span style="font-size:0.8rem; color:#888;">(${item.userId})</span></td>
                    <td style="color:#666;">${item.regDate}</td>
                    <td>${statusBadge}</td>
                    <td>
                        <button class="btn btn-secondary btn-xs" onclick="complaintManager.openModal(${item.compId})">
                            <i class="fa-solid fa-pen-to-square"></i> 관리
                        </button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    /* =========================================
       Modal Logic (상세 및 답변)
       ========================================= */
    function openModal(id) {
        const item = complaintList.find(d => d.compId === id);
        if(!item) return;

        const catMap = { 'FACILITY': '시설보수', 'NOISE': '층간소음', 'PARKING': '주차문제', 'ETC': '기타' };

        // 데이터 꽂아넣기
        document.getElementById('targetCompId').value = item.compId; 
        document.getElementById('modalCategory').innerText = catMap[item.category] || item.category;
        document.getElementById('modalUserName').innerText = `${item.userName} (${item.userId})`; 
        document.getElementById('modalRegDate').innerText = item.regDate;
        document.getElementById('modalContent').innerText = item.content; // 줄바꿈(\n) 유지를 위해 innerText 사용
        
        document.getElementById('modalReply').value = item.reply || ''; 
        
        // ★ UX 향상: 관리자가 '대기' 상태인 민원을 열면, 처리 상태를 '접수'로 자동 세팅해줍니다!
        const statusSelect = document.getElementById('modalCompStatus');
        if(item.compStatus === 'WAIT' || item.compStatus === null) {
            statusSelect.value = 'PENDING';
        } else {
            statusSelect.value = item.compStatus;
        }

        const modal = document.getElementById('complaintModal');
        if(modal) modal.style.display = 'flex'; // admin.css 표준 모달 노출 방식
    }

    function closeModal() {
        const modal = document.getElementById('complaintModal');
        if(modal) modal.style.display = 'none';
    }

    function saveComplaint() {
        const id = document.getElementById('targetCompId').value;
        const reply = document.getElementById('modalReply').value.trim();
        const status = document.getElementById('modalCompStatus').value;

        // ★ 유효성 검사: 처리 완료를 누르면서 답변을 안 쓰면 경고!
        if(status === 'COMPLETED' && reply === '') {
            alert("처리 완료 상태로 변경하려면 입주민에게 전달할 답변을 입력해주세요.");
            document.getElementById('modalReply').focus();
            return;
        }

        if(!confirm("민원 처리 상태 및 답변을 저장하시겠습니까?")) return;

        // 백엔드 AdminComplaintController 의 saveReply 로 POST 요청
        fetch('/admin/reply', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `compId=${id}&replyContent=${encodeURIComponent(reply)}&status=${status}`
        })
        .then(res => res.text())
        .then(data => {
            if(data === 'success') {
                alert("답변이 정상적으로 저장되었습니다.");
                location.reload(); // 저장 완료 시 페이지 새로고침하여 리스트 갱신
            } else {
                alert("저장 중 서버 오류가 발생했습니다: " + data);
            }
        })
        .catch(err => {
            console.error("Fetch Error:", err);
            alert("서버 통신 중 문제가 발생했습니다.");
        });
    }

    // 외부에서 접근 가능한 함수들만 노출
    return { 
        searchTable, openModal, closeModal, saveComplaint 
    };

})();