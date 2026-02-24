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
        <jsp:param name="pageTitle" value="세대안내" />
    </jsp:include>
	
    <div class="container">
		<jsp:include page="../layout/sidebar_intro.jsp">
		    <jsp:param name="activeMenu" value="guide" />
		</jsp:include>

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

    <script src="/js/intro.js"></script>
</body>
</html>