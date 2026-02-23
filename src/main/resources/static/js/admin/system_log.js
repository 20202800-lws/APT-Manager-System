/**
 * system_log.js
 * 시스템 감사 로그 관리 스크립트 (클라이언트 사이드 페이징 적용)
 */

const systemLogManager = (function() {

    // 1. 데이터 초기화
    let allLogs = window.globalLogList || [];
    let filteredLogs = [];
    let currentPage = 1;
    const pageSize = 10; 

    // 2. 초기화 함수 (모듈 내부에서 호출)
    function init() {
        searchLogs(); // 초기 로드 시 전체 데이터 필터링 및 렌더링
    }

    // 3. 검색 및 필터링 로직
    function searchLogs() {
        const severityEl = document.getElementById("severityFilter");
        const keywordEl = document.getElementById("keyword");

        const severity = severityEl ? severityEl.value : "ALL";
        const keyword = keywordEl ? keywordEl.value.toLowerCase().trim() : "";

        filteredLogs = allLogs.filter(log => {
            // 중요도 필터
            const matchSeverity = (severity === "ALL" || severity === "") ? true : log.severity === severity;
            
            // 키워드 검색 (사용자, 내용, IP)
            const matchKeyword = keyword === "" ? true : 
                (log.username && log.username.toLowerCase().includes(keyword)) ||
                (log.content && log.content.toLowerCase().includes(keyword)) ||
                (log.sourceIp && log.sourceIp.toLowerCase().includes(keyword));
            
            return matchSeverity && matchKeyword;
        });

        currentPage = 1; // 검색 시 1페이지로 리셋
        renderTable();
    }

    // 4. 테이블 그리기
    function renderTable() {
        const tbody = document.getElementById("logTableBody");
        if (!tbody) return;

        if (filteredLogs.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding:40px; color:#999;">조회된 로그가 없습니다.</td></tr>`;
            renderPagination(0);
            return;
        }

        const totalPages = Math.ceil(filteredLogs.length / pageSize);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * pageSize;
        const paginatedData = filteredLogs.slice(startIndex, startIndex + pageSize);

        tbody.innerHTML = paginatedData.map(log => {
            let badgeClass = "badge-gray";
            let severityKR = log.severity;

            // 중요도별 한글화 및 색상 매핑
            if (log.severity === "INFO") { badgeClass = "badge-blue"; severityKR = "정보"; }
            else if (log.severity === "WARNING") { badgeClass = "badge-warning"; severityKR = "주의"; }
            else if (log.severity === "ERROR") { badgeClass = "badge-red"; severityKR = "에러"; }

            return `
                <tr>
                    <td><span class="badge ${badgeClass}">${severityKR}</span></td>
                    <td style="color:#666;">${log.createdAt || '-'}</td>
                    <td style="font-weight:600;">${log.username || '-'}</td>
                    <td><span class="badge badge-gray">${log.category || '-'}</span></td>
                    <td title="${log.content || ''}" style="text-align:left; max-width:300px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; color:#333;">
                        ${log.content || '-'}
                    </td>
                    <td style="color:#888; font-family:monospace;">${log.sourceIp || '-'}</td>
                </tr>
            `;
        }).join('');

        renderPagination(filteredLogs.length);
    }

    // 5. 페이징 버튼 생성
    function renderPagination(totalCount) {
        const container = document.getElementById("paginationWrapper");
        if (!container) return;

        // ★ 수정: 데이터가 0개일 때만 비우고 1페이지는 표시 유지 (일관성)
        if (totalCount === 0) {
            container.innerHTML = '';
            return;
        }

        const totalPages = Math.ceil(totalCount / pageSize);

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="systemLogManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="systemLogManager.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="systemLogManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    // 6. 페이지 이동
    function goToPage(page) {
        currentPage = page;
        renderTable();
    }

    // 초기화 리스너 등록
    document.addEventListener("DOMContentLoaded", init);

    // 외부 노출할 함수만 반환
    return {
        searchLogs,
        goToPage
    };

})();

// JSP의 인라인 스크립트나 태그의 onclick에서 접근 가능하도록 전역 브릿지 설정
window.searchLogs = systemLogManager.searchLogs;
window.goToPage = systemLogManager.goToPage;