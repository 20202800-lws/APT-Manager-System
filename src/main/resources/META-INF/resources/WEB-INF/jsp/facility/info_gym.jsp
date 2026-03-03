<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>헬스장 | APARTNERS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/community.css">
</head>

<body>
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="커뮤니티 시설 안내" />
    </jsp:include>

    <div class="page-wrapper" style="min-height: calc(100vh - 80px);">

        <jsp:include page="../layout/sidebar_facility.jsp" />

        <main class="content-area">
            <div class="page-header">
                <h2>헬스장</h2>
            </div>

            <div class="facility-section active" style="margin-top: 0;">
                <div class="content-grid">
                    <div class="img-box" style="height: auto; box-shadow: none; overflow: visible;">
                        <img id="mainGymImg" src="/images/logo/health3.png" alt="헬스장" 
                             style="width: 100%; height: auto; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: transform 0.3s;">
                    </div>
                    <div class="info-box">
                        <h3><i class="fa-solid fa-dumbbell" style="color: #1a0b2e; margin-right: 8px;"></i>프리미엄 피트니스 공간</h3>
                        <p>최고급 유산소 및 웨이트 머신이 구비되어 있습니다. 입주민의 건강한 삶을 위한 최적의 환경을 제공합니다.</p>
                        <ul class="info-list">
                            <li><strong>위치:</strong> 커뮤니티센터 1층</li>
                            <li><strong>기구:</strong> 테크노짐 머신 30종, 런닝머신 20대</li>
                            <li><strong>운영시간:</strong> 06:00 ~ 23:00 (매월 첫째주 월요일 휴관)</li>
                            <li><strong>편의시설:</strong> 샤워실, 락커룸, 인바디 측정기</li>
                        </ul>
                        <table class="price-table">
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>이용요금</th>
                                    <th>비고</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>세대당 1인</td>
                                    <td>무료</td>
                                    <td>관리비 포함</td>
                                </tr>
                                <tr>
                                    <td>인원 추가 (1인)</td>
                                    <td>30,000원/월</td>
                                    <td>최대 2인 추가</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="notice-list">
                    <p class="important">※ 실내 운동화 착용 필수 (슬리퍼, 구두 입장 불가)</p>
                    <p>※ 중학생(14세) 이상부터 이용 가능합니다.</p>
                    <p>※ 사용한 기구 및 덤벨은 제자리에 정리해주시기 바랍니다.</p>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />
</body>

</html>