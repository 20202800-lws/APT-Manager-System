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

<div class="page-wrapper">
    <aside class="sidebar">
        <h2>소식</h2>
        <ul class="lnb">
            <li class="active" onclick="location.href='/notice/notice_list'">공지사항</li>
        </ul>
    </aside>

    <main class="content-area">
        <div id="listView">
            <div class="header">
                <h2>📢 단지 공지사항</h2>
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
                    <%-- 백엔드(Controller)에서 넘어온 데이터(noticeList)를 반복 출력합니다. --%>
                    <c:choose>
                        <c:when test="${empty paging.content}">
                            <tr>
                                <td colspan="3" style="padding:60px; color:#999;">등록된 공지사항이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="notice" items="${paging.content}">
                                <%-- 중요 공지(isPinned)일 경우 하이라이트 클래스 추가 --%>
                                <tr class="${notice.isImportant ? 'pinned-row' : ''}">
                                    <td>
                                        <c:if test="${notice.isImportant}"><span class="badge-pinned">중요</span></c:if>
                                        <c:if test="${!notice.isImportant}">${notice.noticeId}</c:if>
                                    </td>
                                    <td class="title-cell ${notice.isImportant ? 'pinned-text' : ''}" 
                                        onclick="location.href='/notice/notice_view?id=${notice.noticeId}'">
                                        ${notice.title}
                                    </td>
                                    <td style="color:#888;">${notice.regDate}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="search-area">
                <form action="/notice/notice_list" method="GET" style="display:flex; gap:8px;">
                    <input type="text" name="keyword" placeholder="공지 제목을 입력하세요..." value="${param.keyword}">
                    <button type="submit" class="btn-main">검색</button>
                </form>
            </div>
            
            <div class="pagination">
				<%-- 전체 페이지가 0보다 클 때만 페이징 표시 --%>
				    <c:if test="${paging.totalPages > 0}">
				        
				        <%-- 이전 페이지 버튼 --%>
				        <c:if test="${paging.hasPrevious()}">
				            <span class="page-link" onclick="location.href='?page=${paging.number - 1}&keyword=${keyword}'">&laquo;</span>
				        </c:if>

				        <%-- 페이지 번호들: 음수 방지를 위해 한 번 더 체크 --%>
				        <c:forEach var="i" begin="0" end="${paging.totalPages > 0 ? paging.totalPages - 1 : 0}">
				            <span class="page-number ${i == paging.number ? 'active' : ''}" 
				                  onclick="location.href='?page=${i}&keyword=${keyword}'">
				                ${i + 1}
				            </span>
				        </c:forEach>

				        <%-- 다음 페이지 버튼 --%>
				        <c:if test="${paging.hasNext()}">
				            <span class="page-link" onclick="location.href='?page=${paging.number + 1}&keyword=${keyword}'">&raquo;</span>
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