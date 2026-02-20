<%@ page contentType="text/html;charset=UTF-8" %>

<div class="main-content">

    <div class="content-header">
        <h2>시스템 감사 로그</h2>
        <div class="subtitle">시스템 변경 이력을 조회합니다.</div>
    </div>

    <div class="content-box">

        <!-- 검색 & 필터 영역 -->
        <div class="section-header">

            <div class="section-actions">

                <!-- 중요도 드롭다운 -->
                <select id="severityFilter" class="form-select">
                    <option value="">전체</option>
                    <option value="INFO">정보</option>
                    <option value="WARNING">경고</option>
                    <option value="ERROR">에러</option>
                </select>

                <!-- 검색 -->
                <input type="text" id="keyword" 
                       class="form-input" 
                       placeholder="사용자, IP, 내용 검색">

                <button class="btn btn-primary" onclick="searchLogs()">
                    검색
                </button>

            </div>
        </div>

        <!-- 로그 테이블 -->
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

        <!-- 페이징 -->
        <div style="margin-top:15px; text-align:center;">
            <button class="btn btn-secondary btn-xs" onclick="prevPage()">이전</button>
            <span id="pageInfo"></span>
            <button class="btn btn-secondary btn-xs" onclick="nextPage()">다음</button>
        </div>

    </div>
</div>

<script src="/resources/js/systemLog.js"></script>