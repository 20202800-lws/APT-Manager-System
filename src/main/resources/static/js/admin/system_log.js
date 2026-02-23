/**
 * systemLog.js
 * 시스템 감사 로그 관리 스크립트 (클라이언트 사이드 페이징 적용)
 */

let allLogs = window.globalLogList || [];
let filteredLogs = [];
let currentPage = 1;
const pageSize = 10; // 한 페이지당 표시할 로그 수

document.addEventListener("DOMContentLoaded", function () {
    searchLogs(); // 초기 로드 시 전체 데이터 필터링 및 렌더링
});

// 검색 및 필터링 로직
function searchLogs() {
    const severity = document.getElementById("severityFilter").value;
    const keyword = document.getElementById("keyword").value.toLowerCase().trim();

    filteredLogs = allLogs.filter(log => {
        // 1. 중요도 필터
        const matchSeverity = (severity === "ALL" || severity === "") ? true : log.severity === severity;
        
        // 2. 키워드 검색 (사용자, 내용, IP)
        const matchKeyword = keyword === "" ? true : 
            (log.username && log.username.toLowerCase().includes(keyword)) ||
            (log.content && log.content.toLowerCase().includes(keyword)) ||
            (log.sourceIp && log.sourceIp.toLowerCase().includes(keyword));
        
        return matchSeverity && matchKeyword;
    });

    currentPage = 1; // 검색 조건이 바뀌면 1페이지로 리셋
    renderTable();
}

// 테이블 그리기
function renderTable() {
    const tbody = document.getElementById("logTableBody");
    if (!tbody) return;

    // 데이터가 없을 경우
    if (filteredLogs.length === 0) {
        tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding:40px; color:#999;">조회된 로그가 없습니다.</td></tr>`;
        renderPagination(0);
        return;
    }

    // 페이징 인덱스 계산
    const totalPages = Math.ceil(filteredLogs.length / pageSize);
    if (currentPage > totalPages) currentPage = totalPages || 1;

    const startIndex = (currentPage - 1) * pageSize;
    const paginatedData = filteredLogs.slice(startIndex, startIndex + pageSize);

    // 테이블 행 생성
    tbody.innerHTML = paginatedData.map(log => {
        let badgeClass = "badge-gray";
        if (log.severity === "INFO") badgeClass = "badge-blue";
        else if (log.severity === "WARNING") badgeClass = "badge-warning";
        else if (log.severity === "ERROR") badgeClass = "badge-red";

        return `
            <tr>
                <td><span class="badge ${badgeClass}">${log.severity}</span></td>
                <td>${log.createdAt || '-'}</td>
                <td>${log.username || '-'}</td>
                <td>${log.category || '-'}</td>
                <td title="${log.content || ''}" style="text-align:left; max-width:300px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                    ${log.content || '-'}
                </td>
                <td>${log.sourceIp || '-'}</td>
            </tr>
        `;
    }).join('');

    renderPagination(filteredLogs.length);
}

// 페이징 버튼 생성
function renderPagination(totalCount) {
    const container = document.getElementById("paginationWrapper");
    if (!container) return;

    const totalPages = Math.ceil(totalCount / pageSize);
    
    if (totalPages <= 1) { 
        container.innerHTML = ''; 
        return; 
    }

    let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="goToPage(${currentPage - 1})"`}>&lt;</button> `;

    for (let i = 1; i <= totalPages; i++) {
        const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
        html += `<button class="btn ${activeClass} btn-xs" onclick="goToPage(${i})">${i}</button> `;
    }

    html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="goToPage(${currentPage + 1})"`}>&gt;</button>`;
    
    container.innerHTML = html;
}

// 페이지 이동
function goToPage(page) {
    currentPage = page;
    renderTable();
}