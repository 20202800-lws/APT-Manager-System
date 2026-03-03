/* 게시물 신고  report_pop.js*/

/* =========================================
   /js/board/report.js - 공통 신고 기능
   ========================================= */

// [1] 모달 열기
window.openReportModal = function() {
    const modal = document.getElementById('reportModal');
    if (modal) modal.style.display = 'flex';
};

// [2] 모달 닫기 및 초기화
window.closeReportModal = function() {
    const modal = document.getElementById('reportModal');
    const etcArea = document.getElementById('etcReason');
    if (modal) modal.style.display = 'none';
    if (etcArea) {
        etcArea.value = '';
        etcArea.style.display = 'none';
    }
    // 라디오 버튼 선택 해제
    const reasons = document.querySelectorAll('input[name="reportReason"]');
    reasons.forEach(r => r.checked = false);
};

// [3] 기타 사유 입력창 제어 (이벤트 위임 활용)
document.addEventListener('change', (e) => {
    if (e.target.name === 'reportReason') {
        const etcArea = document.getElementById('etcReason');
        if (etcArea) {
            etcArea.style.display = (e.target.value === 'etc') ? 'block' : 'none';
        }
    }
});

// [4] 신고 제출 로직
window.submitReport = function() {
    const selected = document.querySelector('input[name="reportReason"]:checked');
    if (!selected) return alert("신고 사유를 선택해 주세요.");

    const reason = selected.value;
    const detail = document.getElementById('etcReason').value.trim();

    if (reason === 'etc' && !detail) {
        return alert("상세 신고 사유를 입력해 주세요.");
    }

    // 서버 전송 로직 대신 알림 처리
    alert("신고가 접수되었습니다. 운영진이 확인 후 조치하겠습니다.");
    window.closeReportModal();
};
