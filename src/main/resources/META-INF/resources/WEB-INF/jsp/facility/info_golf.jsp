<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스크린골프 | APARTNERS</title>
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
                <h2>스크린골프 (GOLF ZONE)</h2>
            </div>

            <div class="facility-section active" style="margin-top: 0;">
                <div class="content-grid">
                    <div class="img-box">
                        <img id="mainGolfImg" src="/images/logo/golf3.png" alt="골프장" style="max-width: 100%; height: auto; border-radius: 12px;">
                    </div>
                    <div class="info-box">
                        <h3>최신 GDR 시스템 완비</h3>
                        <p>실제 필드와 같은 생동감을 느낄 수 있는 최신식 스크린 골프 시설입니다. 입주민들의 건전한 여가생활과 체력단련을 위한 공간입니다.</p>
                        <ul class="info-list">
                            <li><strong>위치:</strong> 커뮤니티센터 B1층</li>
                            <li><strong>타석:</strong> 5타석 (좌타석 1개 보유)</li>
                            <li><strong>운영시간:</strong> 06:00 ~ 23:00 (연중무휴)</li>
                            <li><strong>이용대상:</strong> 입주민 전용 (예약 필수)</li>
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
                                    <td>1회 이용 (60분)</td>
                                    <td>10,000원</td>
                                    <td>앱 예약</td>
                                </tr>
                                <tr>
                                    <td>월 정기권</td>
                                    <td>150,000원</td>
                                    <td>1일 1회</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="notice-list">
                    <p class="important">※ 개인 클럽 사용을 권장하며, 연습용 클럽이 비치되어 있습니다.</p>
                    <p>※ 안전사고 예방을 위해 타석 외 스윙 연습은 금지됩니다.</p>
                    <p>※ 예약 시간 10분 경과 시 예약이 자동 취소됩니다.</p>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />
</body>

</html>