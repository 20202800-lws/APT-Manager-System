/* * main.js
 * 시작 홈페이지(home.jsp)에서만 동작하는 스크립트
 */
document.addEventListener('DOMContentLoaded', () => {

    // [1] 이미지 슬라이더 (메인 & 섹션)
    function initImageSliders() {
        const containers = document.querySelectorAll('.image-container, .hero-slider');
        
        containers.forEach(container => {
            const imgs = container.querySelectorAll('img');
            if (imgs.length <= 1) return; 

            let currentIndex = 0;
            
            setInterval(() => {
                imgs[currentIndex].classList.remove('active');
                currentIndex = (currentIndex + 1) % imgs.length; 
                imgs[currentIndex].classList.add('active');
            }, 4000);
        });
    }

    // 슬라이더 실행
    initImageSliders();
});