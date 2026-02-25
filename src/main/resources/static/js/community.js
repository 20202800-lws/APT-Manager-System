/* 페이지 이동 함수 
   각 JSP 페이지에서 탭 버튼 클릭 시 호출됩니다.
*/
function goPage(pageName) {
    location.href = pageName;
}

// 현재 페이지에 맞는 탭 활성화 (혹시 HTML에서 class="active"가 누락되었을 경우를 대비한 안전장치)
document.addEventListener("DOMContentLoaded", function() {
    const path = location.pathname;
    const tabs = document.querySelectorAll('.tab-btn');
    
    // 모든 탭의 active 제거
    // HTML에서 직접 active를 지정하므로 이 부분은 보조적인 역할입니다.
	tabs.forEach(tab => {
	     const target = tab.getAttribute('onclick').match(/'([^']+)'/)[1];
	     if (path.includes(target)) {
	         tabs.forEach(t => t.classList.remove('active'));
	         tab.classList.add('active');
	     }
	 });
});

