/* =========================================================
   아파트 소개 - 평면도 전환 로직 (intro.js)
   ========================================================= */

const planData = {
    // ★ 실제 파일 위치가 /images/intro/ 라면 intro로, /images/logo/ 라면 logo로 수정하세요.
    '59A': { img: '/images/logo/59A.png', title: '59㎡ A TYPE' },
    '59B': { img: '/images/logo/59B.png', title: '59㎡ B TYPE' },
    '84A': { img: '/images/logo/84A.png', title: '84㎡ A TYPE' },
    '84B': { img: '/images/logo/84B.png', title: '84㎡ B TYPE' },
    '84C': { img: '/images/logo/84C.png', title: '84㎡ C TYPE' }
};

function changePlan(type, btn) {
    const imgEl = document.getElementById('planImg');
    const titleEl = document.getElementById('planTitle');
    
    // 안전한 실행을 위한 방어 코드 추가
    if (!imgEl || !titleEl || !planData[type]) return;

    // 1. 이미지 및 타이틀 텍스트 변경
    imgEl.src = planData[type].img;
    titleEl.innerText = planData[type].title;
    
    // 2. 버튼 활성화(active) 클래스 교체
    document.querySelectorAll('.type-btn').forEach(b => b.classList.remove('active'));
    if (btn) {
        btn.classList.add('active');
    }
}

// (선택 사항) 페이지 로드 시 초기 이미지 세팅 확인을 위해 추가할 수 있습니다.
document.addEventListener('DOMContentLoaded', () => {
    const imgEl = document.getElementById('planImg');
    if (imgEl && imgEl.src.includes('unsplash')) {
        // JSP에서 초기 이미지가 Unsplash라면 59A 데이터로 강제 초기화
        changePlan('59A', document.querySelector('.type-btn.active'));
    }
});