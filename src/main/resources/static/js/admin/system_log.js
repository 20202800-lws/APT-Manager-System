/* =========================================
   시스템 감사 로그 관리 로직 (systemLog.js)
   ========================================= */

let currentPage = 1;
let pageSize = 10;
let totalPages = 1; // 전체 페이지 수 추적용 변수 추가

document.addEventListener("DOMContentLoaded", function () {
    loadLogs();
});

// 로그 데이터 페치 및 렌더링
function loadLogs() {
    const severity = document.getElementById("severityFilter").value;
    const keyword = document.getElementById("keyword").value;

    fetch(`/admin/system-logs?page=${currentPage}&size=${pageSize}&severity=${severity}&keyword=${keyword}`)
        .then(res => res.json())
        .then(data => {
            const tbody = document.getElementById("logTableBody");
            tbody.innerHTML = "";

            // 1. 데이터가 없을 경우 처리
            if (!data.content || data.content.length === 0) {
                tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding:30px; color:#999;">조회된 로그가 없습니다.</td></tr>`;
                document.getElementById("pageInfo").innerText = "0 / 0 페이지";
                totalPages = 1;
                return;
            }

            // 2. 전체 페이지 수 업데이트
            totalPages = data.totalPages;

            // 3. 테이블 데이터 렌더링 (HTML thead 순서에 맞춤)
            data.content.forEach(log => {
                let badgeClass = "badge-gray";
                if (log.severity === "INFO") badgeClass = "badge-blue";
                else if (log.severity === "WARNING") badgeClass = "badge-warning";
                else if (log.severity === "ERROR") badgeClass = "badge-red";

                const row = `
                    <tr>
                        <td><span class="badge ${badgeClass}">${log.severity}</span></td>
                        <td>${log.createdAt}</td>
                        <td>${log.username || '-'}</td>
                        <td>${log.category}</td>
                        <td title="${log.content}" style="text-align:left; max-width:300px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                            ${log.content}
                        </td>
                        <td>${log.sourceIp || '-'}</td>
                    </tr>
                `;
                tbody.insertAdjacentHTML("beforeend", row);
            });

            // 4. 페이징 텍스트 업데이트 (Spring Data JPA의 number는 0부터 시작)
            document.getElementById("pageInfo").innerText = ` ${data.number + 1} / ${totalPages} 페이지`;
        })
        .catch(error => {
            console.error("로그 데이터 로딩 실패:", error);
            const tbody = document.getElementById("logTableBody");
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding:30px; color:red;">데이터를 불러오는 중 오류가 발생했습니다.</td></tr>`;
        });
}

// 검색 버튼 클릭 시
function searchLogs() {
    currentPage = 1; // 검색 시 항상 1페이지로 초기화
    loadLogs();
}

// 다음 페이지 이동
function nextPage() {
    if (currentPage < totalPages) {
        currentPage++;
        loadLogs();
    } else {
        alert("마지막 페이지입니다.");
    }
}

// 이전 페이지 이동
function prevPage() {
    if (currentPage > 1) {
        currentPage--;
        loadLogs();
    } else {
        alert("첫 번째 페이지입니다.");
    }
}