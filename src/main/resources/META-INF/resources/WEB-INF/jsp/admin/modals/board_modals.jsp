<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<style>
			src/main/resources/static/css/admin.css
		</style>

		<div id="bannedModal" class="modal-overlay">
			<div class="modal-container">
				<div class="modal-header">
					<h3>🚫 금지어 관리 설정</h3>
					<button class="modal-close-btn" onclick="boardManager.closeModal('bannedModal')">
						<i class="fa-solid fa-xmark"></i>
					</button>
				</div>

				<div class="modal-body">
					<p style="font-size:0.9rem; color:#666; margin-bottom:15px; line-height:1.5;">
						등록된 단어가 포함된 게시글은 자동으로 블라인드 처리되거나 등록이 제한됩니다.
					</p>
					<textarea id="bannedInput" class="form-input"
						style="height:150px; resize:none; width:100%; padding:15px; line-height:1.6;"
						placeholder="금지어를 쉼표(,)로 구분하여 입력하세요.&#13;&#10;(예: 바보, 멍청이, 욕설)"></textarea>
				</div>

				<div class="modal-footer right-align">
					<button class="btn btn-secondary" onclick="boardManager.closeModal('bannedModal')">취소</button>
					<button class="btn btn-primary" onclick="boardManager.saveBannedWords()">설정 저장</button>
				</div>
			</div>
		</div>

		<div id="detailModal" class="modal-overlay">
			<div class="modal-container large">
				<div class="modal-header">
					<h3>게시글 상세 정보</h3>
					<button class="modal-close-btn" onclick="boardManager.closeModal('detailModal')">
						<i class="fa-solid fa-xmark"></i>
					</button>
				</div>

				<div class="modal-body">
					<input type="hidden" id="targetBoardId">

					<div id="postDetailContent"></div>

					<div style="margin-top:20px; padding-top:20px; border-top:1px dashed #ddd;">
						<label for="blindReason"
							style="font-weight:600; display:block; margin-bottom:10px; color:#e74c3c;">
							<i class="fa-solid fa-triangle-exclamation"></i> 관리 조치 사유 선택
						</label>
						<select id="blindReason" class="form-select" style="width:100%;">
							<option value="부적절한 홍보 게시물">부적절한 홍보 게시물</option>
							<option value="욕설 및 비방">욕설 및 비방</option>
							<option value="도배 및 스팸">도배 및 스팸</option>
							<option value="기타 사유">기타 사유</option>
						</select>
					</div>
				</div>

				<div class="modal-footer space-between">
					<button class="btn btn-secondary" style="color:#e74c3c; border-color:#e74c3c; background:#fff;"
						onclick="boardManager.executeAction('delete')" onmouseover="this.style.background='#ffeaea'"
						onmouseout="this.style.background='#fff'">
						<i class="fa-solid fa-trash"></i> 완전 삭제
					</button>

					<div style="display:flex; gap:10px;">
						<button class="btn btn-secondary" onclick="boardManager.closeModal('detailModal')">닫기</button>
						<button class="btn btn-primary" style="background:#e74c3c; border-color:#e74c3c;"
							onclick="boardManager.executeAction('blind')">
							<i class="fa-solid fa-eye-slash"></i> 블라인드 처리
						</button>
					</div>
				</div>
			</div>
		</div>