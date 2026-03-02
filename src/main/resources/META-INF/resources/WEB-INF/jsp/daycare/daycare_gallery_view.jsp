<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>어린이집 - 갤러리 보기</title>
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/board.css'/>">
</head>
<body>
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="어린이집" />
    </jsp:include>

    <div class="container">
        <jsp:include page="../layout/sidebar_board.jsp">
            <jsp:param name="activeMenu" value="daycare_gallery" />
        </jsp:include>

        <main id="mainArea">
            <h3 style="margin-bottom:20px; font-size:24px;">활동 갤러리</h3>
            
            <div class="content-box">
                <div class="detail-header" style="border-bottom:1px solid #eee; padding-bottom:15px;">
                    <h2 style="margin:0;">${not empty post.title ? post.title : '사진 갤러리'}</h2>
                    <div style="color:#888; font-size:14px; margin-top:10px;">
                        선생님: <span style="font-weight:700;">${not empty post.writer ? post.writer.realName : '어린이집 선생님'}</span> | 
                        날짜: <span>${post.regDate}</span> | 
                        조회수: <span>${post.views}</span>
                    </div>
                </div>

                <div style="margin: 40px 0; text-align:center;">
                    <c:if test="${not empty images}">
                        <c:forEach var="img" items="${images}">
                            <div style="margin-bottom: 20px;">
                                <img src="/uploads/${img.savedFileName}" alt="${img.orgFileName}" style="max-width:100%; border-radius:12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                            </div>
                        </c:forEach>
                    </c:if>
                    
                    <div style="text-align:left; margin-top:30px; line-height:1.8; white-space: pre-wrap; font-size:16px;">${post.content}</div>
                </div>
                
                <div class="comment-section" style="margin-top: 50px;">
                    <h4>학부모 댓글 <span style="color:var(--accent-color);">${post.comments.size()}</span></h4>
                    <div id="commentList">
                        <c:forEach var="comment" items="${post.comments}">
                            <div class="comment-unit" style="border-bottom:1px solid #f1f1f1; padding:15px 0;">
                                <div class="comment-info" style="margin-bottom:8px;">
                                    <b>${comment.writer.realName}</b> 
                                    <span style="color:#bbb; margin-left:10px; font-size:13px;">${comment.regDate}</span> 
                                    
                                    <c:if test="${sessionScope.loginMember.userId == comment.writer.userId || sessionScope.loginMember.userRole == 'ADMIN' || sessionScope.loginMember.userRole == 'TEACHER'}">
                                        <form action="<c:url value='/daycare/gallery/comment/delete'/>" method="post" style="display:inline; margin-left:8px;">
                                            <input type="hidden" name="commentId" value="${comment.commentId}">
                                            <input type="hidden" name="postId" value="${post.galleryId}">
                                            <button type="submit" style="background:none; border:none; color:#e74c3c; font-size:12px; cursor:pointer;" onclick="return confirm('댓글을 삭제할까요?');">삭제</button>
                                        </form>
                                    </c:if>
                                </div>
                                <div style="font-size:15px; color:#333; line-height:1.5;">${comment.content}</div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty post.comments}">
                            <p style="text-align:center; color:#ccc; padding:30px;">따뜻한 댓글을 남겨주세요!</p>
                        </c:if>
                    </div>

                    <form action="<c:url value='/daycare/gallery/comment'/>" method="post" style="margin-top:20px; background:#f8fafc; padding:20px; border-radius:8px;">
                        <input type="hidden" name="postId" value="${post.galleryId}">
                        <textarea name="content" placeholder="아이들의 사진에 예쁜 댓글을 남겨주세요 💖" required style="width:100%; height:80px; padding:12px; border:1px solid #ddd; border-radius:6px; resize:vertical; margin-bottom:10px;"></textarea>
                        <div style="text-align:right;">
                            <button type="submit" class="btn-main">댓글 등록</button>
                        </div>
                    </form>
                </div>

                <div style="text-align:right; margin-top:30px; border-top:1px solid #eee; padding-top:20px;">
                    <button type="button" class="btn-sub" onclick="location.href='<c:url value="/daycare/gallery"/>'">목록으로</button>
                    
                    <c:if test="${sessionScope.loginMember.userRole == 'ADMIN' || sessionScope.loginMember.userRole == 'TEACHER'}">
                        <span id="myButtons">
                            <form action="<c:url value='/daycare/gallery/delete'/>" method="post" style="display:inline-block; margin-left:5px;" onsubmit="return confirm('사진과 글을 완전히 삭제하시겠습니까?');">
                                <input type="hidden" name="id" value="${post.galleryId}">
                                <button type="submit" class="btn-danger">삭제</button>
                            </form>
                        </span>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
    <jsp:include page="../layout/footer.jsp" />
</body>
</html>