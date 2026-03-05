<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>세대 차량 관리 | APARTNERS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/layout.css">
    <link rel="stylesheet" href="/css/parking.css">
</head>
<body>
    
    <jsp:include page="../layout/header_sub.jsp">
        <jsp:param name="pageTitle" value="세대 차량 관리" />
    </jsp:include>
    
    <div class="page-wrapper" style="min-height: calc(100vh - 80px);">
        
        <jsp:include page="../layout/sidebar_parking.jsp" />

        <main class="content-area">
          
            <div class="page-header">
                <h2>세대 차량 관리</h2>
            </div>

            <section class="status-card">
                <div class="card-header">
                    <h3>🚗 실시간 구역별 현황</h3>
              
                    <span class="live-indicator"><i class="fa-solid fa-circle fa-beat-fade"></i> 실시간 집계중</span>
                </div>
                <div class="status-overview">
                    <div class="type-status-group">
                        <div class="type-badge"><span>일반차량</span><strong id="cntGeneral">450/600</strong></div>
        
                        <div class="type-badge ev"><span><i class="fa-solid fa-bolt"></i> 전기차</span><strong id="cntEV">20/30</strong></div>
                        <div class="type-badge disabled"><span><i class="fa-solid fa-wheelchair"></i> 장애인</span><strong id="cntDisabled">12/20</strong></div>
                    </div>
                    <div class="total-status-wrapper">
       
                         <div class="total-count" id="totalNow">482 <span class="total-max">/ 650</span></div>
                        <div class="total-label">전체 점유율 <span id="totalPercent">74</span>%</div>
                    </div>
                </div>
            </section>

  
            <section class="list-section">
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 15px;">
                    <div>
                        <h3>등록 차량 관리</h3>
                        <p style="font-size: 13px; color: var(--gray); margin-top: 5px;">* 세대당 1대 무료, 추가 차량은 3만원씩 관리비 청구</p>
                    </div>
                    <button class="btn-submit" style="width: auto; padding: 10px 20px;" onclick="openModal()"><i class="fa-solid fa-plus"></i> 차량 등록</button>
                </div>
                <table>
                    <thead>
                        <tr>
                 
                           <th>구분</th><th>차량번호</th><th>소유주/세대</th><th>등록일</th><th>상태</th><th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
 
                           <c:when test="${not empty myCars}">
                                <c:forEach var="car" items="${myCars}" varStatus="status">
                                   
                                 <tr>
                                        <td><span class="badge badge-h" style="background:var(--brand); color:white; padding:3px 8px; border-radius:4px;">세대</span></td>
                                        <td style="font-weight:700;">${car.carNumber}</td>
                                        <td>${sessionScope.loginMember.realName}</td>
                
                                        <td>${car.regDate}</td> 
                                        <td style="font-weight:700; color:${car.status == '등록완료' || car.status == '승인완료' ? 'var(--success)' : 'var(--warning)'}">
										    ${car.status} 
										    <span style="font-size:12px; color:var(--gray); display:block; font-weight:400;">
										        (${status.index == 0 ? '무료' : '30,000원'})
										    </span>
										</td>
                                        <td>
                                          
                                          <form action="/parking/delete" method="post" style="display:inline;" onsubmit="return confirm('이 차량을 삭제하시겠습니까?');">
                                                <input type="hidden" name="carNumber" value="${car.carNumber}">
                                        
                                                <button type="submit" class="btn-delete" style="border:1px solid #ddd; background:white; padding:4px 8px; border-radius:4px; cursor:pointer;">삭제</button>
                                            </form>
                                        </td>
                
                                    </tr>
                                </c:forEach>
                            </c:when>
                    
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align:center; padding:30px; color:#999;">등록된 차량이 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
             
                       </tbody>
                </table>
            </section>
        </main>
    </div>

    <div class="modal-overlay" id="parkingModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">세대 차량 등록</h2>
      
                  <button onclick="closeModal()" style="border:none; background:none; cursor:pointer; font-size:24px; color:var(--gray);">&times;</button>
            </div>
            <form action="/parking/register" method="post">
                <div class="form-group">
                    <label class="form-label">차량번호</label>
                    <input type="text" class="form-input" name="carNumber" placeholder="예: 12가 3456" required>
         
                </div>
                <div class="form-group">
                    <label class="form-label">비상 연락처</label>
                    <input type="tel" class="form-input" name="phone" placeholder="010-0000-0000" maxlength="13" required>
                </div>
            
                    <button type="submit" class="btn-submit">등록하기</button>
            </form>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />
    <script src="/js/parking.js"></script>
    
    <script>
        const msg = "${msg}";
        if (msg !== "") {
            alert(msg);
        }
    </script>
</body>
</html>