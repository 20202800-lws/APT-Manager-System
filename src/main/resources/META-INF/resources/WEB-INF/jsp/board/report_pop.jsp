</main> </div> <div id="reportModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3>게시물 신고</h3>
                <button type="button" class="modal-close" onclick="closeReportModal()">&times;</button>
            </div>
            <div class="modal-body">
                <p class="report-desc">신고 사유를 선택해 주세요. 부적절한 신고는 이용 제한을 받을 수 있습니다.</p>
                <div class="report-list">
                    <label class="report-item"><input type="radio" name="reportReason" value="spam"> 스팸 / 홍보성</label>
                    <label class="report-item"><input type="radio" name="reportReason" value="abuse"> 욕설 및 비하 발언</label>
                    <label class="report-item"><input type="radio" name="reportReason" value="inappropriate"> 부적절한 콘텐츠</label>
                    <label class="report-item"><input type="radio" name="reportReason" value="etc"> 기타 (사유 작성)</label>
                    <textarea id="etcReason" class="report-textarea" placeholder="상세 사유를 입력해주세요."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-modal-close" onclick="closeReportModal()">취소</button>
                <button type="button" class="btn-modal-submit" onclick="submitReport()">신고 제출</button>
            </div>
        </div>
    </div>