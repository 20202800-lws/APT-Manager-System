<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>어린이집 - 공지사항 수정</title>
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/board.css'/>">
</head>
<body>
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="어린이집" />
    </jsp:include>

    <div class="container">
        <jsp:include page="../layout/sidebar_board.jsp">
            <jsp:param name="activeMenu" value="daycare_notice" />
        </jsp:include>

        <main id="mainArea">
            <h3 style="font-size:24px; margin-bottom:20px; border-bottom:2px solid #1a0b2e; padding-bottom:15px;">어린이집 공지사항 수정</h3>
            
            <div class="content-box">
                <form action="<c:url value='/daycare/notice/edit'/>" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="noticeId" value="${post.noticeId}">

                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">공지 제목</label>
                        <input type="text" name="title" value="${post.title}" required 
                               style="width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; font-size:16px;">
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px; background-color:#fffbea; padding:15px; border-radius:8px; border:1px solid #ffe4b5;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px; color:#b45309;">📌 상단 공지 설정</label>
                        <label style="display:flex; align-items:center; cursor:pointer;">
                            <input type="checkbox" name="isTop" value="true" ${post.isTop ? 'checked' : ''} style="width:20px; height:20px; margin-right:10px; cursor:pointer;">
                            <span style="font-size:15px; color:#333;">이 공지사항을 목록 최상단에 고정합니다. (중요 공지용)</span>
                        </label>
                        <input type="hidden" name="_isTop" value="on">
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">공지 내용</label>
                        <textarea name="content" required 
                                  style="width:100%; height:300px; padding:12px; border:1px solid #ddd; border-radius:6px; font-size:15px; resize:vertical;">${post.content}</textarea>
                    </div>

                    <div class="form-group" style="margin-bottom: 30px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">안내문/사진 첨부 (새로 등록 시 기존 파일 덮어쓰기)</label>
                        <input type="file" name="uploadFiles" multiple accept="image/*,.pdf,.hwp,.doc,.docx"
                               style="padding:10px; border:1px dashed #ccc; width:100%; border-radius:6px;">
                    </div>

                    <div style="text-align:right; border-top:1px solid #eee; padding-top:20px;">
                        <button type="button" class="btn-sub" onclick="history.back()">취소</button>
                        <button type="submit" class="btn-main" style="margin-left:8px; background-color:#1a0b2e;">수정 완료</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    <jsp:include page="../layout/footer.jsp" />
</body>
</html>