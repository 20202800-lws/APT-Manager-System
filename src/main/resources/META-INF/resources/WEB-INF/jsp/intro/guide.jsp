<!-- 세대안내 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>세대안내 | APARTNERS</title>
   <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/intro.css">-->

	<link rel="stylesheet" href="css/intro.css">
	<link rel="stylesheet" href="/css/layout.css">
	</head>
<body>
	<!--header sub로 바꾸기!(이미지도 완성되면)-->
	<jsp:include page="../layout/header_auth.jsp" />
	
    <div class="container">
        <aside class="sidebar">
            <h2>아파트 소개</h2>
            <ul class="lnb">
                <li onclick="location.href='layout.jsp'">단지배치도</li>
                <li class="active" onclick="location.href='guide.jsp'">세대안내</li>
                <li onclick="location.href='floor_plan.jsp'">평면도</li>
            </ul>
        </aside>

        <main class="content-area">
            <section id="guide" class="tab-content active">
                <div class="content-header">
                    <h3>세대안내</h3>
                    <p>공간의 가치를 높이는 세대별 안내입니다.</p>
                </div>
                <div class="img-box">
                    <img src="https://images.unsplash.com/photo-1600607687940-c52af0424225?auto=format&fit=crop&w=1200" alt="세대안내">
                </div>
            </section>
        </main>
    </div>
	
	<jsp:include page="../layout/footer.jsp" />

	<script src="intro.js"></script>
</body>
</html>