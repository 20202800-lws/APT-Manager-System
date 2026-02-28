/* =========================================
   관리자 | 대시보드 로직 (초경량 서버 연동형)
   ========================================= */

const dashboardManager = (function() {

    // 1. 데이터 초기화 (백엔드에서 이미 최신 5건씩 잘라서 보내준 데이터)
    let minwonList = window.globalRecentMinwonList || [];
    let memberList = window.globalPendingMemberList || [];

    // 2. 초기 실행
    document.addEventListener('DOMContentLoaded', () => {
        renderDate();
        renderClaims();
        renderMembers();
    });

    // 오늘 날짜 표시 (우측 상단)
    function renderDate() {
        const today = new Date();
        const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
        const dateEl = document.getElementById('currentDate');
        if(dateEl) dateEl.innerText = today.toLocaleDateString('ko-KR', options);
    }

    /* =========================================
       민원 요약 목록 렌더링 (최대 5건)
       ========================================= */
    function renderClaims() {
        const tbody = document.getElementById('minwonTableBody');
        if(!tbody) return;

        if (minwonList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="color:#999; text-align:center; padding:30px;">최근 접수된 민원이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = minwonList.map(item => {
            let badge = '';
            const status = (item.compStatus || "").toUpperCase();

            // 백엔드 상태값 매칭
            if (status === 'WAIT') {
                badge = '<span class="badge badge-gray">대기</span>';
            } else if (status === 'PENDING') {
                badge = '<span class="badge badge-danger">접수</span>'; 
            } else if (status === 'PROCESSING') {
                badge = '<span class="badge badge-info">진행중</span>';
            } else if (status === 'COMPLETED') {
                badge = '<span class="badge badge-success">완료</span>';
            }

            const catMap = { 'FACILITY': '시설보수', 'NOISE': '층간소음', 'PARKING': '주차문제', 'ETC': '기타' };
            const catName = catMap[item.category] || item.category;

            return `
                <tr>
                    <td style="font-weight:600; color:#555;">${catName}</td>
                    <td class="td-title" onclick="location.href='/admin/comp_manage?keyword=${encodeURIComponent(item.title)}'">
                        ${item.title}
                    </td>
                    <td style="color:#888; font-size:0.9rem;">${item.regDate}</td>
                    <td>${badge}</td>
                </tr>
            `;
        }).join('');
    }

    /* =========================================
       승인 대기 회원 요약 목록 렌더링 (최대 5건)
       ========================================= */
    function renderMembers() {
        const tbody = document.getElementById('memberTableBody');
        if(!tbody) return;
        
        if (memberList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="color:#999; text-align:center; padding:30px;">승인 대기 중인 회원이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = memberList.map(item => {
            // 동호수 예외처리 방어
            let dongHoText = (!item.dong || item.dong === 'null') ? '-' : `${item.dong}동 ${item.ho}호`;

            return `
                <tr>
                    <td style="font-weight:600; color:#555;">${dongHoText}</td>
                    <td>${item.userName}</td>
                    <td style="color:#888; font-size:0.9rem;">${item.joinDate}</td>
                    <td>
                        <button class="btn btn-primary btn-xs" onclick="dashboardManager.quickApprove('${item.userId}', '${item.userName}')">
                            <i class="fa-solid fa-check"></i> 승인
                        </button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    /* =========================================
       기능 로직 (빠른 승인 API 연동)
       ========================================= */
    function quickApprove(id, name) {
        if(!confirm(`[${name}] 님의 가입을 승인하시겠습니까?`)) return;
            
        // AdminMemberController 의 approveMember 로 POST 요청
        fetch('/admin/member/approve', { 
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 'userId': id })
        })
        .then(response => {
            if (response.ok) {
                alert(`[${name}]님 승인 처리되었습니다.`);
                // 성공 시 화면을 즉시 새로고침하여 대시보드의 숫자가 갱신되도록 함
                location.reload(); 
            } else {
                alert("서버 오류로 인해 승인에 실패했습니다.");
            }
        })
        .catch(err => {
            console.error("Error:", err);
            alert("요청 중 네트워크 오류가 발생했습니다.");
        });
    }

    // 외부로 노출할 함수
    return {
        quickApprove
    };

})();