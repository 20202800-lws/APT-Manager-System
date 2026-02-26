<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 관리비</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
    <jsp:include page="../layout/header_intro.jsp">
        <jsp:param name="pageTitle" value="마이페이지" />
    </jsp:include>

    <div class="page-wrapper" style="min-height: calc(100vh - 80px);">
        
        <jsp:include page="../layout/sidebar_mypage.jsp">
            <jsp:param name="activeMenu" value="fee_view" />
        </jsp:include>

        <main class="content-area">
            
            <div class="activity-header">
                <h3>💳 관리비 상세 조회</h3>
                <div class="select-month">
                    <select id="monthSelector" onchange="updateMonthDetail()">
                        </select>
                </div>
            </div>

            <div id="viewSection" class="active">
                
                <div class="fee-summary-banner">
                    <div class="banner-txt">
                        <h2 id="targetMonthTxt">00월분 총 부과금액</h2>
                        <p style="opacity: 0.8; margin-top: 5px;">납부기한: <span id="dueDateTxt"></span></p>
                    </div>
                    <div style="text-align: right;">
                        <span id="paymentBadge" class="status-badge"></span>
                        <div id="totalAmountDisplay" style="font-size: 42px; font-weight: 800; margin-top: 10px;">0<span>원</span></div>
                    </div>
                </div>

                <div class="graph-section">
                    <div class="graph-header">
                        <h4 style="font-size: 18px; color: var(--primary); font-weight: 700;">📈 사용량 추이</h4>
                        <div style="display:flex; gap:10px;">
                            <button class="tab-btn active" onclick="setGraphMode('electric', this)">전기</button>
                            <button class="tab-btn" onclick="setGraphMode('heating', this)">난방</button>
                            <button class="tab-btn" onclick="setGraphMode('total', this)">총액</button>
                        </div>
                    </div>
                    <div id="usageGraph" class="graph-container"></div>
                </div>

                <h4 style="font-size: 18px; color: var(--primary); font-weight: 700; margin-bottom: 15px;">🧾 상세 부과 내역</h4>
                <table class="luxury-table">
                    <colgroup>
                        <col width="30%">
                        <col width="45%">
                        <col width="25%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>항목명</th>
                            <th>비고/설명</th>
                            <th style="text-align: right;">청구금액</th>
                        </tr>
                    </thead>
                    <tbody id="feeTableBody">
                        </tbody>
                    <tfoot>
                        <tr class="total-row">
                            <td colspan="2" style="text-align: center;">총 합계</td>
                            <td id="finalPriceSum" style="text-align: right; color: var(--primary);">0원</td>
                        </tr>
                    </tfoot>
                </table>
                
                <div style="text-align: right; margin-top: 30px;">
                    <button id="btnPay" class="btn-primary-pay" style="width: auto; padding: 15px 50px;">결제하기</button>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script>
        const feeData = ${not empty jsonFeeData ? jsonFeeData : '{}'};
    </script>
    
    <script src="/js/mypage.js"></script>
</body>
</html>