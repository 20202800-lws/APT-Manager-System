<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<title>관리자 | 시스템 감사 로그</title>
			<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap"
				rel="stylesheet">
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
			<link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
		</head>

		<body>

			<div class="admin-container">

				<jsp:include page="../layout/admin_sidebar.jsp" />

				<main class="main-content">

					<div class="content-header">
						<h2>시스템 감사 로그</h2>
						<div class="subtitle">시스템 변경 이력을 조회합니다.</div>
					</div>

					<div class="content-box">

						<div class="section-header"
							style="display: flex; justify-content: space-between; align-items: center;">
							<h3 class="section-title" style="margin: 0;">로그 목록</h3>
							<div class="section-actions" style="display: flex; gap: 10px; align-items: center;">

								<select id="severityFilter" class="form-select" onchange="searchLogs()">
									<option value="ALL">전체</option>
									<option value="INFO">정보</option>
									<option value="WARNING">경고</option>
									<option value="ERROR">에러</option>
								</select>

								<input type="text" id="keyword" class="form-input" placeholder="사용자, IP, 내용 검색"
									onkeyup="if(event.keyCode===13) searchLogs()">

								<button class="btn btn-primary" onclick="searchLogs()">
									<i class="fa-solid fa-search"></i> 검색
								</button>

							</div>
						</div>

						<table class="admin-table">
							<thead>
								<tr>
									<th width="120">중요도</th>
									<th width="200">일시</th>
									<th width="100">사용자</th>
									<th width="120">카테고리</th>
									<th>내용</th>
									<th width="160">IP</th>
								</tr>
							</thead>
							<tbody id="logTableBody">
							</tbody>
						</table>

						<div id="paginationWrapper" style="margin-top:20px; text-align:center;"></div>

					</div>
				</main>
			</div>

			<script>
				window.globalLogList = [];

				<c:if test="${not empty logList}">
					<c:forEach var="log" items="${logList}">
						window.globalLogList.push({
							severity: '${log.severity}',
						createdAt: '${log.createdAt}',
						username: '${log.username}',
						category: '${log.category}',
						content: '${log.content}',
						sourceIp: '${log.sourceIp}'
            });
					</c:forEach>
				</c:if>
			</script>

			<script src="<c:url value='/js/admin/admin_common.js'/>"></script>
			<script src="<c:url value='/js/admin/systemLog.js'/>"></script>

		</body>

		</html>