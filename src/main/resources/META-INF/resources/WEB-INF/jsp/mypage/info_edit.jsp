<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>마이페이지 - 정보수정</title>
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
			<link rel="stylesheet" href="/css/layout.css">
			<link rel="stylesheet" href="/css/mypage.css">
		</head>

		<body>
			<jsp:include page="../layout/header_intro.jsp">
				<jsp:param name="pageTitle" value="마이페이지" />
			</jsp:include>

			<div class="page-wrapper" style="min-height: calc(100vh - 80px);">

				<jsp:include page="../layout/sidebar_mypage.jsp">
					<jsp:param name="activeMenu" value="info_edit" />
				</jsp:include>

				<main class="content-area">
					<div class="page-header">
						<h2>정보 수정</h2>
					</div>

					<div style="margin-top: 20px; max-width: 600px; margin-left: auto; margin-right: auto;">

						<form action="/mypage/info_edit" method="post" enctype="multipart/form-data" class="edit-form"
							onsubmit="return validateEditForm()">

							<div class="profile-section" style="text-align: center; margin-bottom: 30px;">
								<div class="photo-box" id="imagePreview"
									style="margin: 0 auto 15px auto; width: 120px; height: 120px; border-radius: 50%; border: 2px solid #eee; display: flex; align-items: center; justify-content: center; overflow: hidden;">
									<img src="${empty loginMember.profileImg ? '/images/default_profile.png' : loginMember.profileImg}"
										style="width:100%; height:100%; object-fit:cover;" alt="프로필">
								</div>
								<label for="fileInput" class="file-label"
									style="cursor: pointer; color: var(--primary-color); font-weight: bold;">사진
									변경</label>
								<input type="file" id="fileInput" name="profileFile" accept="image/*"
									style="display:none;">
							</div>

							<p style="font-size:14px; font-weight:600; margin-bottom:8px;">비밀번호 변경</p>
							<input type="password" name="currentPw" class="input-box" placeholder="현재 비밀번호"
								style="width: 100%; margin-bottom: 10px; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
							<input type="password" name="newPw" class="input-box" placeholder="새 비밀번호"
								style="width: 100%; margin-bottom: 10px; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
							<input type="password" name="newPwConfirm" class="input-box" placeholder="새 비밀번호 확인"
								style="width: 100%; margin-bottom: 25px; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">

							<p style="font-size:14px; font-weight:600; margin-bottom:8px;">전화번호 변경</p>
							<div class="flex-row" style="display: flex; gap: 10px; margin-bottom: 25px;">
								<input type="text" id="phoneInput" name="phone" value="${loginMember.phone}"
									class="input-box" placeholder="010-0000-0000" maxlength="13"
									style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
							</div>

							<p style="font-size:14px; font-weight:600; margin-bottom:8px;">이메일 주소</p>
							<div class="flex-row" style="display: flex; gap: 10px; margin-bottom: 30px;">
								<input type="text" id="emailInput" name="email" value="${loginMember.email}"
									class="input-box" placeholder="example@naver.com"
									style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
							</div>

							<p style="font-size:14px; font-weight:600; margin-bottom:8px;">거주 정보</p>
							<div class="flex-row" style="display: flex; gap: 10px; margin-bottom: 30px;">
								<input type="text" name="dong" value="${loginMember.dong}" class="input-box" readonly
									style="flex:1; padding: 10px; border: 1px solid #ddd; border-radius: 5px; background-color: #f5f5f5;">
								<input type="text" name="ho" value="${loginMember.ho}" class="input-box" readonly
									style="flex:1; padding: 10px; border: 1px solid #ddd; border-radius: 5px; background-color: #f5f5f5;">
							</div>

							<button type="submit" class="btn-submit"
								style="width: 100%; padding: 15px; background: var(--primary-color, #1a0b2e); color: white; border: none; border-radius: 5px; font-size: 16px; font-weight: bold; cursor: pointer;">수정
								내용 저장</button>
						</form>
					</div>
				</main>
			</div>

			<jsp:include page="../layout/footer.jsp" />
			<script src="/js/mypage.js"></script>

			<script>
				// ★ 1. 전화번호 입력 시 자동으로 숫자만 남기고 하이픈(-) 추가 로직
				document.getElementById('phoneInput').addEventListener('input', function (e) {
					let str = this.value.replace(/[^0-9]/g, ''); // 숫자 이외의 문자 제거
					let tmp = '';

					if (str.length < 4) {
						tmp = str;
					} else if (str.length < 7) {
						tmp = str.substr(0, 3) + '-' + str.substr(3);
					} else if (str.length < 11) {
						tmp = str.substr(0, 3) + '-' + str.substr(3, 3) + '-' + str.substr(6);
					} else {
						tmp = str.substr(0, 3) + '-' + str.substr(3, 4) + '-' + str.substr(7, 4);
					}
					this.value = tmp;
				});

				// ★ 2. 폼 전송 전 이메일/전화번호 형식 완벽 검증!
				function validateEditForm() {
					const email = document.getElementById('emailInput').value;
					const phone = document.getElementById('phoneInput').value;

					// 전화번호 검증 (하이픈 포함 12~13자리)
					if (phone && phone.length < 12) {
						alert("올바른 전화번호를 입력해주세요. (예: 010-1234-5678)");
						document.getElementById('phoneInput').focus();
						return false;
					}

					// ★ 이메일 정규식 검증 강화! (com, net, org, kr, co.kr 등 명확한 도메인만 허용)
					// naver.co 처럼 쓰면 통과하지 못합니다!
					const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.(com|net|org|kr|co\.kr|go\.kr|ac\.kr)$/i;

					if (email && !emailRegex.test(email)) {
						alert("유효하지 않은 이메일 형식입니다.\n(예: example@naver.com, test@hanmail.net)");
						document.getElementById('emailInput').focus();
						return false;
					}

					return true; // 모두 통과하면 백엔드로 전송!
				}
			</script>

			<c:if test="${not empty msg}">
				<script>alert("${msg}");</script>
			</c:if>

		</body>

		</html>