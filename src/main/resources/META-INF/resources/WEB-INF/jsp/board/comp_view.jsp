<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>민원게시판 - 민원 상세 보기</title>
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
            <h3 style="margin-bottom:20px; font-size:24px;">민원 상세 보기</h3>
            
            <div class="content-box">
                <div class="detail-header" style="border-bottom:1px solid #eee; padding-bottom:15px;">
                    <div style="margin-bottom: 10px;">
                        <span style="background-color: ${post.status == '완료' ? '#10b981' : '#ef4444'}; color: white; padding: 4px 10px; border-radius: 4px; font-size: 14px; font-weight: bold;">
                            ${not empty post.status ? post.status : '대기'}
                        </span>
                    </div>
                    
                    <h2 style="margin:0;">${not empty post.title ? post.title : '제목 없음'}</h2>
                    <div style="color:#888; font-size:14px; margin-top:10px;">
                        작성자: <span style="font-weight:700;">${post.author}</span> | 
                        날짜: <span>${post.regDate}</span> | 
                        조회수: <span>${post.hits}</span>
<!--신고추가-->	<button type="button" class="btn-report-outline" onclick="openReportModal()">신고</button>

                    </div>
                </div>

                <div style="margin: 40px 0; min-height:200px; line-height:1.8; white-space: pre-wrap; font-size:16px;">${post.content}</div>

                <c:if test="${not empty post.images}">
                    <div style="display:flex; gap:15px; flex-wrap:wrap; margin-bottom:30px;">
                        <c:forEach var="img" items="${post.images}">
                            <img src="<c:url value='/images/${img.saveName}'/>" alt="현장사진" style="max-width:100%; border-radius:10px; margin-top:10px; border:1px solid #eee;">
                        </c:forEach>
                    </div>
                </c:if>
                
                <div class="comment-section" style="margin-top: 50px; background-color:#f8fafc; padding:20px; border-radius:10px;">
                    <h4 style="margin-top:0;">관리자 답변 <span style="color:var(--accent-color);">${post.comments.size()}</span></h4>
                    
                    <div id="commentList">
                        <c:forEach var="comment" items="${post.comments}">
                            <div class="comment-unit" style="border-bottom:1px solid #e2e8f0; padding:15px 0;">
                                <div class="comment-info" style="margin-bottom:8px;">
                                    <b style="color:#1a0b2e;">관리소장</b> <span style="color:#888; margin-left:10px; font-size:13px;">${comment.regDate}</span> 
                                    <form action="<c:url value='/board/comp/comment/delete'/>" method="post" style="display:inline; margin-left:8px;">
                                        <input type="hidden" name="commentId" value="${comment.id}">
                                        <input type="hidden" name="postId" value="${post.id}">
                                        <button type="submit" style="background:none; border:none; color:#e74c3c; font-size:12px; cursor:pointer;" onclick="return confirm('답변을 삭제할까요?');">삭제</button>
                                    </form>
                                </div>
                                <div style="font-size:15px; color:#333; line-height:1.5; font-weight:500;">${comment.content}</div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty post.comments}">
                            <p style="text-align:center; color:#888; padding:20px 0; margin:0;">아직 관리자 답변이 등록되지 않았습니다.</p>
                        </c:if>
                    </div>

                    <form action="<c:url value='/board/comp/comment'/>" method="post" style="margin-top:20px;">
                        <input type="hidden" name="postId" value="${post.id}">
                        <textarea name="content" placeholder="관리자 답변을 작성해주세요..." required style="width:100%; height:80px; padding:12px; border:1px solid #ddd; border-radius:6px; resize:vertical; margin-bottom:10px;"></textarea>
                        <div style="text-align:right;">
                            <button type="submit" class="btn-main">답변 등록</button>
                        </div>
                    </form>
                </div>

                <div style="text-align:right; margin-top:30px; border-top:1px solid #eee; padding-top:20px;">
                    <button type="button" class="btn-sub" onclick="location.href='<c:url value="/board/comp"/>'">목록으로</button>
                    <span id="myButtons">
                        <button type="button" class="btn-main" style="margin-left:5px;" onclick="location.href='<c:url value="/board/comp/edit?id=${post.id}"/>'">수정</button>
                        <form action="<c:url value='/board/comp/delete'/>" method="post" style="display:inline-block; margin-left:5px;" onsubmit="return confirm('민원을 삭제하시겠습니까?');">
                            <input type="hidden" name="id" value="${post.id}">
                            <button type="submit" class="btn-danger">삭제</button>
                        </form>
                    </span>
                </div>
            </div>
        </main>
    </div>
	<script src="<c:url value='/js/board/report.js'/>"></script>
    <jsp:include page="../layout/footer.jsp" />
</body>
</html>