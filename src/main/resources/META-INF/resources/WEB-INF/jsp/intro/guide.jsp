<!-- 세대안내 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>세대안내 | APARTNERS</title>
    <link rel="stylesheet" href="/css/intro.css">
    <link rel="stylesheet" href="/css/layout.css">
</head>
<body>
    <jsp:include page="../layout/header_intro.jsp">
        <jsp:param name="pageTitle" value="단지안내" />
    </jsp:include>
	
    <div class="container">
		<jsp:include page="../layout/sidebar_intro.jsp">
		    <jsp:param name="activeMenu" value="guide" />
		</jsp:include>

        <main class="content-area">
            <section id="guide" class="tab-content active">
                <div class="content-header">
                    <h3>단지안내</h3>
                    <p>공간의 가치를 높이는 단지 안내입니다.</p>
                </div>
                <div class="img-box">
				<img src="/images/logo/backGroung.png" alt="단지정원">
 				<img src="/images/logo/skyRounge.png" alt="스카이라운지">   
				<img src="/images/logo/child1.png" alt="어린이집">             
  			 </div>
            </section>
        </main>
    </div>
	
    <jsp:include page="../layout/footer.jsp" />

    <script src="/js/intro.js"></script>
</body>
</html>