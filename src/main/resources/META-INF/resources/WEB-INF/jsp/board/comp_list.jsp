<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                    <button class="btn-main" onclick="location.href='<c:url value="/board/comp/write"/>'">민원 작성</button>
                </div>
                
                <div id="tableWrapper">
                    <table class="board-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>날짜</th>
                                
                                <th>처리상태</th> </tr>
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
	    // JS가 인식할 수 있도록 서버의 paging.content를 globalBoardList로 변환
	    window.globalBoardList = [
	        <c:forEach var="item" items="${paging.content}" varStatus="status">
	            {
	                compId: ${item.compId},
	                title: '${item.title}', // 본인이 아니면 서비스에서 "🔒 비밀글"로 변환됨
	                authorName: '${item.userName}', // JS에서 authorName으로 쓰고 있음
	                formattedDate: '${item.regDate}', // JS에서 formattedDate로 쓰고 있음
	               
	                compStatus: '${item.compStatus}' // WAIT 또는 DONE
	            }${!status.last ? ',' : ''}
	        </c:forEach>
	    ];
	</script>
</body>
</html>