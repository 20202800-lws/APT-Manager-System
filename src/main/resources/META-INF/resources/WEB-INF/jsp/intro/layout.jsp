<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>단지배치도 | APARTNERS</title>
    <link rel="stylesheet" href="/css/intro.css">
    <link rel="stylesheet" href="/css/layout.css">
</head>
<body>
    <jsp:include page="../layout/header_intro.jsp">
        <jsp:param name="pageTitle" value="단지배치도" />
    </jsp:include>

    <div class="page-wrapper container">
        <jsp:include page="../layout/sidebar_intro.jsp">
            <jsp:param name="activeMenu" value="layout" />
        </jsp:include>

        <main class="content-area">
            <section id="sitePlan" class="tab-content active">
                <div class="content-header">
                    <h3>단지배치도</h3>
                    <p>프리미엄 라이프의 시작, 단지 배치도를 확인하세요.</p>
                </div>
                
                <div class="img-box" style="display: flex; flex-direction: column; gap: 30px; margin-top: 20px; text-align: center;">
                    <img src="/images/logo/apart6.png" alt="단지배치도 1" style="max-width: 100%; height: auto; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                    <img src="/images/logo/apart7.png" alt="단지배치도 2" style="max-width: 100%; height: auto; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                </div>
            </section>
        </main>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />

    <script src="/js/intro.js"></script>
</body>
</html>