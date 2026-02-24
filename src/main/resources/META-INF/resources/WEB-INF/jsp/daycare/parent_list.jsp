<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<meta charset="UTF-8">
			<title>어린이집 - 학부모 의견란</title>
			<link rel="stylesheet" href="<c:url value='/css/layout.css'/>">
			<link rel="stylesheet" href="<c:url value='/css/board.css'/>">
			<style>
				/* 피드 전용 스타일 */
				.feed-write-box {
					background: #f8fafc;
					border: 1px solid #e2e8f0;
					border-radius: 12px;
					padding: 20px;
					margin-bottom: 40px;
				}

				.feed-item {
					background: #ffffff;
					border: 1px solid #eee;
					border-radius: 12px;
					padding: 20px;
					margin-bottom: 20px;
					box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
				}

				.feed-header {
					display: flex;
					justify-content: space-between;
					align-items: center;
					margin-bottom: 12px;
					border-bottom: 1px solid #f1f5f9;
					padding-bottom: 10px;
				}

				.feed-author {
					font-weight: 700;
					color: #1a0b2e;
					font-size: 16px;
				}

				.feed-date {
					color: #888;
					font-size: 13px;
				}

				.feed-content {
					font-size: 15px;
					color: #333;
					line-height: 1.6;
					white-space: pre-wrap;
				}

				.feed-actions {
					margin-top: 15px;
					text-align: right;
				}
			</style>
		</head>

		<body>
			<jsp:include page="../layout/header_sub.jsp">
			    <jsp:param name="pageTitle" value="어린이집" />
			</jsp:include>

			<div class="container">
				<jsp:include page="../layout/sidebar_board.jsp">
					<jsp:param name="activeMenu" value="daycare_parent" />
				</jsp:include>

				<main id="mainArea">
					<h3 style="font-size:24px; margin-bottom:20px;">학부모 의견란</h3>

					<div class="feed-write-box">
						<form action="<c:url value='/daycare/parent/write'/>" method="post">
							<textarea name="content" placeholder="어린이집 운영에 대한 소중한 의견이나 건의사항을 자유롭게 남겨주세요." required
								style="width:100%; box-sizing:border-box; height:100px; padding:15px; border:1px solid #cbd5e1; border-radius:8px; font-size:15px; resize:vertical; margin-bottom:15px;"></textarea>

							<div style="display: flex; justify-content: space-between; align-items: center;">
								<span style="font-size: 13px; color: #64748b;">※ 작성하신 의견은 원장님과 선생님, 그리고 다른 학부모님들과
									공유됩니다.</span>
								<button type="submit" class="btn-main" style="padding: 10px 25px;">의견 등록하기</button>
							</div>
						</form>
					</div>

					<div id="feedContainer">
					</div>

				</main>
			</div>
			<jsp:include page="../layout/footer.jsp" />

			<script src="<c:url value='/js/daycare/daycare_parent.js'/>"></script>
		</body>

		</html>