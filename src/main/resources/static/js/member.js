/* =========================================
   member.js - 로그인 / 회원가입 / 계정 찾기 통합본
========================================= */

// 전역 변수: 아이디 중복 확인 통과 여부
let isIdChecked = false;

// [테스트용 가짜 데이터] 백엔드 연동 전 아이디/비밀번호 찾기 테스트용
const mockUser = { id: "admin", name: "홍길동", phone: "01012345678" };

document.addEventListener('DOMContentLoaded', () => {

    /* =========================================
       1. 서버 메시지 알림 (로그인 실패/승인 대기 등)
       ========================================= */
    const serverMsg = document.getElementById('serverMsg');
    if (serverMsg && serverMsg.value.trim() !== "") {
        alert(serverMsg.value);
    }

    /* =========================================
       2. 로그인 폼 빈 값 검증 (담당자 추가 로직)
       ========================================= */
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

    /* =========================================
       3. 회원가입: 비밀번호 실시간 검사 (선배님 강력한 정규식 보존)
       ========================================= */
    const pw1 = document.getElementById('pw1');
    const pw2 = document.getElementById('pw2');
    const pwMsg = document.getElementById('pwMsg');
    
    // 정규식: 8자 이상, 영문 + 숫자 + 특수문자 모두 포함 강제
    const pwRegex = /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;

    function validatePw() {
        if (!pw1 || !pw2 || !pwMsg) return;

        // 1. 입력 없으면 메시지 삭제
        if (pw1.value === "") {
            pwMsg.textContent = "";
            return;
        }

        // 2. 규칙 검사
        if (!pwRegex.test(pw1.value)) {
            pwMsg.textContent = "비밀번호는 8자 이상, 영문, 숫자, 특수문자를 모두 포함해야 합니다.";
            pwMsg.style.color = "#e74c3c"; // 빨간색
            return;
        }

        // 3. 일치 검사
        if (pw2.value === "") {
            pwMsg.textContent = "비밀번호 확인을 입력해주세요.";
            pwMsg.style.color = "#666";
        } else if (pw1.value !== pw2.value) {
            pwMsg.textContent = "비밀번호가 일치하지 않습니다.";
            pwMsg.style.color = "#e74c3c";
        } else {
            pwMsg.textContent = "사용 가능한 비밀번호입니다.";
            pwMsg.style.color = "#27ae60"; // 초록색
        }
    }

    if (pw1 && pw2) {
        pw1.addEventListener('input', validatePw);
        pw2.addEventListener('input', validatePw);
    }

    /* =========================================
       4. 찾기 화면: 탭 파라미터 자동 인식 (URL?tab=pw)
       ========================================= */
    const urlParams = new URLSearchParams(window.location.search);
    const tabParam = urlParams.get('tab');

    if (tabParam === 'pw') {
        const pwTabBtn = document.querySelector('.tab-btn:last-child');
        if(pwTabBtn) pwTabBtn.click();
    } else if (tabParam === 'id') {
        const idTabBtn = document.querySelector('.tab-btn:first-child');
        if(idTabBtn) idTabBtn.click();
    }

}); // DOMContentLoaded 종료


