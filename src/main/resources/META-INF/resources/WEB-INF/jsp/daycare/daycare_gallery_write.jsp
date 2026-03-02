<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>어린이집 - 갤러리 사진 등록</title>
    <link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/board.css'/>">
</head>
<body>
	<jsp:include page="../layout/header_sub.jsp">
	    <jsp:param name="pageTitle" value="어린이집" />
	</jsp:include>

    <div class="container">
        <jsp:include page="../layout/sidebar_board.jsp">
            <jsp:param name="activeMenu" value="daycare_gallery" />
        </jsp:include>

        <main id="mainArea">
            <h3 style="font-size:24px; margin-bottom:20px; border-bottom:2px solid #1a0b2e; padding-bottom:15px;">활동 사진 등록</h3>
            
            <div class="content-box">
                <form action="<c:url value='/daycare/gallery/write'/>" method="post" enctype="multipart/form-data">
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">활동 제목</label>
                        <input type="text" name="title" placeholder="어떤 활동이었나요? (예: 즐거운 체육시간)" required 
                               style="width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; font-size:16px;">
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px;">활동 내용 (선택)</label>
                        <textarea name="content" placeholder="아이들의 즐거웠던 모습을 짧게 남겨주세요." 
                                  style="width:100%; height:150px; padding:12px; border:1px solid #ddd; border-radius:6px; font-size:15px; resize:vertical;"></textarea>
                    </div>

                    <div class="form-group" style="margin-bottom: 30px; background-color:#f8fafc; padding:20px; border-radius:8px; border:1px dashed #cbd5e1;">
                        <label style="display:block; font-weight:bold; margin-bottom:8px; color:#1e293b;">📸 사진 다중 첨부 (필수)</label>
                        <p style="font-size:13px; color:#64748b; margin-bottom:10px;">Shift키나 Ctrl키를 누른 상태로 여러 장의 사진을 한 번에 선택할 수 있습니다.</p>
                        <input type="file" name="uploadFiles" multiple accept="image/*" required
                               style="width:100%; font-size:15px;">
                    </div>

                    <div style="text-align:right; border-top:1px solid #eee; padding-top:20px;">
                        <button type="button" class="btn-sub" onclick="history.back()">취소</button>
                        <button type="submit" class="btn-main" style="margin-left:8px;">사진 등록하기</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    <jsp:include page="../layout/footer.jsp" />
</body>
</html>