
    <h3 style="margin-bottom:20px;">게시글 보기</h3>
    <div class="content-box">
        <div style="text-align:right; margin-top:30px; border-top:1px solid #eee; padding-top:20px;">
            <button class="btn-sub" onclick="showList()">목록으로</button>
            
            <button class="btn-danger" style="margin-left:5px; background-color:#ff9800; border-color:#ff9800;" onclick="openReportModal()">🚨 신고</button>
            
            <span id="myButtons">
                <button class="btn-main" style="margin-left:5px;">수정</button>
                <button class="btn-danger" onclick="deletePost()" style="margin-left:5px;">삭제</button>
            </span>
        </div>
    </div>
</div>

<div class="modal-overlay" id="reportModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:2000; align-items:center; justify-content:center;">
    <div class="modal-content" style="background:#fff; width:450px; padding:30px; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.2);">
        <div style="display:flex; justify-content:space-between; margin-bottom:20px; align-items:center;">
            <h3 style="margin:0; color:#e74c3c;">🚨 부적절한 게시물 신고</h3>
            <button onclick="closeReportModal()" style="border:none; background:none; font-size:24px; cursor:pointer; color:#888;">&times;</button>
        </div>
        
        <div class="form-group" style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:8px; font-size:14px; font-weight:600;">신고 사유</label>
            <select id="reportReason" style="width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; outline:none;">
                <option value="스팸/홍보성">스팸/홍보성 도배글</option>
                <option value="욕설/혐오">욕설 및 혐오 발언</option>
                <option value="음란물">음란물 또는 부적절한 내용</option>
                <option value="개인정보 노출">개인정보 노출</option>
                <option value="기타">기타 (상세 내용 작성)</option>
            </select>
        </div>
        
        <div class="form-group" style="margin-bottom:25px;">
            <label style="display:block; margin-bottom:8px; font-size:14px; font-weight:600;">상세 내용 (필수)</label>
            <textarea id="reportDetail" rows="4" style="width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; resize:none; outline:none;" placeholder="관리자가 확인할 수 있도록 신고 내용을 상세히 적어주세요."></textarea>
        </div>
        
        <div style="text-align:right;">
            <button class="btn-sub" onclick="closeReportModal()">취소</button>
            <button class="btn-danger" onclick="submitReport()" style="margin-left:5px;">신고 접수</button>
        </div>
    </div>
</div>
<script>
    // 1. 모달창 열기
    function openReportModal() {
        document.getElementById('reportModal').style.display = 'flex';
    }

    // 2. 모달창 닫기 (입력했던 내용도 싹 초기화)
    function closeReportModal() {
        document.getElementById('reportModal').style.display = 'none';
        document.getElementById('reportDetail').value = ''; 
        document.getElementById('reportReason').selectedIndex = 0;
    }

    // 3. 백엔드로 신고 데이터 전송 (AJAX)
    function submitReport() {
        const reason = document.getElementById('reportReason').value;
        const detail = document.getElementById('reportDetail').value.trim();
        
        // JSP EL 태그를 이용해 현재 보고 있는 게시글의 ID를 가져옴
        // (주의: 상세 보기 화면에서 전달받은 객체 이름이 viewBean이 맞는지 확인 필요!)
        const boardId = '${viewBean.boardId}'; 

        if (!detail) {
            alert('관리자가 확인할 수 있도록 상세 내용을 입력해주세요.');
            document.getElementById('reportDetail').focus();
            return;
        }

        if (!confirm('정말 이 게시글을 신고하시겠습니까?\n(허위 신고 시 활동에 불이익을 받을 수 있습니다.)')) {
            return;
        }

        // 서버로 보낼 택배 상자(JSON) 조립
        const reportData = {
            boardId: boardId,
            reason: reason,
            detail: detail
        };

        fetch('/board/report', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(reportData)
        })
        .then(response => {
            if (!response.ok) {
                // 백엔드에서 에러 메시지(예: "이미 신고한 글입니다")를 던지면 캐치
                return response.text().then(text => { throw new Error(text) });
            }
            return response.text();
        })
        .then(data => {
            alert('신고가 정상적으로 접수되었습니다. 깨끗한 커뮤니티를 위한 노력에 감사드립니다!');
            closeReportModal();
        })
        .catch(error => {
            alert(error.message || '신고 처리 중 서버 오류가 발생했습니다.');
        });
    }
</script>