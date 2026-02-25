/* =========================================
   member.js - 로그인/회원가입 관련 스크립트 (통합 버전)
========================================= */

// 전역 변수: 아이디 중복 확인 통과 여부
let isIdChecked = false;

document.addEventListener('DOMContentLoaded', () => {

    /* =========================================
       1. 서버 메시지 알림 (로그인 실패/승인 대기 등)
       ========================================= */
    const serverMsg = document.getElementById('serverMsg');
    if (serverMsg && serverMsg.value.trim() !== "") {
        alert(serverMsg.value);
    }

    /* =========================================
       2. 비밀번호 실시간 검사 (정규식 포함)
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
}); // DOMContentLoaded 종료


/* =========================================
   3. 아이디 중복 체크 (Fetch API)
========================================= */
function checkId() {
    const userIdInput = document.getElementById('userId');
    if (!userIdInput) return;

    const userId = userIdInput.value.trim();

    // 1. 빈 값 및 길이 검사
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

    // ★ [추가됨] 아이디 정규식 검사 (영문과 숫자만 허용, 특수문자 차단)
    const idRegex = /^[a-zA-Z0-9]+$/;
    if (!idRegex.test(userId)) {
        alert("아이디는 영문과 숫자만 사용할 수 있습니다. (특수문자 및 공백 제외)");
        userIdInput.focus();
        return;
    }

    // 2. 백엔드로 통신 요청 (Fetch API)
    fetch('/member/checkId?userId=' + userId, {
        method: 'POST'
    })
        .then(response => response.text())
        .then(result => {
            if (result === 'DUPLICATE') {
                alert('❌ 이미 사용 중인 아이디입니다. 다른 아이디를 입력해주세요.');
                userIdInput.value = '';
                userIdInput.focus();
                isIdChecked = false;    // 깃발 내림
            } else if (result === 'AVAILABLE') {
                alert('✅ 사용 가능한 아이디입니다!');
                // 입력창을 수정 못하게 막아서 꼼수 방지
                userIdInput.readOnly = true;
                userIdInput.style.backgroundColor = '#f5f5f5';
                isIdChecked = true;     // 깃발 올림
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 통신 중 오류가 발생했습니다. 다시 시도해주세요.');
        });
}


/* =========================================
   4. 회원가입 폼 제출 전 최종 검증 (방어막)
   - JSP의 <form onsubmit="return handleSignupSubmit()"> 에서 호출됨
========================================= */
function handleSignupSubmit() {

    // [방어막 0] 아이디 정규식 재확인 (제출 직전)
    const userId = document.getElementById('userId').value.trim();
    const idRegex = /^[a-zA-Z0-9]+$/;
    if (!idRegex.test(userId)) {
        alert("아이디는 영문과 숫자만 사용할 수 있습니다.");
        document.getElementById('userId').focus();
        return false;
    }

    // [방어막 1] 아이디 중복 확인 여부 검사
    if (!isIdChecked) {
        alert("아이디 중복확인을 먼저 진행해주세요.");
        document.getElementById('userId').focus();
        return false; // 폼 전송 중단
    }

    // [방어막 2] 비밀번호 규칙 재확인
    const pw1 = document.getElementById('pw1');
    const pw2 = document.getElementById('pw2');
    const pwRegex = /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;

    if (!pwRegex.test(pw1.value)) {
        alert("비밀번호 규칙을 확인해주세요.\n(8자 이상, 영문, 숫자, 특수문자 모두 포함)");
        pw1.focus();
        return false;
    }

    // [방어막 3] 비밀번호 일치 확인
    if (pw1.value !== pw2.value) {
        alert("비밀번호가 일치하지 않습니다.");
        pw2.focus();
        return false;
    }

    // [방어막 4] 생년월일 검증
    const birth = document.getElementById("birthDate").value;
    if (birth.length !== 6) {
        alert("생년월일 6자리를 정확히 입력해주세요.");
        document.getElementById("birthDate").focus();
        return false;
    }

    // [방어막 5] 휴대전화 합치기
    const p1 = document.getElementById("phone1").value;
    const p2 = document.getElementById("phone2").value;
    const p3 = document.getElementById("phone3").value;

    if (!p1 || !p2 || !p3) {
        alert("휴대전화 번호를 모두 입력해주세요.");
        return false;
    }
    document.getElementById("fullPhone").value = p1 + "-" + p2 + "-" + p3;

    // [방어막 6] 약관 동의 확인
    const agree = document.getElementById('agree');
    if (agree && !agree.checked) {
        alert("약관에 동의해주셔야 합니다.");
        return false;
    }

    return true; // 폼 전송 진행!
}