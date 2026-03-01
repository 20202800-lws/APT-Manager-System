<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>익명게시판 - 게시글 보기</title>
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
            <h3 style="margin-bottom:20px; font-size:24px;">게시글 보기</h3>
            
            <div class="content-box">
                <div class="detail-header" style="border-bottom:1px solid #eee; padding-bottom:15px;">
                    <h2 style="margin:0;">${not empty post.title ? post.title : '제목을 불러올 수 없습니다.'}</h2>
                    <div style="color:#888; font-size:14px; margin-top:10px;">
                        작성자: <span style="font-weight:700;">${post.author}</span> | 날짜: <span>${post.regDate}</span> | 조회수: <span>${post.views}</span>
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
                
                <div class="comment-section" style="margin-top: 50px;">
                    <h4>댓글 <span style="color:var(--accent-color);">${comments.size()}</span></h4>
                    
                    <div id="commentList">
                        <c:forEach var="comment" items="${comments}">
                            <div class="comment-unit" style="border-bottom:1px solid #f1f1f1; padding:15px 0;">
                                <div class="comment-info" style="margin-bottom:8px;">
                                    <b>${comment.author}</b> 
                                    <span style="color:#bbb; margin-left:10px; font-size:13px;">${comment.regDate}</span> 
                                    
                                    <c:if test="${comment.owner || loginMember.userRole == 'ADMIN'}">
                                    <form action="<c:url value='/board/comment/delete'/>" method="post" style="display:inline; margin-left:8px;">
                                        <input type="hidden" name="replyId" value="${comment.replyId}">
                                        <input type="hidden" name="boardId" value="${post.boardId}">
                                        <input type="hidden" name="boardType" value="anon">
                                        <button type="submit" style="background:none; border:none; color:#e74c3c; font-size:12px; cursor:pointer;" onclick="return confirm('댓글을 삭제할까요?');">삭제</button>
                                    </form>
                                    </c:if>
                                </div>
                                <div style="font-size:15px; color:#333; line-height:1.5;">${comment.content}</div>
                            </div>
                        </c:forEach>
                        
                        <c:if test="${empty comments}">
                            <p style="text-align:center; color:#ccc; padding:30px;">아직 댓글이 없습니다. 첫 댓글을 남겨주세요!</p>
                        </c:if>
                    </div>

                    <form action="<c:url value='/board/comment'/>" method="post" style="margin-top:20px; background:#f8fafc; padding:20px; border-radius:8px;">
                        <input type="hidden" name="boardId" value="${post.boardId}">
                        <input type="hidden" name="boardType" value="anon">
                        <textarea name="content" placeholder="댓글을 남겨주세요... (작성자는 철저히 숨겨집니다)" required style="width:100%; height:80px; padding:12px; border:1px solid #ddd; border-radius:6px; resize:vertical; margin-bottom:10px;"></textarea>
                        <div style="text-align:right;">
                            <button type="submit" class="btn-main">댓글 등록</button>
                        </div>
                    </form>
                </div>

                <div style="text-align:right; margin-top:30px; border-top:1px solid #eee; padding-top:20px;">
                    <button type="button" class="btn-sub" onclick="location.href='<c:url value="/board/anon"/>'">목록으로</button>
                    
                    <button type="button" class="btn-danger" style="margin-left:5px; background-color:#ff9800; border-color:#ff9800;" onclick="openReportModal()">🚨 신고</button>

                    <c:if test="${post.owner || loginMember.userRole == 'ADMIN'}">
                        <span id="myButtons">
                            <button type="button" class="btn-main" style="margin-left:5px;" onclick="location.href='<c:url value="/board/anon/edit?id=${post.boardId}"/>'">수정</button>
                            <form action="<c:url value='/board/delete'/>" method="post" style="display:inline-block; margin-left:5px;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                <input type="hidden" name="boardId" value="${post.boardId}">
                                <button type="submit" class="btn-danger">삭제</button>
                            </form>
                        </span>
                    </c:if>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <div class="modal-overlay" id="reportModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:2000; align-items:center; justify-content:center;">
        <div class="modal-content" style="background:#fff; width:450px; padding:30px; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.2);">
            <div style="display:flex; justify-content:space-between; margin-bottom:20px; align-items:center;">
                <h3 style="margin:0; color:#e74c3c;">🚨 부적절한 게시물 신고</h3>
                <button onclick="closeReportModal()" style="border:none; background:none; font-size:24px; cursor:pointer; color:#888;">&times;</button>
            </div>
            
            <div class="form-group" style="margin-bottom:15px;">
                <label style="display:block; margin-bottom:8px; font-size:14px; font-weight:600;">신고 사유</label>
                <select id="reportReason" style="width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; outline:none;">
                    <option value="스팸/홍보성">스팸/홍보성 도배글</option>
                    <option value="욕설/혐오">욕설 및 혐오 발언</option>
                    <option value="음란물">음란물 또는 부적절한 내용</option>
                    <option value="개인정보 노출">개인정보 노출</option>
                    <option value="기타">기타 (상세 내용 작성)</option>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom:25px;">
                <label style="display:block; margin-bottom:8px; font-size:14px; font-weight:600;">상세 내용 (필수)</label>
                <textarea id="reportDetail" rows="4" style="width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; resize:none; outline:none;" placeholder="관리자가 확인할 수 있도록 신고 내용을 상세히 적어주세요."></textarea>
            </div>
            
            <div style="text-align:right;">
                <button class="btn-sub" onclick="closeReportModal()">취소</button>
                <button class="btn-danger" onclick="submitReport()" style="margin-left:5px;">신고 접수</button>
            </div>
        </div>
    </div>

    <script>
        function openReportModal() {
            document.getElementById('reportModal').style.display = 'flex';
        }

        function closeReportModal() {
            document.getElementById('reportModal').style.display = 'none';
            document.getElementById('reportDetail').value = ''; 
            document.getElementById('reportReason').selectedIndex = 0;
        }

        function submitReport() {
            const reason = document.getElementById('reportReason').value;
            const detail = document.getElementById('reportDetail').value.trim();
            const boardId = '${post.boardId}'; 

            if (!detail) {
                alert('관리자가 확인할 수 있도록 상세 내용을 입력해주세요.');
                document.getElementById('reportDetail').focus();
                return;
            }

            if (!confirm('정말 이 게시글을 신고하시겠습니까?\n(허위 신고 시 활동에 불이익을 받을 수 있습니다.)')) {
                return;
            }

            const reportData = {
                boardId: boardId,
                reason: reason,
                detail: detail
            };

            fetch('/board/report', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(reportData)
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => { throw new Error(text) });
                }
                return response.text();
            })
            .then(data => {
                alert('신고가 정상적으로 접수되었습니다. 깨끗한 커뮤니티를 위한 노력에 감사드립니다!');
                closeReportModal();
            })
            .catch(error => {
                alert(error.message || '신고 처리 중 서버 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>