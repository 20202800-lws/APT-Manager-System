<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>아이디/비밀번호 찾기 | APARTNERS</title>
		<link rel="stylesheet" as="style" crossorigin
			href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
		<link rel="stylesheet" href="/css/layout.css">
		<link rel="stylesheet" href="/css/member.css">
	</head>

	<body>

		<jsp:include page="../layout/header_auth.jsp" />

		<div class="find-wrapper">
			<h1 class="find-title" id="find-title">아이디 찾기</h1>

			<div class="tab-menu" id="tab-menu">
				<div class="tab-btn active" id="btn-tab-id" onclick="openTab(event, 'id-find')">아이디 찾기</div>
				<div class="tab-btn" id="btn-tab-pw" onclick="openTab(event, 'pw-find')">비밀번호 찾기</div>
			</div>

			<div id="id-find" class="find-content active">
				<div id="id-input-step">
					<div class="input-group"><input type="text" id="find-name" placeholder="이름" required></div>
					<div class="input-group"><input type="text" id="find-phone" placeholder="휴대폰 번호 (- 자동입력)"
							maxlength="13" oninput="formatPhone(this)" required></div>
					<div class="btn-area">
						<button class="btn-action" onclick="handleFindID()">아이디 찾기</button>
						<a href="/member/login" class="btn-back">로그인</a>
						<a href="/member/signup" class="btn-back">회원가입</a>
					</div>
				</div>

				<div id="id-result-area" class="result-box"
					style="display:none; text-align: center; padding: 30px; border: 1px solid #ddd; border-radius: 8px; margin-top: 20px;">
					<p style="color:#666; margin-bottom: 10px;">일치하는 아이디입니다.</p>
					<div class="result-id" id="display-id"
						style="font-size: 24px; font-weight: bold; color: var(--primary-color); margin-bottom: 20px;">
					</div>
					<div class="btn-area">
						<a href="/member/login" class="btn-action"
							style="display:flex; align-items:center; justify-content:center; text-decoration:none;">로그인하기</a>
					</div>
				</div>
			</div>

			<div id="pw-find" class="find-content">
				<div id="pw-info-step">
					<div class="input-group"><input type="text" id="reset-id" placeholder="아이디" required></div>
					<div class="input-group"><input type="text" id="reset-name" placeholder="이름" required></div>
					<div class="input-group"><input type="text" id="reset-phone" placeholder="휴대폰 번호 (- 자동입력)"
							maxlength="13" oninput="formatPhone(this)" required></div>
					<div class="btn-area">
						<button class="btn-action" onclick="handleResetPWStep1()">비밀번호 재설정</button>
						<a href="/member/login" class="btn-back">로그인</a>
					</div>
				</div>

				<div id="pw-reset-step" style="display:none; text-align: center;">
					<p style="margin-bottom:20px; font-weight:600; color:#555;">본인 인증이 완료되었습니다.<br>새로운 비밀번호를 입력해주세요.</p>
					<div class="input-group"><input type="password" id="new-pw" placeholder="새 비밀번호"></div>
					<div class="input-group"><input type="password" id="confirm-pw" placeholder="새 비밀번호 확인"></div>
					<div class="btn-area">
						<button class="btn-action" onclick="handleFinalReset()">변경 완료</button>
					</div>
				</div>
			</div>
		</div>

		<jsp:include page="../layout/footer.jsp" />

		<script>
			// 1. 탭 전환 기능
			function openTab(evt, tabName) {
				document.querySelectorAll('.find-content').forEach(el => el.classList.remove('active'));
				document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
				document.getElementById(tabName).classList.add('active');
				evt.currentTarget.classList.add('active');
				document.getElementById('find-title').innerText = evt.currentTarget.innerText;
			}

			// 2. 전화번호 자동 하이픈 기능
			function formatPhone(target) {
				let str = target.value.replace(/[^0-9]/g, '');
				let tmp = '';
				if (str.length < 4) tmp = str;
				else if (str.length < 7) tmp = str.substr(0, 3) + '-' + str.substr(3);
				else if (str.length < 11) tmp = str.substr(0, 3) + '-' + str.substr(3, 3) + '-' + str.substr(6);
				else tmp = str.substr(0, 3) + '-' + str.substr(3, 4) + '-' + str.substr(7, 4);
				target.value = tmp;
			}

			// 3. 아이디 찾기 API 호출
			function handleFindID() {
				const name = document.getElementById('find-name').value;
				const phone = document.getElementById('find-phone').value;
				if (!name || !phone) {alert("이름과 전화번호를 입력해주세요."); return;}

				const formData = new URLSearchParams();
				formData.append('userName', name);
				formData.append('phone', phone);

				fetch('/member/api/find_id', {
					method: 'POST',
					headers: {'Content-Type': 'application/x-www-form-urlencoded'},
					body: formData
				}).then(res => res.json()).then(data => {
					if (data.status === 'success') {
						document.getElementById('id-input-step').style.display = 'none';
						document.getElementById('id-result-area').style.display = 'block';
						document.getElementById('display-id').innerText = data.userId;
					} else {
						alert(data.msg);
					}
				});
			}

			// 4. 비밀번호 재설정 인증 API 호출
			let verifiedUserId = '';
			function handleResetPWStep1() {
				const id = document.getElementById('reset-id').value;
				const name = document.getElementById('reset-name').value;
				const phone = document.getElementById('reset-phone').value;
				if (!id || !name || !phone) {alert("모든 정보를 입력해주세요."); return;}

				const formData = new URLSearchParams();
				formData.append('userId', id);
				formData.append('userName', name);
				formData.append('phone', phone);

				fetch('/member/api/verify_account', {
					method: 'POST',
					headers: {'Content-Type': 'application/x-www-form-urlencoded'},
					body: formData
				}).then(res => res.json()).then(data => {
					if (data.status === 'success') {
						verifiedUserId = id; // 인증된 아이디 저장
						document.getElementById('pw-info-step').style.display = 'none';
						document.getElementById('pw-reset-step').style.display = 'block';
					} else {
						alert(data.msg);
					}
				});
			}

			// 5. 새 비밀번호 덮어쓰기 API 호출 (정규식 및 일치 검증 추가!)
			function handleFinalReset() {
				const pw1 = document.getElementById('new-pw').value;
				const pw2 = document.getElementById('confirm-pw').value;

				// (1) 빈칸 검사
				if (!pw1 || !pw2) {
					alert("새로운 비밀번호를 입력해주세요.");
					return;
				}

				// (2) 비밀번호 강도 검사 (영문, 숫자, 특수문자 포함 8자 이상)
				const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&~^])[A-Za-z\d@$!%*#?&~^]{8,}$/;
				if (!pwRegex.test(pw1)) {
					alert("비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.");
					document.getElementById('new-pw').focus();
					return;
				}

				// (3) 비밀번호 일치 검사
				if (pw1 !== pw2) {
					alert("새 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
					document.getElementById('confirm-pw').focus();
					return;
				}

				// 모든 검증 통과 시 백엔드로 전송
				const formData = new URLSearchParams();
				formData.append('userId', verifiedUserId);
				formData.append('newPw', pw1);

				fetch('/member/api/reset_pw', {
					method: 'POST',
					headers: {'Content-Type': 'application/x-www-form-urlencoded'},
					body: formData
				}).then(res => res.json()).then(data => {
					if (data.status === 'success') {
						alert("비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요!");
						location.href = '/member/login';
					} else {
						alert("비밀번호 변경 중 오류가 발생했습니다.");
					}
				});
			}
		</script>
	</body>

	</html>