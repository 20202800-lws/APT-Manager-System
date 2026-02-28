<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>입주민 게시판 - 민원게시판</title>
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/board.css'/>">
</head>
<body>
    <c:if test="${not empty msg}">
        <script>alert('${msg}');</script>
    </c:if>

    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="민원게시판" />
    </jsp:include>

    <div class="container">
        <jsp:include page="../layout/sidebar_board.jsp">
            <jsp:param name="activeMenu" value="comp" />
        </jsp:include>

        <main id="mainArea">
            <div id="listView">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                    <h3 id="boardTitle" style="font-size:24px;">민원게시판</h3>
                    <button class="btn-main" onclick="location.href='<c:url value="/board/comp/write" />'">민원 작성</button>
                </div>

                <div id="tableWrapper">
                    <table class="board-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>날짜</th>
                                <th>조회수</th>
                                <th>처리상태</th>
                            </tr>
                        </thead>
                        <tbody id="boardBody"></tbody>
                    </table>
                </div>

                <div class="board-footer">
                    <div class="pagination" id="paginationBox"></div>
                    <div class="search-area">
                        <select id="searchType" style="padding:10px; border-radius:6px; border:1px solid #ddd;">
                            <option value="title">제목</option>
                            <option value="author">작성자</option>
                        </select>
                        <input type="text" id="searchInput" placeholder="검색어를 입력하세요">
                        <button class="btn-main" onclick="searchPost()">검색</button>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="<c:url value='/js/board/board_comp.js'/>"></script>

    <script>
        // ★ 백엔드와 프론트엔드(board_comp.js)를 완벽하게 연결하는 핵심 데이터 바인딩
        window.globalBoardList = [];

        <c:if test="${not empty paging.content}">
            <c:forEach var="comp" items="${paging.content}">
                window.globalBoardList.push({
                    id: `${comp.compId}`,
                    title: `${comp.title}`,
                    author: `${comp.writerName}`, // 프록시 에러 방어용 이름!
                    date: `${comp.regDate}`,
                    hits: `-`, // 민원은 조회수가 없으므로 하이픈(-) 처리
                    status: `${comp.compStatus}`, 
                    secret: `${comp.isSecret == 'Y'}` // 비밀글 여부 완벽 매핑
                });
            </c:forEach>
        </c:if>
        console.log("주입된 민원 데이터 개수: ", window.globalBoardList.length);
    </script>
</body>
</html>