<<<<<<< HEAD
<!-- 자유게시판 -->
=======
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="ko">
	<head>
	    <link rel="stylesheet" href="/css/layout.css">
	    <link rel="stylesheet" href="/css/board.css">
		
	</head>

	<body>
	  			 <!--header sub로 바꾸기!(이미지도 완성되면)-->
		<jsp:include page="../layout/header_auth.jsp" />
	

<div class="container">
    <aside class="sidebar">
        <h2>게시판</h2>
        <ul id="sideMenu">
            <li class="side-item active" onclick="changeBoard('free', this)">자유게시판</li>
            <li class="side-item" onclick="changeBoard('anon', this)">익명게시판</li>
            <li class="side-item" onclick="changeBoard('compliaint', this)">민원게시판</li>
            <div class="kids-menu-root" id="kidsMenuRoot">
                <li class="side-item" style="font-weight:800; color:#333; margin-top:20px; cursor:default;">어린이집</li>
                <div class="kids-group">
                    <li class="side-sub-item" onclick="changeBoard('kidsNotice', this)">공지사항</li>
                    <li class="side-sub-item" onclick="changeBoard('kidsGallery', this)">활동갤러리</li>
                    <li class="side-sub-item" onclick="changeBoard('kidsTalk', this)">학부모의견란</li>
                </div>
            </div>
        </ul>
    </aside>

    <main id="mainArea">
        <div id="listView">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                <h3 id="boardTitle" style="font-size:24px;">자유게시판</h3>
                <button class="btn-main" id="topWriteBtn" onclick="showWrite()">글쓰기</button>
            </div>
            <div id="tableWrapper">
                <table class="board-table">
                    <thead><tr><th>번호</th><th>제목</th><th>작성자</th><th>날짜</th><th>조회수</th></tr></thead>
                    <tbody id="boardBody"></tbody>
                </table>
            </div>
            <div id="galleryWrapper" style="display:none; grid-template-columns: repeat(3, 1fr); gap: 20px;"></div>
            <div id="talkWrapper" style="display:none;">
                <div id="talkList"></div>
                <div class="quick-write-box">
                    <h4 style="margin-top:0;">의견 남기기</h4>
                    <textarea id="quickInput" placeholder="선생님들께 따뜻한 한마디를 남겨주세요..."></textarea>
                    <div style="text-align:right;"><button class="btn-main" onclick="saveQuickTalk()">등록하기</button></div>
                </div>
            </div>
            <div class="board-footer">
                <div class="pagination" id="paginationBox"></div>
                <div class="search-area">
                    <select id="searchType" style="padding:10px; border-radius:6px; border:1px solid #ddd;">
                        <option value="title">제목</option>
                        <option value="user_id">작성자</option>
                    </select>
                    <input type="text" id="searchInput" placeholder="검색어를 입력하세요">
                    <button class="btn-main" onclick="searchPost()">검색</button>
                </div>
            </div>
        </div>

        <div id="writeView" style="display:none;">
            <h3 id="formTitle">새 게시글 작성</h3>
            <div class="content-box" style="margin-top:20px;">
                <input type="hidden" id="editIndex">
                <div class="form-group" id="titleGroup"><label>제목</label><input type="text" id="inputTitle" placeholder="제목을 입력하세요"></div>
                <div class="form-group"><label>내용</label><textarea id="inputContent" placeholder="내용을 입력하세요..."></textarea></div>
                <div class="form-group" id="imageGroup">
                    <label>사진 첨부</label>
                    <div class="image-upload-box" onclick="document.getElementById('fileInput').click()">
                        <p>📸 사진 추가</p>
                        <input type="file" id="fileInput" hidden multiple onchange="previewImages(this)">
                        <div id="previewContainer" style="display:flex; gap:10px; justify-content:center; margin-top:15px;"></div>
                    </div>
                </div>
                <div style="text-align:right;">
                    <button class="btn-sub" onclick="showList()">취소</button>
                    <button class="btn-main" onclick="savePost()" id="submitBtn" style="margin-left:8px;">등록하기</button>
                </div>
            </div>
        </div>

        <div id="detailView" style="display:none;">
            <h3 style="margin-bottom:20px;">게시글 보기</h3>
            <div class="content-box">
                <div class="detail-header" style="border-bottom:1px solid #eee; padding-bottom:15px;">
                    <h2 id="viewTitle" style="margin:0;"></h2>
                    <div style="color:#888; font-size:14px; margin-top:10px;">작성자: <span id="viewuser_id" style="font-weight:700;"></span> | 날짜: <span id="viewDate"></span> | 조회수: <span id="viewHits"></span></div>
                </div>
                <div id="viewContent" style="margin: 40px 0; min-height:200px; line-height:1.8; white-space: pre-wrap; font-size:16px;"></div>
                <div id="viewImages" style="display:flex; gap:15px; flex-wrap:wrap; margin-bottom:30px;"></div>
                
                <div class="comment-section" id="commentArea">
                    <h4>댓글 <span id="commentCount" style="color:var(--accent-color);">0</span></h4>
                    <div id="commentList"></div>
                    <div class="comment-form">
                        <textarea id="commentInput" placeholder="따뜻한 댓글을 남겨주세요..."></textarea>
                        <button class="btn-main" onclick="addComment()">댓글 등록</button>
                    </div>
                </div>

                <div style="text-align:right; margin-top:30px; border-top:1px solid #eee; padding-top:20px;">
                    <button class="btn-sub" onclick="showList()">목록으로</button>
                    <span id="myButtons">
                        <button class="btn-main" style="margin-left:5px;">수정</button>
                        <button class="btn-danger" onclick="deletePost()" style="margin-left:5px;">삭제</button>
                    </span>
                </div>
            </div>
        </div>
    </main>
</div>

 <jsp:include page="../layout/footer.jsp" />

<script src="board.js"></script>

</body>
</html>
>>>>>>> refs/remotes/origin/mypage
