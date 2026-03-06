<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>어린이집 - 공지사항 보기</title>
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
            <h3 style="margin-bottom:20px; font-size:24px;">공지사항 안내</h3>
            
            <div class="content-box">
                <div class="detail-header" style="border-bottom:1px solid #eee; padding-bottom:15px;">
                    
                    <c:if test="${post.isTop}">
                        <div style="margin-bottom: 10px;">
                            <span style="background-color: #ef4444; color: white; padding: 4px 10px; border-radius: 4px; font-size: 14px; font-weight: bold;">
                                📌 상단 공지
                            </span>
                        </div>
                    </c:if>
                    
                    <h2 style="margin:0;">${not empty post.title ? post.title : '제목을 불러올 수 없습니다.'}</h2>
                    <div style="color:#888; font-size:14px; margin-top:10px;">
                        작성자: <span style="font-weight:700;">${not empty post.writer ? post.writer.realName : '어린이집 관리자'}</span> | 
                        등록일: <span>${post.regDate}</span> | 
                        조회수: <span>${post.views}</span>
                    </div>
                </div>

                <div style="margin: 40px 0; min-height:200px; line-height:1.8; white-space: pre-wrap; font-size:16px;">${post.content}</div>

                <c:if test="${not empty attachments}">
                    <div style="display:flex; gap:15px; flex-wrap:wrap; margin-bottom:30px;">
                        <c:forEach var="img" items="${attachments}">
                            <img src="<c:url value='/uploads/${img.savedFileName}'/>" alt="${img.orgFileName}" style="max-width:100%; border-radius:10px; margin-top:10px; border:1px solid #eee; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                        </c:forEach>
                    </div>
                </c:if>

                <div style="text-align:right; margin-top:30px; border-top:1px solid #eee; padding-top:20px;">
                    <button type="button" class="btn-sub" onclick="location.href='<c:url value="/daycare/notice"/>'">목록으로</button>
                    
                    <c:if test="${sessionScope.loginMember.userRole == 'ADMIN' || sessionScope.loginMember.userRole == 'TEACHER'}">
                        <span id="myButtons">
                            <button type="button" class="btn-main" style="margin-left:5px;" onclick="location.href='<c:url value="/daycare/notice/edit?id=${post.noticeId}"/>'">수정</button>
                            <form action="<c:url value='/daycare/notice/delete'/>" method="post" style="display:inline-block; margin-left:5px;" onsubmit="return confirm('공지사항을 삭제하시겠습니까?');">
                                <input type="hidden" name="id" value="${post.noticeId}">
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