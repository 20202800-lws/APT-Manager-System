<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 정보수정</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
	<link rel="stylesheet" href="/css/layout.css">
	<link rel="stylesheet" href="/css/mypage.css">
			
</head>

		<body>
		  			 <!--header sub로 바꾸기!(이미지도 완성되면)-->
			<jsp:include page="../layout/header_auth.jsp" />

<main class="container">
	<aside class="sidebar">
	    <h2>마이페이지</h2>
	    <nav class="menu-list">
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'info_view')">내 정보</button>
	        <button type="button" class="menu-item active" onclick="changeMenu(this, 'info_edit')">정보 수정</button>
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'fee_view')">관리비</button>
	        
	        <div class="dropdown-grp">
	            <div class="menu-item">활동 내역 ▾</div>
	            <div class="sub-menu-side">
	                <button type="button" class="sub-item" onclick="changeMenu(this, 'act_reply')">내가 쓴 댓글</button>
	                <button type="button" class="sub-item" onclick="changeMenu(this, 'act_posts')">내가 쓴 게시물</button>
	            </div>
	        </div>
	    </nav>
	</aside>

    <div class="content-area">
        <div class="profile-section">
            <div class="photo-box" id="imagePreview"><span style="color:#aaa;">미설정</span></div>
            <label for="fileInput" class="file-label">사진 변경</label>
            <input type="file" id="fileInput" accept="image/*" onchange="previewImage(this)" style="display:none;">
        </div>

        <form class="edit-form">
            <h3 style="font-size: 28px; font-weight: 700; margin-bottom: 30px;">👤 회원 정보 수정</h3>
            <p style="font-size:14px; font-weight:600; margin-bottom:8px;">비밀번호 변경</p>
            <input type="password" class="input-box" placeholder="현재 비밀번호">
            <input type="password" class="input-box" placeholder="새 비밀번호">
            <input type="password" class="input-box" placeholder="새 비밀번호 확인">

            <p style="font-size:14px; font-weight:600; margin-bottom:8px;">전화번호 변경</p>
            <div class="flex-row">
                <input type="text" class="input-box" value="010" style="flex:0.8; text-align:center;">
                <input type="text" class="input-box" placeholder="0000" style="flex:1; text-align:center;">
                <input type="text" class="input-box" placeholder="0000" style="flex:1; text-align:center;">
            </div>
            
            <p style="font-size:14px; font-weight:600; margin-bottom:8px;">이메일 주소</p>
            <div class="flex-row">
                <input type="text" class="input-box" placeholder="아이디" style="flex:1;">
                <span>@</span>
                <input type="text" id="emailDom" class="input-box" placeholder="도메인" style="flex:1;">
                <select class="input-box" style="flex:1;" onchange="document.getElementById('emailDom').value=this.value">
                    <option value="">직접입력</option>
                    <option value="naver.com">naver.com</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="daum.net">daum.net</option>
                </select>
            </div>
            <div style="text-align: right; margin-bottom:20px;">
                <button type="button" class="btn-side" style="padding: 8px 15px; cursor:pointer;">이메일 인증</button>
            </div>

            <p style="font-size:14px; font-weight:600; margin-bottom:8px;">거주 정보</p>
            <div class="flex-row">
                <input type="text" class="input-box" placeholder="동" style="flex:1;">
                <input type="text" class="input-box" placeholder="호" style="flex:1;">
            </div>
            
            <button type="submit" class="btn-submit">수정 내용 저장</button>
        </form>
    </div>
</main>
<jsp:include page="../layout/footer.jsp" />
<script src="mypage.js"></script>

</body>
</html>
