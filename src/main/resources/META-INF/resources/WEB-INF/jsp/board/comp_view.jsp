<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>민원게시판 - 민원 상세 보기</title>
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
            <h3 style="margin-bottom:20px; font-size:24px;">민원 상세 보기</h3>

            <div class="content-box">
                <div class="detail-header" style="border-bottom:1px solid #eee; padding-bottom:15px;">
                    <div style="margin-bottom: 10px; display: flex; align-items: center; gap: 10px;">
                        <c:choose>
                            <c:when test="${post.compStatus == 'COMPLETED'}">
                                <span style="background-color: #10b981; color: white; padding: 4px 10px; border-radius: 4px; font-size: 14px; font-weight: bold;">처리 완료</span>
                            </c:when>
                            <c:when test="${post.compStatus == 'PROCESSING'}">
                                <span style="background-color: #f59e0b; color: white; padding: 4px 10px; border-radius: 4px; font-size: 14px; font-weight: bold;">진행중</span>
                            </c:when>
                            <c:otherwise>
                                <span style="background-color: #ef4444; color: white; padding: 4px 10px; border-radius: 4px; font-size: 14px; font-weight: bold;">접수 대기</span>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${post.isSecret == 'Y'}">
                            <span style="color: #6366f1; font-size: 14px; font-weight: bold;"><i class="fa-solid fa-lock"></i> 비밀글</span>
                        </c:if>
                    </div>

                    <h2 style="margin:0;">${not empty post.title ? post.title : '제목 없음'}</h2>
                    
                    <div style="color:#888; font-size:14px; margin-top:10px;">
                        작성자: <span style="font-weight:700;">${writerName}</span> | 날짜: <span>${post.regDate}</span>
                    </div>
                </div>

                <div style="margin: 40px 0; min-height:200px; line-height:1.8; white-space: pre-wrap; font-size:16px;">${post.content}</div>

                <c:if test="${not empty attachments}">
                    <div class="attachment-gallery" style="display:flex; gap:15px; flex-wrap:wrap; margin-bottom:40px; background:#f9fafb; padding:20px; border-radius:10px;">
                        <h5 style="width: 100%; margin-top: 0; margin-bottom: 15px; color: #64748b; font-size: 14px;"><i class="fa-regular fa-image"></i> 첨부된 사진</h5>
                        <c:forEach var="img" items="${attachments}">
                            <img src="<c:url value='${img.filePath}'/>" alt="${img.orgFileName}" 
                                 style="max-width:300px; max-height:300px; object-fit:contain; border-radius:8px; border:1px solid #e2e8f0; cursor:pointer;"
                                 onclick="window.open(this.src)"> 
                        </c:forEach>
                    </div>
                </c:if>

                <div class="comment-section" style="margin-top: 50px; background-color:#f8fafc; padding:20px; border-radius:10px; border:1px solid #e2e8f0;">
                    <h4 style="margin-top:0; color:#1e293b; border-bottom:2px solid #cbd5e1; padding-bottom:10px;">
                        <i class="fa-solid fa-headset"></i> 관리소장 답변
                    </h4>

                    <div id="adminReplyArea" style="margin-top: 15px;">
                        <c:choose>
                            <c:when test="${not empty post.reply}">
                                <div style="font-size:16px; color:#333; line-height:1.6; font-weight:500; white-space: pre-wrap;">${post.reply}</div>
                                <div style="margin-top: 15px; font-size:13px; color:#888;">
                                    처리일시: ${not empty post.receiptDate ? post.receiptDate : post.regDate}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p style="text-align:center; color:#94a3b8; padding:30px 0; margin:0; font-size:15px;">
                                    <i class="fa-regular fa-clock" style="font-size: 20px; margin-bottom: 10px; display: block;"></i>
                                    현재 민원 내용을 확인하고 있으며, 조속히 처리 후 답변드리겠습니다.
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div style="text-align:right; margin-top:30px; border-top:1px solid #eee; padding-top:20px;">
                    <button type="button" class="btn-sub" onclick="location.href='<c:url value="/board/comp" />'">목록으로</button>
                    <c:if test="${loginMember.userId == post.user.userId}">
                        <span id="myButtons">
                            <form action="<c:url value='/board/comp/delete'/>" method="post" style="display:inline-block; margin-left:5px;"
                                  onsubmit="return confirm('민원을 취소(삭제)하시겠습니까?');">
                                <input type="hidden" name="id" value="${post.compId}">
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