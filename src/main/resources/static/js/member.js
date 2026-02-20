/* member.js - 로그인 / 회원가입 / 찾기 통합본 */

document.addEventListener('DOMContentLoaded', () => {
    
    // [1] 로그인 폼 검증
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            const userId = document.getElementById('userId').value.trim();
            const userPw = document.getElementById('userPw').value.trim();
            if (!userId || !userPw) {
                e.preventDefault();
                alert('아이디와 비밀번호를 모두 입력해주세요.');
            }
        });
    }

    // [2] 회원가입 비밀번호 실시간 유효성 검사
    const pw1 = document.getElementById('pw1');
    const pw2 = document.getElementById('pw2');
    const pwMsg = document.getElementById('pwMsg');
    const pwRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;

    if (pw1 && pw2) {
        const validatePw = () => {
            if (pw1.value === "") { pwMsg.textContent = ""; return; }
            
            if (!pwRegex.test(pw1.value)) {
                pwMsg.textContent = "8자 이상, 숫자+특수문자를 포함해야 합니다.";
                pwMsg.style.color = "#ef4444";
            } else if (pw1.value !== pw2.value && pw2.value !== "") {
                pwMsg.textContent = "비밀번호가 일치하지 않습니다.";
                pwMsg.style.color = "#ef4444";
            } else if (pw1.value === pw2.value) {
                pwMsg.textContent = "사용 가능한 비밀번호입니다.";
                pwMsg.style.color = "#10b981";
            }
        };
        pw1.addEventListener('input', validatePw);
        pw2.addEventListener('input', validatePw);
    }

    // [3] 회원가입 폼 최종 전송 검증
    const joinForm = document.getElementById('joinForm');
    if (joinForm) {
        joinForm.addEventListener('submit', (e) => {
            if (!pwRegex.test(pw1.value) || pw1.value !== pw2.value) {
                e.preventDefault();
                alert("비밀번호 규칙과 일치 여부를 다시 확인해주세요.");
                pw1.focus();
                return;
            }
            if (!document.getElementById('agree').checked) {
                e.preventDefault();
                alert("약관에 동의해주셔야 합니다.");
            }
        });
    }
});

/* --- [중요] 외부 HTML(onclick)에서 접근해야 하는 함수들은 window 객체에 등록 --- */

// 테스트용 모의 데이터
const mockUser = { id: "admin", name: "홍길동", phone: "01012345678" };

// 아이디 중복 확인
window.checkId = function() {
    const userId = document.getElementById('userId').value;
    alert(userId.length >= 4 ? "사용 가능한 아이디입니다." : "아이디는 4글자 이상 입력해주세요.");
};

// 탭 전환 (아이디찾기/비번찾기)
window.openTab = function(evt, tabName) {
    const content = document.getElementsByClassName("find-content");
    for (let i = 0; i < content.length; i++) content[i].classList.remove("active");
    
    const tablinks = document.getElementsByClassName("tab-btn");
    for (let i = 0; i < tablinks.length; i++) tablinks[i].classList.remove("active");
    
    document.getElementById(tabName).classList.add("active");
    evt.currentTarget.classList.add("active");

    // 초기화 로직
    document.getElementById("find-title").innerText = (tabName === 'id-find') ? "아이디 찾기" : "비밀번호 찾기";
    document.getElementById("id-input-step").style.display = "block";
    document.getElementById("id-result-area").style.display = "none";
    document.getElementById("pw-info-step").style.display = "block";
    document.getElementById("pw-reset-step").style.display = "none";
    document.getElementById("tab-menu").style.display = "flex";
};

// 아이디 찾기 로직
window.handleFindID = function() {
    const name = document.getElementById("find-name").value;
    const phone = document.getElementById("find-phone").value;
    if (name === mockUser.name && phone === mockUser.phone) {
        document.getElementById("id-input-step").style.display = "none";
        document.getElementById("id-result-area").style.display = "block";
        document.getElementById("display-id").innerText = mockUser.id;
    } else {
        alert("정보가 일치하지 않습니다.");
    }
};

// 비밀번호 찾기 단계 1
window.handleResetPWStep1 = function() {
    const id = document.getElementById("reset-id").value;
    const name = document.getElementById("reset-name").value;
    const phone = document.getElementById("reset-phone").value;
    if (id === mockUser.id && name === mockUser.name && phone === mockUser.phone) {
        document.getElementById("pw-info-step").style.display = "none";
        document.getElementById("pw-reset-step").style.display = "block";
        document.getElementById("find-title").innerText = "비밀번호 재설정";
        document.getElementById("tab-menu").style.display = "none";
    } else {
        alert("일치하는 회원 정보가 없습니다.");
    }
};

// 비밀번호 최종 변경
window.handleFinalReset = function() {
    const pw1 = document.getElementById("new-pw").value;
    const pw2 = document.getElementById("confirm-pw").value;
    if (pw1 === pw2 && pw1 !== "") {
        alert("비밀번호 재설정이 완료되었습니다.");
        location.href = "login.html";
    } else {
        alert("비밀번호가 일치하지 않습니다.");
    }
};
/*사용자가 어떤 링크를 타고 왔느냐에 따라 자동으로 탭을 열어주는 JS 코드*/
document.addEventListener('DOMContentLoaded', () => {
    // URL 뒤에 ?tab=pw 가 있는지 확인
    const urlParams = new URLSearchParams(window.location.search);
    const tabParam = urlParams.get('tab');

    if (tabParam === 'pw') {
        // 비밀번호 찾기 탭 강제 클릭 효과
        const pwTabBtn = document.querySelector('.tab-btn:last-child');
        if(pwTabBtn) pwTabBtn.click();
    } else if (tabParam === 'id') {
        // 아이디 찾기 탭 강제 클릭 효과
        const idTabBtn = document.querySelector('.tab-btn:first-child');
        if(idTabBtn) idTabBtn.click();
    }
});