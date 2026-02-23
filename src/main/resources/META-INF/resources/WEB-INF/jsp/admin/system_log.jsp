<%@ page contentType="text/html;charset=UTF-8" %>

<div class="main-content">

    <div class="content-header">
        <h2>시스템 감사 로그</h2>
        <div class="subtitle">시스템 변경 이력을 조회합니다.</div>
    </div>

    <div class="content-box">

        <div class="section-header">
            <div class="section-actions" style="display: flex; gap: 10px; align-items: center;">

                <select id="severityFilter" class="form-select" onchange="searchLogs()">
                    <option value="ALL">전체</option>
                    <option value="INFO">정보</option>
                    <option value="WARNING">경고</option>
                    <option value="ERROR">에러</option>
                </select>

                <input type="text" id="keyword" 
                       class="form-input" 
                       placeholder="사용자, IP, 내용 검색"
                       onkeyup="if(event.keyCode===13) searchLogs()">

                <button class="btn btn-primary" onclick="searchLogs()">
                    검색
                </button>

            </div>
        </div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th width="120">중요도</th>
                    <th width="200">일시</th>
                    <th width="100">사용자</th>
                    <th width="120">카테고리</th>
                    <th>내용</th>
                    <th width="160">IP</th>
                </tr>
            </thead>
            <tbody id="logTableBody">
            </tbody>
        </table>

        <div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>

    </div>
</div>

<script>
    // 서버에서 데이터를 넘겨받을 경우 아래 배열에 바인딩됩니다.
    window.globalLogList = [];

    //추후 서버 연동 시 아래 주석을 해제하여 사용하세요.
    <c:if test="${not empty logList}">
        <c:forEach var="log" items="${logList}">
            window.globalLogList.push({
                severity: '${log.severity}',
                createdAt: '${log.createdAt}',
                username: '${log.username}',
                category: '${log.category}',
                content: '${log.content}',
                sourceIp: '${log.sourceIp}'
            });
        </c:forEach>
    </c:if>
   //
</script>
<script src="/resources/js/systemLog.js"></script>