/* =========================================
   5. 회원가입: 아이디 중복 체크 (Fetch API - 선배님 코드 100% 보존)
========================================= */
function checkId() {
    const userIdInput = document.getElementById('userId');
    if (!userIdInput) return;

    const userId = userIdInput.value.trim();

    if (userId === '') {
        alert('아이디를 먼저 입력해주세요.');
        userIdInput.focus();
        return;
    }
    if (userId.length < 6) {
        alert("아이디는 6글자 이상 입력해주세요.");
        userIdInput.focus();
        return;
    }

    const idRegex = /^[a-zA-Z0-9]+$/;
    if (!idRegex.test(userId)) {
        alert("아이디는 영문과 숫자만 사용할 수 있습니다. (특수문자 및 공백 제외)");
        userIdInput.focus();
        return;
    }

    // 백엔드로 통신 요청
    fetch('/member/checkId?userId=' + userId, { method: 'POST' })
        .then(response => response.text())
        .then(result => {
            if (result === 'DUPLICATE') {
                alert('❌ 이미 사용 중인 아이디입니다. 다른 아이디를 입력해주세요.');
                userIdInput.value = '';
                userIdInput.focus();
                isIdChecked = false;
            } else if (result === 'AVAILABLE') {
                alert('✅ 사용 가능한 아이디입니다!');
                userIdInput.readOnly = true;
                userIdInput.style.backgroundColor = '#f5f5f5';
                isIdChecked = true;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 통신 중 오류가 발생했습니다. 다시 시도해주세요.');
        });
}

/* =========================================
   6. 회원가입: 폼 제출 전 최종 검증 (방어막 - 선배님 코드 보존)
========================================= */
function handleSignupSubmit() {
    const userId = document.getElementById('userId').value.trim();
    const idRegex = /^[a-zA-Z0-9]+$/;
    if (!idRegex.test(userId)) {
        alert("아이디는 영문과 숫자만 사용할 수 있습니다.");
        document.getElementById('userId').focus();
        return false;
    }

    if (!isIdChecked) {
        alert("아이디 중복확인을 먼저 진행해주세요.");
        document.getElementById('userId').focus();
        return false;
    }

    const pw1 = document.getElementById('pw1');
    const pw2 = document.getElementById('pw2');
    const pwRegex = /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;

    if (!pwRegex.test(pw1.value)) {
        alert("비밀번호 규칙을 확인해주세요.\n(8자 이상, 영문, 숫자, 특수문자 모두 포함)");
        pw1.focus();
        return false;
    }

    if (pw1.value !== pw2.value) {
        alert("비밀번호가 일치하지 않습니다.");
        pw2.focus();
        return false;
    }

    const birth = document.getElementById("birthDate").value;
    if (birth && birth.length !== 6) {
        alert("생년월일 6자리를 정확히 입력해주세요.");
        document.getElementById("birthDate").focus();
        return false;
    }

    const p1 = document.getElementById("phone1") ? document.getElementById("phone1").value : "";
    const p2 = document.getElementById("phone2") ? document.getElementById("phone2").value : "";
    const p3 = document.getElementById("phone3") ? document.getElementById("phone3").value : "";

    if (!p1 || !p2 || !p3) {
        alert("휴대전화 번호를 모두 입력해주세요.");
        return false;
    }
    document.getElementById("fullPhone").value = p1 + "-" + p2 + "-" + p3;

    const agree = document.getElementById('agree');
    if (agree && !agree.checked) {
        alert("약관에 동의해주셔야 합니다.");
        return false;
    }

    return true; 
}


/* =========================================
   7. 아이디/비밀번호 찾기 로직 (담당자 추가 부분)
========================================= */

// 탭 전환 로직
function openTab(evt, tabName) {
    const content = document.getElementsByClassName("find-content");
    for (let i = 0; i < content.length; i++) content[i].classList.remove("active");
    
    const tablinks = document.getElementsByClassName("tab-btn");
    for (let i = 0; i < tablinks.length; i++) tablinks[i].classList.remove("active");
    
    document.getElementById(tabName).classList.add("active");
    evt.currentTarget.classList.add("active");

    const findTitle = document.getElementById("find-title");
    if(findTitle) findTitle.innerText = (tabName === 'id-find') ? "아이디 찾기" : "비밀번호 찾기";
    
    const idInput = document.getElementById("id-input-step");
    if(idInput) {
        idInput.style.display = "block";
        document.getElementById("id-result-area").style.display = "none";
        document.getElementById("pw-info-step").style.display = "block";
        document.getElementById("pw-reset-step").style.display = "none";
        document.getElementById("tab-menu").style.display = "flex";
    }
}

// 아이디 찾기 (가짜 데이터 연동)
function handleFindID() {
    const name = document.getElementById("find-name").value;
    const phone = document.getElementById("find-phone").value;
    
    // TODO: 실제로는 백엔드 Fetch API 연동 필요
    if (name === mockUser.name && phone === mockUser.phone) {
        document.getElementById("id-input-step").style.display = "none";
        document.getElementById("id-result-area").style.display = "block";
        document.getElementById("display-id").innerText = mockUser.id;
    } else {
        alert("정보가 일치하지 않습니다.");
    }
}

// 비밀번호 찾기 (가짜 데이터 연동)
function handleResetPWStep1() {
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
}

// 비밀번호 최종 변경
function handleFinalReset() {
    const pw1 = document.getElementById("new-pw").value;
    const pw2 = document.getElementById("confirm-pw").value;
    
    if (pw1 === pw2 && pw1 !== "") {
        alert("비밀번호 재설정이 완료되었습니다.");
        // 수정: login.html -> 스프링 MVC 주소인 /member/login 으로 변경
        location.href = "/member/login"; 
    } else {
        alert("비밀번호가 일치하지 않습니다.");
    }
}