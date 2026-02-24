document.addEventListener('DOMContentLoaded', () => {
    
    // 1. 헤더 스크롤 효과
    const header = document.getElementById('mainHeader');
    
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });

    // 2. 이미지 슬라이더 (메인 & 섹션)
    function initImageSliders() {
        // .image-container와 .hero-slider 클래스를 가진 모든 요소를 찾음
        const containers = document.querySelectorAll('.image-container, .hero-slider');
        
        containers.forEach(container => {
            const imgs = container.querySelectorAll('img');
            if (imgs.length <= 1) return; // 이미지가 1개면 슬라이드 안 함

            let currentIndex = 0;
            
            // 4초마다 이미지 변경 (hero는 CSS transition 시간이 길어서 부드러움)
            setInterval(() => {
                imgs[currentIndex].classList.remove('active');
                currentIndex = (currentIndex + 1) % imgs.length; // 다음 인덱스 (끝나면 0으로)
                imgs[currentIndex].classList.add('active');
            }, 4000);
        });
    }

    // 슬라이더 시작
    initImageSliders();
});

