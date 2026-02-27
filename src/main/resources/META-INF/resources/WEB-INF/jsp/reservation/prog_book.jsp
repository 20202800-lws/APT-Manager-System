<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로그램 신청 | APARTNERS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/reservation.css">
</head>
<body>
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="예약 및 관리" />
    </jsp:include>

    <div class="page-wrapper" style="min-height: calc(100vh - 80px);">
        
        <jsp:include page="../layout/sidebar_reservation.jsp" />

        <main class="content-area">
            <div class="page-header">
                <h2>커뮤니티 프로그램 신청</h2>
            </div>

            <div id="view-program" style="margin-top: 20px;">
                <p class="section-desc" style="margin-bottom: 30px; color: #666;">전문 강사진과 함께하는 다양한 커뮤니티 프로그램을 만나보세요.</p>
                
                <div class="facility-grid">
                    <c:forEach var="prog" items="${programs}">
                        <div class="fac-card">
                            <div class="fac-icon" style="background: var(--primary-color);">🏃‍♂️</div>
                            <h4>${prog.progName}</h4>
                            <p style="color: #666; font-size: 14px; margin-bottom: 10px;">${prog.description}</p>
                            <ul style="list-style: none; padding: 0; margin-bottom: 15px; font-size: 13px; text-align: left; background: #f8f9fa; padding: 10px; border-radius: 5px;">
                                <li><strong>강사:</strong> ${prog.instructor}</li>
                                <li><strong>일시:</strong> ${prog.targetDay}</li>
                                <li><strong>수강료:</strong> ${prog.fee}원 / 월</li>
                                <li><strong>정원:</strong> ${prog.capacity}명</li>
                            </ul>
                            <button class="apply-btn" onclick="openProgramModal(${prog.progId}, '${prog.progName}', '${prog.fee}')" 
                                    style="width: 100%; padding: 10px; background: var(--primary-color); color: white; border: none; border-radius: 5px; cursor: pointer;">
                                신청하기
                            </button>
                        </div>
                    </c:forEach>
                </div>

                <div class="info-box" style="margin-top: 50px; background: #f8f9fa; padding: 25px; border-radius: 8px;">
                    <h3 style="margin-top: 0; margin-bottom: 15px;">프로그램 신청 안내</h3>
                    <table class="info-table" style="width: 100%; text-align: left;">
                        <tr><td style="padding: 8px 0; font-weight: bold; width: 120px;">신청 기간</td><td>매월 20일 09:00 ~ 말일 18:00 (선착순 마감)</td></tr>
                        <tr><td style="padding: 8px 0; font-weight: bold;">수강 기간</td><td>매월 1일 ~ 말일</td></tr>
                        <tr><td style="padding: 8px 0; font-weight: bold;">취소 및 환불</td><td>개강 3일 전까지 100% 환불, 이후 환불 규정에 따름</td></tr>
                        <tr><td style="padding: 8px 0; font-weight: bold;">유의사항</td><td>정원의 50% 미만 신청 시 폐강될 수 있습니다.</td></tr>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="programModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="progModalTitle">수강 신청</h3>
                <button class="close-btn" onclick="closeProgramModal()">×</button>
            </div>
            <div class="modal-body" id="progModalBody">
            </div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="/js/reservation.js"></script>
</body>
</html>