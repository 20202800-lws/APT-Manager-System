/* =========================================
   fee_log.js
   관리비/수납 변경 이력 관리 (서버 연동 및 페이징 적용)
   ========================================= */

const feeLogManager = (function() {

    let currentPage = 1;
    let pageSize = 10;
    let totalPages = 1;

    document.addEventListener("DOMContentLoaded", function () {
        loadLogs(); 
    });

    // 1. 서버에서 로그 데이터 페치 및 렌더링 (GET)
    function loadLogs() {
        const severityEl = document.getElementById("severityFilter");
        const keywordEl = document.getElementById("keyword");

        const severity = severityEl ? severityEl.value : "";
        const keyword = keywordEl ? keywordEl.value : "";

        // Spring Data JPA는 기본적으로 0페이지부터 시작하므로 currentPage - 1을 전송
        const requestPage = currentPage - 1; 

        fetch(`/admin/fee-logs?page=${requestPage}&size=${pageSize}&severity=${severity}&keyword=${keyword}`)
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById("logTableBody");
                if(!tbody) return;

                tbody.innerHTML = "";

                if (!data.content || data.content.length === 0) {
                    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding:40px; color:#999;">조회된 변경 이력이 없습니다.</td></tr>`;
                    renderPagination(0);
                    return;
                }

                totalPages = data.totalPages;

                const rows = data.content.map(log => {
                    let badgeClass = "badge-gray";
                    let severityText = log.severity;
                    
                    if (log.severity === "INFO") { badgeClass = "badge-blue"; severityText = "정보"; }
                    else if (log.severity === "WARNING") { badgeClass = "badge-warning"; severityText = "주의"; }
                    else if (log.severity === "URGENT") { badgeClass = "badge-red"; severityText = "긴급"; }

                    return `
                        <tr>
                            <td><span class="badge ${badgeClass}">${severityText}</span></td>
                            <td>${log.createdAt || '-'}</td>
                            <td>${log.username || '-'}</td>
                            <td>${log.category || '-'}</td>
                            <td title="${log.content || ''}" style="text-align:left; max-width:250px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                                ${log.content || '-'}
                            </td>
                            <td>${log.sourceIp || '-'}</td>
                        </tr>
                    `;
                }).join('');

                tbody.innerHTML = rows;
                renderPagination(totalPages);
            })
            .catch(error => {
                console.error("로그 데이터 로딩 실패:", error);
                const tbody = document.getElementById("logTableBody");
                if(tbody) tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding:40px; color:var(--danger);">데이터를 불러오는 중 오류가 발생했습니다.</td></tr>`;
            });
    }

    // 검색 버튼 이벤트
    function searchLogs() {
        currentPage = 1; 
        loadLogs();
    }

    // 페이징 버튼 생성
    function renderPagination(totalP) {
        const container = document.getElementById("paginationWrapper");
        if (!container) return;

        if (totalP === 0) { 
            container.innerHTML = ''; 
            return; 
        }

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="feeLogManager.goToPage(${currentPage - 1})"`}>&lt;</button> `;
        
        for (let i = 1; i <= totalP; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="feeLogManager.goToPage(${i})">${i}</button> `;
        }
        
        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalP ? 'disabled' : `onclick="feeLogManager.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    // 페이지 이동
    function goToPage(page) {
        currentPage = page;
        loadLogs();
    }

    /* ==========================================
       로그 작성(글쓰기) 관련 로직 (POST 통신)
       ========================================== */
    function openLogModal() {
        const modal = document.getElementById("logModal");
        if(modal) {
            // ★ 수정: block -> flex로 변경하여 가운데 정렬 유지
            modal.style.display = "flex"; 
        }
        document.getElementById("newSeverity").value = "INFO";
        document.getElementById("newCategory").value = "수정";
        document.getElementById("newContent").value = "";
    }

    function closeLogModal() {
        const modal = document.getElementById("logModal");
        if(modal) modal.style.display = "none";
    }

    // 2. 서버로 작성한 로그 전송 (POST)
    function saveLog() {
        const severity = document.getElementById("newSeverity").value;
        const category = document.getElementById("newCategory").value;
        const content = document.getElementById("newContent").value.trim();

        if (!content) {
            alert("변경 내용을 입력해주세요.");
            return;
        }

        const saveBtn = document.getElementById("saveLogBtn");
        if(saveBtn) saveBtn.disabled = true; // 중복 클릭 방지

        const requestBody = {
            severity: severity,
            category: category,
            content: content
        };

        fetch('/admin/fee-logs', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
                // 'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content // Security 설정 시 주석 해제
            },
            body: JSON.stringify(requestBody)
        })
        .then(res => {
            if(saveBtn) saveBtn.disabled = false;
            if (res.ok) {
                alert("로그가 성공적으로 작성되었습니다.");
                closeLogModal();
                searchLogs(); 
            } else {
                alert("로그 작성에 실패했습니다. (서버 오류)");
            }
        })
        .catch(error => {
            if(saveBtn) saveBtn.disabled = false;
            console.error("로그 작성 중 에러:", error);
            alert("네트워크 오류가 발생했습니다.");
        });
    } 

    // 모듈 패턴 외부 노출
    return {
        searchLogs,
        goToPage,
        openLogModal,
        closeLogModal,
        saveLog
    };

})();

// ==========================================
// ★ JSP의 onclick 설정을 건드리지 않기 위한 브릿지 코드
// ==========================================
window.searchLogs = feeLogManager.searchLogs;
window.openLogModal = feeLogManager.openLogModal;
window.closeLogModal = feeLogManager.closeLogModal;
window.saveLog = feeLogManager.saveLog;