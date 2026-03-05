<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>수영장 | APARTNERS</title>
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
                <h2>수영장 (INDOOR POOL)</h2>
            </div>

            <div class="facility-section active" style="margin-top: 0;">
                <div class="content-grid">
                    <div class="img-box" style="height: auto; box-shadow: none; overflow: visible;">
                        <img id="mainPoolImg" src="/images/logo/swimming2.jpg" alt="수영장 전경" 
                             style="max-width: 100%; height: 100%; border-radius: 12px;">
                    </div>
                    
                    <div class="info-box">
                        <h3><i class="fa-solid fa-person-swimming" style="color: #1a0b2e; margin-right: 8px;"></i>25m 4레인 정규 풀</h3>
                        <p>강습이 가능하고 유아풀이 있어 가족 단위로 사용할 수 있는 넓고 쾌적한 실내 수영장입니다.</p>
                        <ul class="info-list">
                            <li><strong>위치:</strong> 커뮤니티센터 B2층</li>
                            <li><strong>시설:</strong> 성인풀(25m x 4레인), 유아풀</li>
                            <li><strong>운영시간:</strong> 06:00 ~ 21:00 (수질정화: 12:00 ~ 13:00)</li>
                            <li><strong>수질관리:</strong> 인공 해수풀 시스템</li>
                        </ul>
                        <table class="price-table">
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>이용요금</th>
                                    <th>이용 시간</th>
                                    <th>비고</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>자유수영 (1일)</td>
                                    <td>3,000원</td>
                                    <td>강습 시간 외 이용 가능</td>
                                    <td>입주민 전용</td>
                                </tr>
                                <tr>
                                    <td>강습 (주3회)</td>
                                    <td>40,000원/월</td>
                                    <td>새벽 / 저녁 타임</td>
                                    <td>초/중/상급</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="notice-list">
                    <p class="important">※ 수영모 착용 필수 (캡모자 불가)</p>
                    <p>※ 신장 130cm 미만 어린이는 반드시 보호자와 동반 입수해야 합니다.</p>
                    <p>※ 오일, 화장품 등을 깨끗이 씻고 입장해주시기 바랍니다.</p>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../layout/footer.jsp" />
</body>

</html>