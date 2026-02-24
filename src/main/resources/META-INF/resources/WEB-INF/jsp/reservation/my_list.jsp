<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!--예약 내역관리-->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 내역 - Brain City</title>
  
	<link rel="stylesheet" href="../css/layout.css">
	<link rel="stylesheet" href="../css/reservation.css">
	
	</head>
<body>
	<jsp:include page="../layout/header_auth.jsp" />
	
	
<div class="wrapper">
    <aside>
        <div class="nav-group">
            <div class="nav-item" onclick="location.href='fac_book'">커뮤니티 시설 예약/신청</div>
            <div class="nav-item active" onclick="location.href='my_list'">예약/수강 내역</div>
        </div>
    </aside>

    <main>
        <div id="view-history">
            <p class="section-desc">나의 모든 예약 및 이용 내역</p>
            <table class="history-table">
                <thead>
                    <tr><th>시설명</th><th>상세 내용</th><th>이용 날짜/기간</th><th>상태</th><th>관리</th></tr>
                </thead>
                <tbody id="historyList">
                    </tbody>
            </table>
        </div>
    </main>
</div>

<jsp:include page="../layout/footer.jsp" />
<script src="/js/reservation.js"></script>
</body>
</html>