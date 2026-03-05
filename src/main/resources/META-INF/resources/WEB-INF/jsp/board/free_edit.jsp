<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자유게시판 - 글 수정</title>
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/board.css'/>">
</head>
<body>
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="자유게시판" />
    </jsp:include>

    <div class="container">
        <jsp:include page="../layout/sidebar_board.jsp">
            <jsp:param name="activeMenu" value="free" />
        </jsp:include>

        <main id="mainArea">
            <h3 style="font-size:24px; margin-bottom:20px; border-bottom:2px solid #1a0b2e; padding-bottom:15px;">
                게시글 수정</h3>

            <div class="content-box">
                <form action="<c:url value='/board/free/edit'/>" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="boardId" value="${post.boardId}">

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">제목</label>
                        <input type="text" name="title" value="${post.title}" required
                            style="width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; font-size:16px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">내용</label>
                        <textarea name="content" required
                            style="width:100%; height:300px; padding:12px; border:1px solid #ddd; border-radius:6px; font-size:15px; resize:vertical;">${post.content}</textarea>
                    </div>

                    <div class="form-group" style="margin-bottom: 30px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">사진 첨부 (새로 등록 시 기존 사진 덮어쓰기)</label>
                        <input type="file" name="uploadFiles" multiple accept="image/*"
                            onchange="previewImages(this)"
                            style="padding:10px; border:1px dashed #ccc; width:100%; border-radius:6px;">

                        <div id="imagePreviewContainer" style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 15px;"></div>
                    </div>

                    <div style="text-align:right; border-top:1px solid #eee; padding-top:20px;">
                        <button type="button" class="btn-sub" onclick="history.back()">취소</button>
                        <button type="submit" class="btn-main" style="margin-left:8px;">수정완료</button>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script>
        function previewImages(input) {
            const container = document.getElementById('imagePreviewContainer');
            container.innerHTML = '';
            if (input.files && input.files.length > 0) {
                Array.from(input.files).forEach(file => {
                    if (file.type.startsWith('image/')) {
                        const img = document.createElement('img');
                        img.src = URL.createObjectURL(file);
                        img.style.width = '120px';
                        img.style.height = '120px';
                        img.style.objectFit = 'cover';
                        img.style.borderRadius = '8px';
                        img.style.border = '1px solid #ddd';
                        container.appendChild(img);
                    }
                });
            }
        }
    </script>
</body>
</html>