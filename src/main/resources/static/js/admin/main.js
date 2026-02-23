/* =========================================
   관리자 | 대시보드 로직 (데이터 연동 & 독립 페이징)
   ========================================= */

const dashboardManager = (function() {

    // 1. 데이터 초기화 (JSP 전역 변수에서 호출)
    let statsData = window.globalStatsData || { totalHouseholdCount: 0, unprocessedMinwon: 0, feePaymentRate: 0, parkingRate: 0 };
    let minwonList = window.globalRecentMinwonList || [];
    let memberList = window.globalPendingMemberList || [];

    // 2. 독립적인 페이징 관련 변수 설정 (대시보드는 한 화면에 적게 보여주는 것이 좋음)
    const rowsPerPage = 5;
    let currentMinwonPage = 1;
    let currentMemberPage = 1;

    // 3. 초기 실행 (DOM 로드 후)
    document.addEventListener('DOMContentLoaded', () => {
        renderDate();
        renderStats();
        renderClaims();
        renderMembers();
    });

    // 날짜 표시
    function renderDate() {
        const today = new Date();
        const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
        document.getElementById('currentDate').innerText = today.toLocaleDateString('ko-KR', options);
    }

    // 통계 렌더링
    function renderStats() {
        document.getElementById('statTotalHouseholdCount').innerHTML = 
            `${statsData.totalHouseholdCount.toLocaleString()}<span class="unit">세대</span>`;
        
        document.getElementById('statUnprocessedMinwon').innerHTML = 
            `${statsData.unprocessedMinwon.toLocaleString()}<span class="unit">건</span>`;
        
        document.getElementById('statFeePaymentRate').innerHTML = 
            `${statsData.feePaymentRate}<span class="unit">%</span>`;
        
        document.getElementById('statParkingRate').innerHTML = 
            `${statsData.parkingRate}<span class="unit">%</span>`;
    }

    /* =========================================
       민원 목록 페이징 및 렌더링
       ========================================= */
    function renderClaims() {
        const tbody = document.getElementById('minwonTableBody');
        
        if (minwonList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="color:#999; text-align:center; padding:30px;">최근 접수된 민원이 없습니다.</td></tr>';
            renderPagination('minwonPaginationWrapper', 0, currentMinwonPage, 'dashboardManager.goToMinwonPage');
            return;
        }

        const totalPages = Math.ceil(minwonList.length / rowsPerPage);
        if (currentMinwonPage > totalPages) currentMinwonPage = totalPages || 1;

        const startIndex = (currentMinwonPage - 1) * rowsPerPage;
        const paginatedData = minwonList.slice(startIndex, startIndex + rowsPerPage);

        tbody.innerHTML = paginatedData.map(item => {
            let badge = '';
            if(item.compStatus === 'WAIT') badge = '<span class="badge badge-danger">대기</span>'; // CSS 클래스 통일 (red -> danger)
            else if(item.compStatus === 'ING') badge = '<span class="badge badge-primary">진행</span>'; // (blue -> primary)
            else badge = '<span class="badge badge-secondary">완료</span>'; // (gray -> secondary)

            let catColor = item.category === '시설' ? '#1A237E' : '#666';

            return `
                <tr>
                    <td style="color:${catColor}; font-weight:600;">${item.category}</td>
                    <td class="td-title" onclick="alert('민원 상세(ID:${item.compId}) 이동')">
                        ${item.title}
                    </td>
                    <td style="color:#888; font-size:0.9rem;">${item.regDate}</td>
                    <td>${badge}</td>
                </tr>
            `;
        }).join('');

        renderPagination('minwonPaginationWrapper', minwonList.length, currentMinwonPage, 'dashboardManager.goToMinwonPage');
    }

    /* =========================================
       승인 대기 회원 목록 페이징 및 렌더링
       ========================================= */
    function renderMembers() {
        const tbody = document.getElementById('memberTableBody');
        
        if (memberList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" style="color:#999; text-align:center; padding:30px;">승인 대기 중인 회원이 없습니다.</td></tr>';
            renderPagination('memberPaginationWrapper', 0, currentMemberPage, 'dashboardManager.goToMemberPage');
            return;
        }

        const totalPages = Math.ceil(memberList.length / rowsPerPage);
        if (currentMemberPage > totalPages) currentMemberPage = totalPages || 1;

        const startIndex = (currentMemberPage - 1) * rowsPerPage;
        const paginatedData = memberList.slice(startIndex, startIndex + rowsPerPage);

        tbody.innerHTML = paginatedData.map(item => {
            return `
                <tr>
                    <td style="font-weight:600;">${item.dong}동 ${item.ho}호</td>
                    <td>${item.userName}</td>
                    <td style="color:#888; font-size:0.9rem;">${item.joinDate}</td>
                    <td>
                        <button class="btn btn-primary btn-xs" onclick="dashboardManager.quickApprove('${item.userId}', '${item.userName}')">
                            승인
                        </button>
                    </td>
                </tr>
            `;
        }).join('');

        renderPagination('memberPaginationWrapper', memberList.length, currentMemberPage, 'dashboardManager.goToMemberPage');
    }

    /* =========================================
       공통 페이징 UI 렌더링 함수
       ========================================= */
    function renderPagination(containerId, totalCount, currentPage, fnName) {
        const container = document.getElementById(containerId);
        if (!container) return;

        const totalPages = Math.ceil(totalCount / rowsPerPage);
        if(totalPages <= 1) { container.innerHTML = ''; return; }

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="${fnName}(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="${fnName}(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="${fnName}(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    // 민원 페이지 이동 함수
    function goToMinwonPage(page) {
        currentMinwonPage = page;
        renderClaims();
    }

    // 회원 승인 페이지 이동 함수
    function goToMemberPage(page) {
        currentMemberPage = page;
        renderMembers();
    }

    /* =========================================
       기능 로직 (승인 처리)
       ========================================= */
    function quickApprove(id, name) {
        if(confirm(`${name} 님의 가입을 승인하시겠습니까?`)) {
            
            // 실제 서버 연결 시 이 부분에 AJAX / fetch 로직 구현
            // fetch('/admin/member/approve', { ... })
            
            alert(`[${name}]님 승인 처리되었습니다.`);
            
            // UI에서 해당 항목 즉시 제거 후 다시 그리기
            const rowIndex = memberList.findIndex(m => m.userId === id);
            if(rowIndex > -1) {
                memberList.splice(rowIndex, 1);
                
                // 데이터가 삭제되어 현재 페이지가 비게 되면 이전 페이지로 이동
                const totalPages = Math.ceil(memberList.length / rowsPerPage);
                if (currentMemberPage > totalPages && currentMemberPage > 1) {
                    currentMemberPage--;
                }
                
                renderMembers();
            }
        }
    }

    // 외부로 노출할 함수
    return {
        goToMinwonPage,
        goToMemberPage,
        quickApprove
    };

})();