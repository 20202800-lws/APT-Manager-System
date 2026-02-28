<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>입주민 게시판 - 익명게시판</title>
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/board.css'/>">
</head>
<body>
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="익명게시판" />
    </jsp:include>

    <div class="container">
        <jsp:include page="../layout/sidebar_board.jsp">
            <jsp:param name="activeMenu" value="anon" />
        </jsp:include>

        <main id="mainArea">
            <div id="listView">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                    <h3 id="boardTitle" style="font-size:24px;">익명게시판</h3>
                    <button class="btn-main" onclick="location.href='<c:url value="/board/anon/write"/>'">글쓰기</button>
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
                            </tr>
                        </thead>
                        <tbody id="boardBody"></tbody>
                    </table>
                </div>
                
                <div class="board-footer">
                    <div class="pagination" id="paginationBox">
                        <c:if test="${paging.hasPrevious()}">
                            <span onclick="location.href='?page=${paging.number - 1}&searchType=${searchType}&searchInput=${keyword}'" 
                                  style="cursor:pointer;">&lt;</span>
                        </c:if>

                        <c:forEach var="i" begin="1" end="${paging.totalPages}">
                            <span class="${i == paging.number + 1 ? 'active' : ''}" 
                                  onclick="location.href='?page=${i-1}&searchType=${searchType}&searchInput=${keyword}'" 
                                  style="cursor:pointer;">
                                ${i}
                            </span>
                        </c:forEach>

                        <c:if test="${paging.hasNext()}">
                            <span onclick="location.href='?page=${paging.number + 1}&searchType=${searchType}&searchInput=${keyword}'" 
                                  style="cursor:pointer;">&gt;</span>
                        </c:if>
                    </div>
                    
                    <div class="search-area">
                        <select id="searchType" style="padding:10px; border-radius:6px; border:1px solid #ddd;">
                            <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                        </select>
                        <input type="text" id="searchInput" name="searchInput" 
                               placeholder="검색어를 입력하세요" 
                               value="${keyword}" 
                               onkeyup="if(window.event.keyCode==13){searchPost()}">
                        <button class="btn-main" onclick="searchPost()">검색</button>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="<c:url value='/js/board/board_anon.js'/>"></script>
    
    <script>
        window.globalBoardList = [];

        <c:if test="${not empty paging.content}">
            <c:forEach var="board" items="${paging.content}">
                window.globalBoardList.push({
                    id: `${board.boardId}`,
                    // ★ 디테일 추가: 익명게시판도 댓글이 1개 이상이면 제목 옆에 [댓글수] 표시!
                    title: `${board.title}` <c:if test="${board.replyCount > 0}"> + ' <span style="color:#e74c3c; font-weight:bold; font-size:13px;">[${board.commentCount}]</span>'</c:if>,
                    author: `${board.author}`,
                    date: `${board.regDate}`,
                    hits: `${board.views}`
                });
            </c:forEach>
        </c:if>
        console.log("주입된 데이터 개수: ", window.globalBoardList.length);
        
        // 백엔드 담당자님의 의도 존중: JS 페이징 그리기 기능 무력화
        renderPaginationUI = function() {};
    </script>
</body>
</html>