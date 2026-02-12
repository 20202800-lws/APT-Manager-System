/* =========================================
   민원 접수 현황 관리 (Server Integrated)
   ========================================= */

const complaintManager = (function() {

    // 1. 상태 변수 & API 설정
    let complaintList = []; // 서버 데이터 담을 변수
    
    // 백엔드 API 경로 (Controller와 일치해야 함)
    const API_URL = {
        LIST: '/api/admin/complaint/list',      // GET: 목록 조회
        STATS: '/api/admin/complaint/stats',    // GET: 통계 조회
        UPDATE: '/api/admin/complaint/process'  // PUT/POST: 답변 및 상태 수정
    };

    const modal = document.getElementById('complaintModal');

    document.addEventListener('DOMContentLoaded', () => {
        // 초기 데이터 로드
        loadStats();
        loadComplaintList();

        // 모달 외부 클릭 시 닫기
        window.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });
    });

    /* =========================================
       2. Server Communication (Async/Await)
       ========================================= */

    // [READ] 민원 목록 조회
    async function loadComplaintList() {
        const categoryVal = document.getElementById('categoryFilter').value;
        const statusVal = document.getElementById('statusFilter').value;
        const keyword = document.getElementById('keyword').value.trim();

        // 검색 조건 쿼리 스트링 생성
        const params = new URLSearchParams({
            category: categoryVal,
            status: statusVal,
            keyword: keyword,
            page: 1,  // 추후 페이지네이션 연동 시 변수 처리
            size: 10
        });

        try {
            const response = await fetch(`${API_URL.LIST}?${params.toString()}`);
            if (!response.ok) throw new Error("데이터 로드 실패");

            complaintList = await response.json();
            renderTable(complaintList);
        } catch (error) {
            console.error("민원 목록 로드 중 오류:", error);
            const tbody = document.getElementById('complaintTableBody');
            tbody.innerHTML = '<tr><td colspan="7" style="padding:40px; text-align:center; color:red;">데이터를 불러오지 못했습니다.</td></tr>';
        }
    }

    // [READ] 민원 통계 조회
    async function loadStats() {
        try {
            const response = await fetch(API_URL.STATS);
            if (response.ok) {
                const stats = await response.json();
                // DTO 구조: { pending: 10, processing: 5, completed: 20, total: 35 } 가정
                setCount('statPendingCount', stats.pending);
                setCount('statProcessingCount', stats.processing);
                setCount('statCompletedCount', stats.completed);
                setCount('statTotalCount', stats.total);
            }
        } catch (e) {
            console.error("통계 로드 실패", e);
        }
    }

    // [WRITE] 민원 답변 및 상태 저장
    async function saveComplaint() {
        const id = parseInt(document.getElementById('targetCompId').value); // Hidden Input
        const replyText = document.getElementById('modalReply').value;
        const statusText = document.getElementById('modalCompStatus').value; // Select Box

        if (!confirm("민원 처리 내용을 저장하시겠습니까?")) return;

        try {
            const response = await fetch(API_URL.UPDATE, {
                method: 'PUT', // 또는 POST
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    compId: id,
                    reply: replyText,
                    compStatus: statusText
                })
            });

            if (response.ok) {
                alert("정상적으로 처리되었습니다.");
                closeModal();
                loadComplaintList(); // 목록 갱신
                loadStats();         // 통계 갱신
            } else {
                alert("저장에 실패했습니다.");
            }
        } catch (e) {
            console.error(e);
            alert("서버 통신 오류가 발생했습니다.");
        }
    }

    /* =========================================
       3. UI Helper Functions
       ========================================= */
    
    function searchTable() {
        loadComplaintList(); // 서버에 검색 요청
    }

    function setCount(id, count) {
        const el = document.getElementById(id);
        if(el) el.innerHTML = `${count}<span class="unit">건</span>`;
    }

    function renderTable(data) {
        const tbody = document.getElementById('complaintTableBody');
        if (!data || data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="padding:40px; text-align:center; color:#999;">접수된 민원이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = data.map(item => {
            let catName = '기타';
            let catClass = 'badge-gray';
            
            switch(item.category) {
                case 'FACILITY': catName = '시설보수'; catClass = 'badge-red'; break;
                case 'NOISE': catName = '층간소음'; catClass = 'badge-blue'; break;
                case 'PARKING': catName = '주차문제'; catClass = 'badge-warning'; break;
                case 'ETC': catName = '기타'; catClass = 'badge-gray'; break;
            }

            let statusBadge = '';
            if(item.compStatus === 'PENDING') statusBadge = '<span class="badge badge-gray">접수</span>';
            else if(item.compStatus === 'PROCESSING') statusBadge = '<span class="badge badge-blue">진행중</span>';
            else if(item.compStatus === 'COMPLETED') statusBadge = '<span class="badge badge-green">완료</span>';

            return `
                <tr>
                    <td style="color:#666;">${item.compId}</td>
                    <td><span class="badge ${catClass}">${catName}</span></td>
                    <td style="text-align:left; padding-left:15px; font-weight:500; cursor:pointer; color:#333;" 
                        onclick="complaintManager.openModal(${item.compId})">
                        ${item.title}
                    </td>
                    <td>${item.userName}</td>
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
       4. Modal Logic
       ========================================= */

    function openModal(id) {
        // 상세 데이터는 목록에 있는 것을 재사용하거나, 필요 시 fetch(`${API_URL.DETAIL}/${id}`) 사용
        const item = complaintList.find(d => d.compId === id);
        if(!item) return;

        const catMap = { 'FACILITY': '시설보수', 'NOISE': '층간소음', 'PARKING': '주차문제', 'ETC': '기타' };

        // 데이터 바인딩
        document.getElementById('targetCompId').value = item.compId;
        document.getElementById('modalCategory').innerText = catMap[item.category] || item.category;
        document.getElementById('modalUserName').innerText = item.userName;
        document.getElementById('modalRegDate').innerText = item.regDate;
        document.getElementById('modalContent').innerText = item.content;
        
        // 입력 필드 초기화
        document.getElementById('modalReply').value = item.reply || ''; 
        document.getElementById('modalCompStatus').value = item.compStatus;

        if(modal) {
            modal.style.display = 'flex';
            setTimeout(() => modal.classList.add('active'), 10);
        }
    }

    function closeModal() {
        if(modal) {
            modal.classList.remove('active');
            setTimeout(() => modal.style.display = 'none', 300);
        }
    }

    return { 
        searchTable, 
        openModal, 
        closeModal, 
        saveComplaint 
    };

})();