/* member.js - 로그인/회원가입 관련 스크립트 */
/* member.js - 통합 버전 */

document.addEventListener('DOMContentLoaded', () => {

    /* =========================================
       1. 서버 메시지 알림 (로그인 실패/승인 대기 등)
       ========================================= */
    const serverMsg = document.getElementById('serverMsg');
    // 숨겨진 태그가 있고, 그 안에 값이 비어있지 않다면?
    if (serverMsg && serverMsg.value.trim() !== "") {
        alert(serverMsg.value); // 알림창 띄우기!
    }


    /* =========================================
       2. 로그인 폼 유효성 검사
       ========================================= */
    const loginForm = document.getElementById('loginForm');

    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            const userId = document.getElementById('userId');
            const userPw = document.getElementById('userPw');

            if (!userId.value.trim()) {
                e.preventDefault();
                alert('아이디를 입력해주세요.');
                userId.focus();
                return;
            }

            if (!userPw.value.trim()) {
                e.preventDefault();
                alert('비밀번호를 입력해주세요.');
                userPw.focus();
                return;
            }
        });
    }


    /* =========================================
       3. 회원가입 관련 로직
       ========================================= */
    
    // [아이디 중복 확인]
    // window 객체에 등록해야 HTML의 onclick="checkId()"에서 찾을 수 있음
    window.checkId = function() {
        const userIdElem = document.getElementById('userId');
        if(!userIdElem) return;

        const userId = userIdElem.value;
        if(userId.length < 4) {
            alert("아이디는 4글자 이상 입력해주세요.");
            return;
        }
        alert("사용 가능한 아이디입니다."); // 나중에 Ajax로 교체 예정
    };

    // [비밀번호 실시간 검사]
    const pw1 = document.getElementById('pw1');
    const pw2 = document.getElementById('pw2');
    const pwMsg = document.getElementById('pwMsg');
    
    // 정규식: 8자 이상, 숫자+특수문자 포함
    const pwRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;

    function validatePw() {
        if(!pw1 || !pw2) return;

        // 1. 입력 없으면 메시지 삭제
        if(pw1.value === "") {
            pwMsg.textContent = "";
            return;
        }

        // 2. 규칙 검사
        if (!pwRegex.test(pw1.value)) {
            pwMsg.textContent = "비밀번호는 8자 이상, 숫자와 특수문자를 포함해야 합니다.";
            pwMsg.style.color = "#e74c3c"; // 빨간색
            return;
        }

        // 3. 일치 검사
        if(pw2.value === "") {
            pwMsg.textContent = "비밀번호 확인을 입력해주세요.";
            pwMsg.style.color = "#666";
        } else if(pw1.value !== pw2.value) {
            pwMsg.textContent = "비밀번호가 일치하지 않습니다.";
            pwMsg.style.color = "#e74c3c";
        } else {
            pwMsg.textContent = "사용 가능한 비밀번호입니다.";
            pwMsg.style.color = "#27ae60"; // 초록색
        }
    }

    if(pw1 && pw2) {
        pw1.addEventListener('input', validatePw);
        pw2.addEventListener('input', validatePw);
    }


    // [회원가입 폼 제출 시 최종 검사]
    // ★ 주의: JSP의 form id가 "signupForm"인지 "joinForm"인지 꼭 확인하세요!
    // 아까 보여주신 JSP 코드는 id="signupForm" 이었습니다.
    const signupForm = document.getElementById('signupForm') || document.getElementById('joinForm');

    if(signupForm) {
        signupForm.addEventListener('submit', function(e) {
            
            // 1. 비밀번호 규칙 재확인
            if (!pwRegex.test(pw1.value)) {
                e.preventDefault();
                alert("비밀번호 규칙을 확인해주세요.\n(8자 이상, 숫자, 특수문자 포함)");
                pw1.focus();
                return;
            }

            // 2. 비밀번호 일치 확인
            if(pw1.value !== pw2.value) {
                e.preventDefault();
                alert("비밀번호가 서로 일치하지 않습니다.");
                pw2.focus();
                return;
            }
            
            // 3. 약관 동의 확인
            const agree = document.getElementById('agree');
            if(agree && !agree.checked) {
                e.preventDefault();
                alert("약관에 동의해주셔야 합니다.");
                return;
            }

            // 4. 휴대전화 합치기 로직 (아까 signup.jsp에 있던 것 여기로 이동 가능)
            const p1 = document.getElementById("phone1");
            const p2 = document.getElementById("phone2");
            const p3 = document.getElementById("phone3");
            const fullPhone = document.getElementById("fullPhone");

            if(p1 && p2 && p3 && fullPhone) {
                if(!p1.value || !p2.value || !p3.value) {
                    e.preventDefault();
                    alert("휴대전화 번호를 모두 입력해주세요.");
                    return;
                }
                fullPhone.value = p1.value + "-" + p2.value + "-" + p3.value;
            }

            // 여기까지 오면 전송!
            alert("회원가입 신청이 완료되었습니다.\n관리자 승인 후 이용 가능합니다.");
        });
    }
});