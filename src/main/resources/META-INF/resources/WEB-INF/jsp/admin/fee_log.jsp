<%@ page contentType="text/html;charset=UTF-8" %>

<div class="main-content">

    <div class="content-header">
        <h2>관리비/수납 변경 이력</h2>
        <div class="subtitle">관리비, 수도요금 등 금전 관련 데이터의 수동 변경 이력을 관리합니다.</div>
    </div>

    <div class="content-box">

        <div class="section-header" style="display: flex; justify-content: space-between; align-items: center;">
            
            <div class="section-actions" style="display: flex; gap: 10px; align-items: center;">
                <select id="severityFilter" class="form-select" onchange="searchLogs()">
                    <option value="">전체</option>
                    <option value="INFO">정보</option>
                    <option value="WARNING">주의</option>
                    <option value="URGENT">긴급</option>
                </select>

                <input type="text" id="keyword" 
                       class="form-input" 
                       placeholder="사용자, 내용 검색"
                       onkeyup="if(event.keyCode===13) searchLogs()">

                <button class="btn btn-primary" onclick="searchLogs()">검색</button>
            </div>

            <div>
                <button class="btn btn-success" onclick="openLogModal()">+ 로그 작성</button>
            </div>
        </div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th width="100">중요도</th>
                    <th width="180">일시</th>
                    <th width="120">사용자</th>
                    <th width="120">카테고리</th>
                    <th>내용</th>
                    <th width="140">IP</th>
                </tr>
            </thead>
            <tbody id="logTableBody">
            </tbody>
        </table>

        <div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>

    </div>
</div>

<div id="logModal" class="modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000;">
    <div class="modal-content" style="background:#fff; width:400px; margin: 10% auto; padding:20px; border-radius:8px;">
        <h3 style="margin-top:0;">수동 변경 로그 작성</h3>
        
        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px;">중요도</label>
            <select id="newSeverity" class="form-select" style="width:100%;">
                <option value="INFO">정보 (일반 수정)</option>
                <option value="WARNING">주의 (금액 큰 폭 변경)</option>
                <option value="URGENT">긴급 (오납금 환불 등)</option>
            </select>
        </div>

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px;">카테고리</label>
            <select id="newCategory" class="form-select" style="width:100%;">
                <option value="수정">수정</option>
                <option value="추가">추가</option>
                <option value="삭제">삭제</option>
                <option value="기타">기타</option>
            </select>
        </div>

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px;">변경 내용</label>
            <textarea id="newContent" class="form-input" style="width:100%; height:80px;" placeholder="예: 105동 103호 수도요금 오기재 수정"></textarea>
        </div>

        <div style="text-align:right;">
            <button class="btn btn-secondary" onclick="closeLogModal()">취소</button>
            <button id="saveLogBtn" class="btn btn-primary" onclick="saveLog()">작성 완료</button>
        </div>
    </div>
</div>

<script src="/resources/js/fee_log.js"></script>