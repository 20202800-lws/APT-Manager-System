/* * common.js
 * 모든 페이지에 공통으로 적용되는 스크립트 (헤더, 푸터, 유틸리티 등)
 */
document.addEventListener('DOMContentLoaded', () => {
    
    // [1] 헤더 스크롤 효과
    const header = document.getElementById('mainHeader');
    
    // header가 있는 페이지에서만 동작하도록 방어 코드 추가 (if문)
    if (header) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    }
});