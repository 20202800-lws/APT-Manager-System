<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 활동내역/댓글</title>
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
            <jsp:param name="activeMenu" value="act_reply" />
        </jsp:include>

        <main class="content-area">
            <div class="page-header">
                <h2>활동 내역</h2>
            </div>

            <div style="margin-top: 20px;">
                <div class="activity-header"
                    style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #333; padding-bottom: 15px; margin-bottom: 20px;">
                    <h3 id="pageTitle" style="margin: 0;">💬 내가 쓴 댓글</h3>
                    <span class="count-txt">총 <strong id="totalCount" style="color:var(--primary-color);">${myReplies != null ? myReplies.size() : 0}</strong>건</span>
                </div>

                <ul id="activityList" class="activity-list" style="list-style: none; padding: 0;">

                    <c:forEach var="reply" items="${myReplies}">
                        <li class="list-item" style="border-bottom: 1px solid #eee; padding: 15px 0;">
                            <div class="item-info" style="display:flex; flex-direction:column; gap:5px;">
                                <span style="color:#999; font-size:12px;">원문: ${reply.originalTitle}</span>

                                <a href="${reply.linkUrl}" class="subject" style="font-size: 16px; font-weight: bold; text-decoration: none; color: inherit;">${reply.content}</a>

                                <span class="date" style="font-size: 13px; color: #888;">${reply.regDate}</span>
                            </div>
                        </li>
                    </c:forEach>

                    <c:if test="${empty myReplies}">
                        <li style="padding: 50px; text-align: center; color: #888; border-bottom: 1px solid #eee;">
                            작성한 댓글이 없습니다.
                        </li>
                    </c:if>

                </ul>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="/js/mypage.js"></script>
</body>

</html>