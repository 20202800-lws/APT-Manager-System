<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 내역 | APARTNERS</title>
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
                <h2>예약/수강 내역</h2>
            </div>

            <div id="view-history" style="margin-top: 20px;">
                <p class="section-desc" style="margin-bottom: 20px; color: #666;">나의 모든 예약 및 강습 이용 내역입니다.</p>
                <table class="history-table" style="width: 100%; border-collapse: collapse; text-align: center;">
                    <thead style="background: var(--primary-color, #1a0b2e); color: white;">
                        <tr>
                            <th style="padding: 12px;">구분</th>
                            <th style="padding: 12px;">시설/프로그램명</th>
                            <th style="padding: 12px;">이용 날짜/기간</th>
                            <th style="padding: 12px;">결제금액</th>
                            <th style="padding: 12px;">상태</th>
                            <th style="padding: 12px;">관리</th>
                        </tr>
                    </thead>
                    <tbody id="historyList">
                        
                        <c:forEach var="fac" items="${facilityList}">
                            <tr>
                                <td style="padding:15px;"><b>${fac.facilityType}</b></td>
                                <td>${fac.detailInfo}</td>
                                <td>${fac.reserveDate}</td>
                                <td style="font-weight:600; color:var(--primary-color);">${fac.price}</td>
                                <td>
                                    <span class="${fac.resStatus == '취소됨' ? 'badge-cancel' : 'badge-active'}">${fac.resStatus}</span>
                                </td>
                                <td>
                                    <c:if test="${fac.resStatus != '취소됨'}">
                                        <button class="btn-cancel" onclick="cancelReservation(${fac.resId}, 'facility')">취소</button>
                                    </c:if>
                                    <c:if test="${fac.resStatus == '취소됨'}">-</c:if>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:forEach var="prog" items="${programList}">
                            <tr>
                                <td style="padding:15px;"><b>강습신청</b></td>
                                <td>${prog.program.progName}</td>
                                <td>매월 1일 시작</td>
                                <td style="font-weight:600; color:var(--primary-color);">${prog.program.fee}원</td>
                                <td>
                                    <span class="${prog.applyStatus == '취소됨' ? 'badge-cancel' : 'badge-active'}">${prog.applyStatus}</span>
                                </td>
                                <td>
                                    <c:if test="${prog.applyStatus != '취소됨'}">
                                        <button class="btn-cancel" onclick="cancelReservation(${prog.applyId}, 'program')">취소</button>
                                    </c:if>
                                    <c:if test="${prog.applyStatus == '취소됨'}">-</c:if>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty facilityList and empty programList}">
                            <tr>
                                <td colspan="6" style="padding: 20px; color: #888;">예약 내역이 없습니다.</td>
                            </tr>
                        </c:if>

                    </tbody>
                </table>
                
                <div id="pagination" class="pagination-container"></div>
                
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="/js/reservation.js"></script>
</body>
</html>