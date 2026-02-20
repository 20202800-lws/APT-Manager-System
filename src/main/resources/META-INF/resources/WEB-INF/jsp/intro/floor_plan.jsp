<!-- 평면도 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>평면도 | APARTNERS</title>
    <!--<link rel="stylesheet" href="${pageContext.request.contextPath}/css/intro.css">-->
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
                <li onclick="location.href='guide.jsp'">세대안내</li>
                <li class="active" onclick="location.href='floor_plan.jsp'">평면도</li>
            </ul>
        </aside>

        <main class="content-area">
            <section id="floorPlan" class="tab-content active">
                <div class="content-header">
                    <h3>평면도</h3>
                    <p>타입별 버튼을 클릭하여 도면을 확인하세요.</p>
                </div>
                
                <div class="plan-type-selector">
                    <button class="type-btn active" onclick="changePlan('59A', this)">59A</button>
                    <button class="type-btn" onclick="changePlan('59B', this)">59B</button>
                    <button class="type-btn" onclick="changePlan('84A', this)">84A</button>
                    <button class="type-btn" onclick="changePlan('84B', this)">84B</button>
                    <button class="type-btn" onclick="changePlan('84C', this)">84C</button>
                </div>

                <div class="img-box">
                    <img id="planImg" src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=1200" alt="평면도">
                    <h4 id="planTitle">59㎡ A TYPE</h4>
                </div>
            </section>
        </main>
    </div>
	<jsp:include page="../layout/footer.jsp" />

	<script src="intro.js"></script>
<!--    <script src="${pageContext.request.contextPath}/js/intro.js"></script>-->
</body>
</html>