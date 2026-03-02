<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>어린이집 - 공지사항</title>
    
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
            <div id="listView">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                    <h3 id="boardTitle" style="font-size:24px;">어린이집 공지사항</h3>
                    
					<c:if test="${sessionScope.loginMember.userRole == 'ADMIN' || sessionScope.loginMember.userRole == 'TEACHER'}">
						<button class="btn-main" onclick="location.href='<c:url value="/daycare/notice/write"/>'">공지 등록</button>
					</c:if>
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
                        <tbody id="boardBody">
                            </tbody>
                    </table>
                </div>
                
                <div class="board-footer">
                    <div class="pagination" id="paginationBox"></div>
                    <div class="search-area">
                        <select id="searchType" style="padding:10px; border-radius:6px; border:1px solid #ddd;">
                            <option value="title">제목</option>
                        </select>
                        <input type="text" id="searchInput" placeholder="검색어를 입력하세요">
                        <button class="btn-main" onclick="searchPost()">검색</button>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script src="<c:url value='/js/daycare/daycare_notice.js'/>"></script>

</body>
</html>