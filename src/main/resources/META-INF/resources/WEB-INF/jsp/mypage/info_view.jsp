<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 내 정보</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/mypage.css">
    <style>
        /* 3단 가로 레이아웃 강제 적용 */
        .info-card-flex {
            display: flex;
            flex-direction: row;
            gap: 30px;
            align-items: stretch;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
        }

        .flex-col-1 {
            flex: 1;
            text-align: center;
            border-right: 1px solid #eee;
            padding-right: 20px;
        }

        .flex-col-2 {
            flex: 1.5;
            border-right: 1px solid #eee;
            padding-right: 20px;
        }

        .flex-col-3 {
            flex: 1;
        }
    </style>
</head>

<body>
    <jsp:include page="../layout/header_intro.jsp">
        <jsp:param name="pageTitle" value="마이페이지" />
    </jsp:include>

    <div class="page-wrapper" style="min-height: calc(100vh - 80px);">

        <jsp:include page="../layout/sidebar_mypage.jsp">
            <jsp:param name="activeMenu" value="info_view" />
        </jsp:include>

        <main class="content-area">
            <div class="page-header">
                <h2>내 정보</h2>
            </div>

            <div class="info-card-flex" style="margin-top: 20px;">

                <div class="flex-col-1 profile-img-area">
                    <img src="${empty userInfo.profileImg ? '/images/default_profile.png' : userInfo.profileImg}"
                        alt="프로필">
                    <h3 style="margin-top:15px; font-size:18px;">${userInfo.realName} 입주민님</h3>
                    <p style="color:#666; font-size:14px;">환영합니다!</p>
                </div>

                <div class="flex-col-2 info-details">
                    <h3 style="border-bottom: 2px solid #1a0b2e; padding-bottom: 10px; margin-bottom: 15px;">📝 기본 정보</h3>
                    <div class="info-row">
                        <div class="info-label">아이디</div>
                        <div class="info-value">${userInfo.userId}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">동 / 호수</div>
                        <div class="info-value">${userInfo.dong}동 ${userInfo.ho}호</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">전화번호</div>
                        <div class="info-value">${userInfo.phone}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">이메일</div>
                        <div class="info-value">${userInfo.email}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">가입일</div>
                        <div class="info-value">${formattedJoinDate}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">등록 차량</div>
                        <div class="info-value" style="color:var(--accent-color); font-weight:bold;">${myVehicle}</div>
                    </div>
                </div>

                <div class="flex-col-3 settings-area">
                    <h4 style="margin-bottom: 15px;">🔔 알림 설정</h4>

                    <div class="toggle-row">
                        <span class="toggle-label">이메일 알림</span>
                        <label class="switch">
                            <input type="checkbox" onchange="toggleAlert('email', this.checked)" checked>
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div class="toggle-row">
                        <span class="toggle-label">문자 알림</span>
                        <label class="switch">
                            <input type="checkbox" onchange="toggleAlert('sms', this.checked)" checked>
                            <span class="slider"></span>
                        </label>
                    </div>
                    <div class="toggle-row">
                        <span class="toggle-label">커뮤니티 알림</span>
                        <label class="switch">
                            <input type="checkbox" onchange="toggleAlert('comm', this.checked)">
                            <span class="slider"></span>
                        </label>
                    </div>

                    <div style="margin-top: 40px; border-top: 1px solid #ddd; padding-top: 20px;">
                        <button type="button" onclick="openWithdrawModal()" style="width: 100%; padding: 12px; background: #e74c3c; color: white; border: none; border-radius: 6px; font-size: 15px; font-weight: bold; cursor: pointer; transition: 0.2s;">회원 탈퇴하기</button>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <div id="withdrawModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 9999; justify-content: center; align-items: center;">
        <div style="background: #fff; padding: 40px; border-radius: 12px; width: 400px; max-width: 90%; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.2);">
            <h3 style="color: #e74c3c; font-size: 22px; margin-bottom: 15px;">⚠️ 회원 탈퇴 안내</h3>
            <p style="font-size: 15px; color: #555; line-height: 1.6; text-align: left; margin-bottom: 25px; background: #f8f9fa; padding: 15px; border-radius: 8px;">
                탈퇴 시 고객님의 모든 개인정보는 관련 법령에 의거하여<br>
                <strong>탈퇴일로부터 1년 동안 안전하게 보관</strong>된 후<br>
                영구적으로 파기됩니다.<br><br>
                정말로 탈퇴하시겠습니까?
            </p>
            
            <form action="/mypage/withdraw" method="post" id="withdrawForm">
                <label style="display: flex; align-items: center; justify-content: center; gap: 10px; cursor: pointer; margin-bottom: 25px; font-weight: 600; color: #333;">
                    <input type="checkbox" id="withdrawAgree" style="width: 18px; height: 18px; cursor: pointer;">
                    위 안내 사항을 확인하였으며, 탈퇴에 동의합니다.
                </label>
                
                <div style="display: flex; gap: 10px;">
                    <button type="button" onclick="closeWithdrawModal()" style="flex: 1; padding: 12px; background: #cbd5e1; color: #333; border: none; border-radius: 6px; font-weight: bold; cursor: pointer;">취소</button>
                    <button type="submit" id="btnFinalWithdraw" disabled style="flex: 1; padding: 12px; background: #e74c3c; color: #fff; border: none; border-radius: 6px; font-weight: bold; cursor: not-allowed; opacity: 0.5;">탈퇴 처리</button>
                </div>
            </form>
        </div>
    </div>

    <script src="/js/mypage.js"></script>
    <script>
        // 백엔드 API로 알림 설정 상태 쏘기
        function toggleAlert(type, status) {
            fetch(`/mypage/api/toggle-alert?type=\${type}&status=\${status}`, {method: 'POST'})
                .then(res => {
                    if (!res.ok) alert("알림 설정 변경에 실패했습니다.");
                });
        }

        // 모달 열기/닫기 제어
        function openWithdrawModal() {
            document.getElementById('withdrawModal').style.display = 'flex';
        }

        function closeWithdrawModal() {
            document.getElementById('withdrawModal').style.display = 'none';
            document.getElementById('withdrawAgree').checked = false; // 체크박스 초기화
            const btn = document.getElementById('btnFinalWithdraw');
            btn.disabled = true;
            btn.style.opacity = '0.5';
            btn.style.cursor = 'not-allowed';
        }

        // 체크박스 클릭 시 '탈퇴 처리' 버튼 활성화/비활성화
        document.getElementById('withdrawAgree').addEventListener('change', function() {
            const btn = document.getElementById('btnFinalWithdraw');
            if(this.checked) {
                btn.disabled = false;
                btn.style.opacity = '1';
                btn.style.cursor = 'pointer';
            } else {
                btn.disabled = true;
                btn.style.opacity = '0.5';
                btn.style.cursor = 'not-allowed';
            }
        });
    </script>

    <c:if test="${not empty msg}">
        <script>alert("${msg}");</script>
    </c:if>
</body>

</html>