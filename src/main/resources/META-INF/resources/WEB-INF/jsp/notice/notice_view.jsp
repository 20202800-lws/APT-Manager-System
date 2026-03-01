<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- ★ 파일 확장자명 검사를 위해 JSTL 함수(fn) 태그를 추가했습니다! --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${notice.title} | APARTNERS</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/notice.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                        관리사무소 | <span id="viewDate">${notice.regDate}</span>
                    </div>
                </div>
                
                <div id="viewContent" class="view-content">${notice.content}</div>
                
                <%-- ★ 첨부파일 분류 로직 시작 --%>
                <c:if test="${not empty notice.fileList}">
                    
                    <%-- 1. 이미지 파일과 일반 문서 파일이 있는지 미리 검사합니다. --%>
                    <c:set var="hasImage" value="false" />
                    <c:set var="hasDocument" value="false" />
                    
                    <c:forEach var="file" items="${notice.fileList}">
                        <%-- 파일명을 소문자로 변환하여 확장자를 확인합니다. --%>
                        <c:set var="fileNameLower" value="${fn:toLowerCase(file.orgFileName)}" />
                        <c:choose>
                            <c:when test="${fn:endsWith(fileNameLower, '.jpg') or fn:endsWith(fileNameLower, '.jpeg') or fn:endsWith(fileNameLower, '.png') or fn:endsWith(fileNameLower, '.gif') or fn:endsWith(fileNameLower, '.webp')}">
                                <c:set var="hasImage" value="true" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="hasDocument" value="true" />
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- 2. 이미지가 있다면 본문 바로 아래에 사진을 예쁘게 나열해서 띄워줍니다. --%>
                    <c:if test="${hasImage}">
                        <div id="viewImageArea" style="margin-top: 30px; text-align: center;">
                            <c:forEach var="file" items="${notice.fileList}">
                                <c:set var="fileNameLower" value="${fn:toLowerCase(file.orgFileName)}" />
                                <c:if test="${fn:endsWith(fileNameLower, '.jpg') or fn:endsWith(fileNameLower, '.jpeg') or fn:endsWith(fileNameLower, '.png') or fn:endsWith(fileNameLower, '.gif') or fn:endsWith(fileNameLower, '.webp')}">
                                    <img src="/uploads/${file.savedFileName}" alt="${file.orgFileName}" style="max-width:100%; border-radius:8px; margin-bottom:15px; display:inline-block;">
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:if>

                    <%-- 3. 일반 문서(엑셀, PDF, hwp 등)가 있다면 하단에 다운로드 박스를 만들어줍니다. --%>
                    <c:if test="${hasDocument}">
                        <div id="viewAttachmentArea" style="margin-top: 40px; padding: 20px; background: #f8f9fa; border: 1px solid #e2e8f0; border-radius: 8px;">
                            <h5 style="margin: 0 0 15px 0; font-size: 15px; color: #475569;">
                                <i class="fa-solid fa-paperclip"></i> 첨부파일 (클릭하여 다운로드)
                            </h5>
                            <ul style="list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 10px;">
                                <c:forEach var="file" items="${notice.fileList}">
                                    <c:set var="fileNameLower" value="${fn:toLowerCase(file.orgFileName)}" />
                                    <%-- 이미지가 아닌 파일만 리스트에 출력! --%>
                                    <c:if test="${not (fn:endsWith(fileNameLower, '.jpg') or fn:endsWith(fileNameLower, '.jpeg') or fn:endsWith(fileNameLower, '.png') or fn:endsWith(fileNameLower, '.gif') or fn:endsWith(fileNameLower, '.webp'))}">
                                        <li>
                                            <a href="/uploads/${file.savedFileName}" download="${file.orgFileName}" 
                                               style="color: #3b82f6; text-decoration: none; font-weight: 500; font-size: 15px; display: inline-flex; align-items: center; gap: 8px;">
                                               <i class="fa-regular fa-file-lines"></i> ${file.orgFileName}
                                            </a>
                                            <span style="color:#94a3b8; font-size:13px; margin-left:8px;">(${file.fileSize} byte)</span>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                </c:if>

                <div style="text-align:center; margin-top:40px; padding-top:30px; border-top:1px solid #eee;">
                    <button class="btn-sub" onclick="location.href='/notice/notice_list'">목록으로 돌아가기</button>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../layout/footer.jsp" />

</body>
</html>