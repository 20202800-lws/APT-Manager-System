<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>민원게시판 - 민원 작성</title>
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/board.css'/>">
</head>
<body>
	<jsp:include page="../layout/header_sub.jsp">
	    <jsp:param name="pageTitle" value="민원게시판" />
	</jsp:include>

    <div class="container">
        <jsp:include page="../layout/sidebar_board.jsp">
            <jsp:param name="activeMenu" value="comp" />
        </jsp:include>

        <main id="mainArea">
            <h3 style="font-size:24px; margin-bottom:20px; border-bottom:2px solid #1a0b2e; padding-bottom:15px;">새 민원 작성</h3>
            
            <div class="content-box">
                <form action="<c:url value='/board/comp/write'/>" method="post" enctype="multipart/form-data">
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">제목</label>
                        <input type="text" name="title" placeholder="민원 제목을 입력하세요" required 
                               style="width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; font-size:16px;">
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">내용</label>
                        <textarea name="content" placeholder="불편하신 사항이나 건의할 내용을 상세히 적어주세요..." required 
                                  style="width:100%; height:300px; padding:12px; border:1px solid #ddd; border-radius:6px; font-size:15px; resize:vertical;"></textarea>
                    </div>

                    <div class="form-group" style="margin-bottom: 30px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">현장 사진 첨부</label>
                        <input type="file" name="uploadFiles" multiple accept="image/*"
                               style="padding:10px; border:1px dashed #ccc; width:100%; border-radius:6px;">
                    </div>

                    <div style="text-align:right; border-top:1px solid #eee; padding-top:20px;">
                        <button type="button" class="btn-sub" onclick="history.back()">취소</button>
                        <button type="submit" class="btn-main" style="margin-left:8px;">민원 접수하기</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    <jsp:include page="../layout/footer.jsp" />
</body>
</html>