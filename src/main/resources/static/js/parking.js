/**
 * parking.js 
 * JSTL 연동 완료 - 모달 제어용
 */

function openModal() {
    document.getElementById('parkingModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('parkingModal').style.display = 'none';
}

// 모달 외부 클릭 시 닫기 기능
window.onclick = function(event) {
    const modal = document.getElementById('parkingModal');
    if (event.target === modal) {
        closeModal();
    }
}
// 전화번호 자동 하이픈 (-) 생성 로직
document.addEventListener('input', function(e) {
    if (e.target && e.target.name === 'phone') {
        let val = e.target.value.replace(/[^0-9]/g, ''); // 숫자만 남기기
        if (val.length > 3 && val.length <= 7) {
            val = val.replace(/(\d{3})(\d+)/, '$1-$2');
        } else if (val.length > 7) {
            // 010-1234-5678 형태 (최대 11자리 기준)
            val = val.replace(/(\d{3})(\d{3,4})(\d{4})/, '$1-$2-$3');
        }
        e.target.value = val;
    }
});