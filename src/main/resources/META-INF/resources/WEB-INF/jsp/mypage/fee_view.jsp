<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 관리비 상세조회</title>
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
	<link rel="stylesheet" href="/css/layout.css">
	<link rel="stylesheet" href="/css/mypage.css">
			
	</head>

<body>
		  	 <!--header sub로 바꾸기!(이미지도 완성되면)-->
			<jsp:include page="../layout/header_auth.jsp" />
<main class="container">
	<aside class="sidebar">
	    <h2>마이페이지</h2>
	    <nav class="menu-list">
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'info_view')">내 정보</button>
	        <button type="button" class="menu-item" onclick="changeMenu(this, 'info_edit')">정보 수정</button>
	        <button type="button" class="menu-item active" onclick="changeMenu(this, 'fee_view')">관리비</button>
	        
	        <div class="dropdown-grp">
	            <div class="menu-item">활동 내역 ▾</div>
	            <div class="sub-menu-side">
	                <button type="button" class="sub-item" onclick="changeMenu(this, 'act_reply')">내가 쓴 댓글</button>
	                <button type="button" class="sub-item" onclick="changeMenu(this, 'act_posts')">내가 쓴 게시물</button>
	            </div>
	        </div>
	    </nav>
	</aside>

    <div class="content-area">
        <div class="activity-header">
            <h3 id="pageTitle">💳 관리비 조회 / 상세 내역</h3>
            <div class="select-month">
                <select id="monthSelector" onchange="updateMonthDetail()"></select>
            </div>
        </div>

        <div id="viewSection" class="fee-section active">
            <div class="fee-summary-banner">
                <div class="banner-txt">
                    <p id="targetMonthTxt">부과금액</p>
                    <h2 id="totalAmountDisplay">0<span>원</span></h2>
                    <span id="paymentBadge" class="status-badge">상태</span>
                </div>
                <div class="banner-status" style="text-align: right;">
                    <p>납부기한: <span id="dueDateTxt">0000.00.00</span></p>
                    <p style="margin-top:10px; font-size:13px; opacity:0.7;">가상계좌: 우리은행 1002-XXX-XXXXXX</p>
                </div>
            </div>

            <div class="graph-section">
                <div class="graph-header">
                    <div class="graph-tabs">
                        <button class="tab-btn active" onclick="setGraphMode('electric', this)">⚡ 전기</button>
                        <button class="tab-btn" onclick="setGraphMode('heating', this)">🔥 난방</button>
                        <button class="tab-btn" onclick="setGraphMode('total', this)">💰 총액</button>
                    </div>
                    <span id="usageCompareTxt" style="font-size:14px; font-weight:600;"></span>
                </div>
                <div class="graph-container" id="usageGraph">
                    </div>
            </div>

            <div class="detail-box">
                <h4>🔍 상세 부과 명세서</h4>
                <table class="luxury-table">
                    <thead>
                        <tr><th style="width:25%">항목명</th><th style="width:50%">상세 설명</th><th style="width:25%">금액(원)</th></tr>
                    </thead>
                    <tbody id="feeTableBody"></tbody>
                    <tfoot>
                        <tr class="total-row">
                            <td colspan="2">당월 부과 합계액</td>
                            <td class="final-price" id="finalPriceSum">0</td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

        <div id="paySection" class="fee-section">
            <div class="payment-card">
                <h4 id="paySectionTitle">💳 관리비 납부</h4>
                <div class="pay-info">
                    <div class="pay-row"><span>청구 월분</span><strong id="payMonthTxt"></strong></div>
                    <div class="pay-row"><span>납부하실 금액</span><strong class="amount" id="payAmountTxt"></strong></div>
                    <div class="pay-row"><span>납부 상태</span><strong id="payStatusTxt"></strong></div>
                </div>
                <div class="method-grid">
                    <label class="method-box"><input type="radio" name="p-method" checked><span>신용/체크카드</span></label>
                    <label class="method-box"><input type="radio" name="p-method"><span>계좌이체</span></label>
                    <label class="method-box"><input type="radio" name="p-method"><span>간편결제</span></label>
                </div>
                <button id="btnPay" class="btn-primary-pay" onclick="alert('결제 페이지로 이동합니다.')">결제하기</button>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../layout/footer.jsp" />
<script src="mypage.js"></script>

</body>
</html>
