<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>평면도 | APARTNERS</title>
    <link rel="stylesheet" href="/css/intro.css">
    <link rel="stylesheet" href="/css/layout.css">
</head>
<body>
    <jsp:include page="../layout/header_intro.jsp">
        <jsp:param name="pageTitle" value="평면도" />
    </jsp:include>

    <div class="page-wrapper container">
        <jsp:include page="../layout/sidebar_intro.jsp">
            <jsp:param name="activeMenu" value="floor_plan" />
        </jsp:include>

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

                <div class="img-box" style="margin-top: 20px; text-align: center;">
                    <img id="planImg" src="/images/logo/59A.png" alt="평면도" style="max-width: 100%; height: auto; border-radius: 12px; border: 1px solid #eee;">
                    <h4 id="planTitle" style="margin-top:15px; color:#1a0b2e;">59㎡ A TYPE</h4>
                </div>
            </section>
        </main>
    </div>
    
    <jsp:include page="../layout/footer.jsp" />

    <script src="/js/intro.js"></script>
</body>
</html>