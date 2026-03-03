<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>단지안내 | APARTNERS</title>
    <link rel="stylesheet" href="/css/intro.css">
    <link rel="stylesheet" href="/css/layout.css">
</head>
<body>
    <jsp:include page="../layout/header_intro.jsp">
        <jsp:param name="pageTitle" value="단지안내" />
    </jsp:include>
	
    <div class="page-wrapper container">
        <jsp:include page="../layout/sidebar_intro.jsp">
            <jsp:param name="activeMenu" value="guide" />
        </jsp:include>

        <main class="content-area">
            <section id="guide" class="tab-content active">
                <div class="content-header">
                    <h3>단지안내</h3>
                    <p>공간의 가치를 높이는 단지 안내입니다.</p>
                </div>
                
                <div class="img-box" style="display: flex; flex-direction: column; gap: 30px; margin-top: 20px;">
                    <div class="guide-item">
                        <h4 style="margin-bottom:10px; color:#1a0b2e;">🌿 단지 정원</h4>
                        <img src="/images/logo/backGround.png" alt="단지정원" style="width:100%; border-radius:12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                    </div>
                    
                    <div class="guide-item">
                        <h4 style="margin-bottom:10px; color:#1a0b2e;">🏙️ 스카이라운지</h4>
                        <img src="/images/logo/skyLounge.png" alt="스카이라운지" style="width:100%; border-radius:12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                    </div>
                    
                    <div class="guide-item">
                        <h4 style="margin-bottom:10px; color:#1a0b2e;">🧸 단지 내 어린이집</h4>
                        <img src="/images/logo/child1.png" alt="어린이집" style="width:100%; border-radius:12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                    </div>
                </div>
            </section>
        </main>
    </div>
	
    <jsp:include page="../layout/footer.jsp" />

    <script src="/js/intro.js"></script>
</body>
</html>