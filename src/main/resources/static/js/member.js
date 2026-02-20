/* member.js - 로그인/회원가입 관련 스크립트 */

document.addEventListener('DOMContentLoaded', () => {
    
    const loginForm = document.getElementById('loginForm');

    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            const userId = document.getElementById('userId').value.trim();
            const userPw = document.getElementById('userPw').value.trim();

            if (!userId) {
                e.preventDefault(); // 전송 막기
                alert('아이디를 입력해주세요.');
                document.getElementById('userId').focus();
                return;
            }

            if (!userPw) {
                e.preventDefault();
                alert('비밀번호를 입력해주세요.');
                document.getElementById('userPw').focus();
                return;
            }
            
            // 여기에 나중에 Ajax 로그인 코드가 들어갈 수도 있습니다.
        });
    }
});


/* member.js - 회원가입 유효성 검사 (업그레이드 버전) */

document.addEventListener('DOMContentLoaded', () => {
    
    // [1] 아이디 중복 확인 (모의 기능)
    window.checkId = function() {
        const userId = document.getElementById('userId').value;
        if(userId.length < 4) {
            alert("아이디는 4글자 이상 입력해주세요.");
            return;
        }
        alert("사용 가능한 아이디입니다.");
    };

    // [2] 비밀번호 복합성 검사 (핵심!)
    const pw1 = document.getElementById('pw1');
    const pw2 = document.getElementById('pw2');
    const pwMsg = document.getElementById('pwMsg');

    if(pw1 && pw2) {
        
        // ★ 정규표현식: 8자 이상, 숫자 1개 이상, 특수문자 1개 이상 포함
        const pwRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;

        function validatePw() {
            // 1. 아무것도 입력 안 했을 때
            if(pw1.value === "") {
                pwMsg.textContent = "";
                return;
            }

            // 2. 비밀번호 규칙(8자, 숫자, 특수문자) 검사
            if (!pwRegex.test(pw1.value)) {
                pwMsg.textContent = "비밀번호는 8자 이상, 숫자와 특수문자를 포함해야 합니다.";
                pwMsg.style.color = "#e74c3c"; // 빨간색
                return; // 규칙 틀리면 여기서 중단 (일치 여부는 볼 필요도 없음)
            }

            // 3. 비밀번호 일치 검사 (규칙 통과한 경우에만 실행)
            if(pw2.value === "") {
                pwMsg.textContent = "비밀번호 확인을 입력해주세요.";
                pwMsg.style.color = "#666";
            } else if(pw1.value !== pw2.value) {
                pwMsg.textContent = "비밀번호가 일치하지 않습니다.";
                pwMsg.style.color = "#e74c3c"; // 빨간색
            } else {
                pwMsg.textContent = "사용 가능한 비밀번호입니다.";
                pwMsg.style.color = "#27ae60"; // 초록색
            }
        }

        // 입력할 때마다 실시간 검사
        pw1.addEventListener('input', validatePw);
        pw2.addEventListener('input', validatePw);
    }

    // [3] 가입 버튼 눌렀을 때 최종 검사
    const joinForm = document.getElementById('joinForm');
    if(joinForm) {
        joinForm.addEventListener('submit', function(e) {
            
            // 정규표현식 재정의 (스코프 때문)
            const pwRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;

            // 1. 규칙 검사
            if (!pwRegex.test(pw1.value)) {
                e.preventDefault();
                alert("비밀번호 규칙을 확인해주세요.\n(8자 이상, 숫자, 특수문자 포함)");
                pw1.focus();
                return;
            }

            // 2. 일치 검사
            if(pw1.value !== pw2.value) {
                e.preventDefault();
                alert("비밀번호가 서로 일치하지 않습니다.");
                pw2.focus();
                return;
            }
            
            // 3. 약관 동의 확인
            const agree = document.getElementById('agree');
            if(!agree.checked) {
                e.preventDefault();
                alert("약관에 동의해주셔야 합니다.");
                return;
            }

            alert("회원가입 신청이 완료되었습니다.\n관리자 승인 후 이용 가능합니다.");
        });
    }
});


