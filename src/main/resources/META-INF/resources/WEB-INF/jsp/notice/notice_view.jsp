<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${notice.title} | APARTNERS</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/notice.css">
</head>
<body>

<jsp:include page="../layout/header_sub.jsp">
    <jsp:param name="pageTitle" value="소식" />
</jsp:include>

<div class="page-wrapper">
    <aside class="sidebar">
        <h2>소식</h2>
        <ul class="lnb">
            <li class="active" onclick="location.href='/notice/notice_list'">공지사항</li>
        </ul>
    </aside>

    <main class="content-area">
        <div id="detailView">
            <div class="header">
                <h2>공지사항 확인</h2>
            </div>
            
            <div class="content-box">
                <div class="view-header">
                    <h3 id="viewTitle">${notice.title}</h3>
                    <div class="view-meta">
                        관리사무소 | <span id="viewDate">${notice.date}</span>
                    </div>
                </div>
                
                <div id="viewContent" class="view-content">${notice.content}</div>
                
                <div id="viewImageArea">
                    <c:if test="${not empty notice.fileList}">
                        <c:forEach var="file" items="${notice.fileList}">
                            <img src="/uploads/${file.saveName}" class="detail-img" alt="첨부이미지">
                        </c:forEach>
                    </c:if>
                </div>

                <div style="text-align:center; margin-top:40px; padding-top:30px; border-top:1px solid #eee;">
                    <button class="btn-sub" onclick="location.href='/notice/notice_list'">목록으로 돌아가기</button>
                    
                    <c:if test="${sessionScope.loginMember.userRole == 'ADMIN'}">
                        <span style="margin-left: 10px;">
                            <button class="btn-main" style="background:#4a69bd;" onclick="location.href='/notice/edit?id=${notice.id}'">수정</button>
                            <button class="btn-main" style="background:#e55039;" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='/notice/delete?id=${notice.id}'">삭제</button>
                        </span>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../layout/footer.jsp" />

</body>
</html>