<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>입주민 공지사항 | APARTNERS</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/notice.css">
</head>
<body>

<jsp:include page="../layout/header_sub.jsp">
    <jsp:param name="pageTitle" value="공지사항" />
</jsp:include>

<div class="page-wrapper container">
    <aside class="sidebar">
        <h2>소식</h2>
        <ul class="lnb">
            <li class="active" onclick="location.href='/notice/notice_list'">공지사항</li>
        </ul>
    </aside>

    <main class="content-area">
        <div id="listView">
            <div class="header" style="margin-bottom: 20px;">
                <h2 style="font-size:24px; margin-bottom:5px;">📢 단지 공지사항</h2>
                <span style="color:#888; font-size:14px;">우리 단지의 소식을 전해드립니다.</span>
            </div>
            
            <table class="board-table">
                <thead>
                    <tr>
                        <th width="100">번호</th>
                        <th>제목</th>
                        <th width="150">작성일</th>
                    </tr>
                </thead>
                <tbody id="boardBody">
                    <%-- 백엔드에서 넘어온 데이터(paging.content) 반복 출력 --%>
                    <c:choose>
                        <c:when test="${empty paging.content}">
                            <tr>
                                <td colspan="3" style="padding:60px; color:#999; text-align:center;">등록된 공지사항이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="notice" items="${paging.content}">
                                <%-- ★ 500 에러 유발 코드(isImportant) 제거 및 전체 줄 클릭 가능하도록 수정 --%>
                                <tr onclick="location.href='/notice/notice_view?id=${notice.noticeId}'" style="cursor:pointer;">
                                    <td>${notice.noticeId}</td>
                                    <td class="title-cell" style="text-align:left; padding-left:15px;">
                                        ${notice.title}
                                    </td>
                                    <td style="color:#888;">${notice.regDate}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="search-area" style="margin-top: 30px; display: flex; justify-content: center;">
                <form action="/notice/notice_list" method="GET" style="display:flex; gap:8px;">
                    <%-- ★ 우리가 백엔드에 추가한 기능을 100% 활용하기 위한 검색 조건 셀렉트 박스 추가! --%>
                    <select name="searchType" style="padding:10px; border-radius:6px; border:1px solid #ddd;">
                        <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
                        <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
                    </select>
                    <input type="text" name="keyword" placeholder="공지 검색어를 입력하세요..." value="${keyword}" style="padding:10px; border-radius:6px; border:1px solid #ddd; width: 250px;">
                    <button type="submit" class="btn-main">검색</button>
                </form>
            </div>
            
            <div class="pagination board-footer" style="margin-top: 20px; text-align: center;">
				<%-- 전체 페이지가 0보다 클 때만 페이징 표시 --%>
				<c:if test="${paging.totalPages > 0}">
				    
				    <%-- 이전 페이지 버튼 (★ searchType 파라미터 추가) --%>
				    <c:if test="${paging.hasPrevious()}">
				        <span class="page-link" onclick="location.href='?page=${paging.number - 1}&searchType=${searchType}&keyword=${keyword}'" style="cursor:pointer; padding:5px 10px;">&laquo;</span>
				    </c:if>

				    <%-- 페이지 번호들 (★ searchType 파라미터 추가) --%>
				    <c:forEach var="i" begin="0" end="${paging.totalPages > 0 ? paging.totalPages - 1 : 0}">
				        <span class="page-number ${i == paging.number ? 'active' : ''}" 
				              onclick="location.href='?page=${i}&searchType=${searchType}&keyword=${keyword}'" style="cursor:pointer; padding:5px 10px; border:1px solid #eee; margin:0 3px;">
				            ${i + 1}
				        </span>
				    </c:forEach>

				    <%-- 다음 페이지 버튼 (★ searchType 파라미터 추가) --%>
				    <c:if test="${paging.hasNext()}">
				        <span class="page-link" onclick="location.href='?page=${paging.number + 1}&searchType=${searchType}&keyword=${keyword}'" style="cursor:pointer; padding:5px 10px;">&raquo;</span>
				    </c:if>
				    
				</c:if>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../layout/footer.jsp" />
<script src="<c:url value='/js/notice/notice.js'/>"></script>
</body>
</html>