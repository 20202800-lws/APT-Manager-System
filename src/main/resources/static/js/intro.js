/*아파트 소개 */

const planData = {
    // 로컬 폴더(/images/logo/) 내의 실제 파일명과 정확히 매칭했습니다.
    '59A': { img: '/images/logo/59A.png', title: '59㎡ A TYPE' },
    '59B': { img: '/images/logo/59B.png', title: '59㎡ B TYPE' },
    '84A': { img: '/images/logo/84A.png', title: '84㎡ A TYPE' },
    '84B': { img: '/images/logo/84B.png', title: '84㎡ B TYPE' },
    '84C': { img: '/images/logo/84C.png', title: '84㎡ C TYPE' }
};

function changePlan(type, btn) {
    const imgEl = document.getElementById('planImg');
    const titleEl = document.getElementById('planTitle');
    
    if (imgEl && titleEl) {
        imgEl.src = planData[type].img;
        titleEl.innerText = planData[type].title;
        
        document.querySelectorAll('.type-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }
}