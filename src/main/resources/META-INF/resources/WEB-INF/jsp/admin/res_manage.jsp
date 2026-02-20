<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 시설 관리</title>
    <link rel="stylesheet" href="/css/admin-style.css">
    <style>
        /* 점검 중(Maintenance) 상태일 때의 스타일 */
        .fac-item.on {
            border: 1px solid #ffebee !important;
            background-color: #fff5f5 !important;
        }
        .fac-item.on .form-input {
            background-color: #ffffff;
        }
    </style>
</head>
<body>

    <div class="admin-container">
        <main class="main-content">
            
            <div class="content-header">
                <h2>커뮤니티 시설 관리</h2>
                <div class="subtitle">📅 2026-02-10 실시간 현황</div>
            </div>

            <div class="stat-grid-container grid-4">
                <div class="stat-card border-left-primary" onclick="facilityManager.openHistory('profit')">
                    <h3>이번 달 수익</h3>
                    <div class="number">₩4,250,000</div> 
                    <div class="desc text-primary">목표 달성중</div>
                </div>
                <div class="stat-card border-left-danger" onclick="facilityManager.openHistory('maintenance')">
                    <h3>유지보수 지출</h3>
                    <div class="number text-danger">₩1,120,000</div>
                    <div class="desc">전월 대비 감소</div>
                </div>
                <div class="stat-card border-left-success" onclick="facilityManager.openHistory('net')">
                    <h3>이번 달 순수익</h3>
                    <div class="number text-success">₩3,130,000</div>
                    <div class="desc">안정적</div>
                </div>
                <div class="stat-card border-left-info" onclick="facilityManager.openHistory('users')">
                    <h3>이용객 수</h3>
                    <div class="number">1,242명</div>
                    <div class="desc">실시간 집계</div>
                </div>
            </div>

            <div class="content-box">
                <div class="section-header">
                    <div class="section-title">🛠️ 시설 실시간 점검 설정</div>
                </div>
                
                <div class="grid-4" style="display: grid; gap: 20px;">
                    <div class="fac-item" id="fac-card-POOL" data-fac-id="POOL" data-available="1" 
                         style="border:1px solid var(--border-color); padding:20px; border-radius:12px;">
                        <h4 style="margin-bottom:10px; font-weight:700;">🏊 수영장</h4>
                        <input type="text" class="form-input" value="정상 운영 중" style="width:100%; margin-bottom:10px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span class="badge badge-green tgl-label">운영 중</span>
                            <button class="btn btn-secondary btn-xs" onclick="facilityManager.toggleFac('POOL')">상태변경</button>
                        </div>
                    </div>

                    <div class="fac-item" id="fac-card-GYM" data-fac-id="GYM" data-available="1" 
                         style="border:1px solid var(--border-color); padding:20px; border-radius:12px;">
                        <h4 style="margin-bottom:10px; font-weight:700;">🏋️ 헬스장</h4>
                        <input type="text" class="form-input" value="정상 운영 중" style="width:100%; margin-bottom:10px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span class="badge badge-green tgl-label">운영 중</span>
                            <button class="btn btn-secondary btn-xs" onclick="facilityManager.toggleFac('GYM')">상태변경</button>
                        </div>
                    </div>

                    <div class="fac-item on" id="fac-card-GOLF" data-fac-id="GOLF" data-available="0" 
                         style="border:1px solid #ffebee; background:#fff5f5; padding:20px; border-radius:12px;">
                        <h4 style="margin-bottom:10px; font-weight:700;">⛳ 골프장</h4>
                        <input type="text" class="form-input" value="타석 교체 작업" style="width:100%; margin-bottom:10px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span class="badge badge-red tgl-label">점검 중</span>
                            <button class="btn btn-secondary btn-xs" onclick="facilityManager.toggleFac('GOLF')">상태변경</button>
                        </div>
                    </div>

                    <div class="fac-item" id="fac-card-GUEST" data-fac-id="GUEST" data-available="1" 
                         style="border:1px solid var(--border-color); padding:20px; border-radius:12px;">
                        <h4 style="margin-bottom:10px; font-weight:700;">🏠 게스트하우스</h4>
                        <input type="text" class="form-input" value="정상 운영 중" style="width:100%; margin-bottom:10px;">
                        <div style="display:flex; justify-content:space-between; align-items:center;">
                            <span class="badge badge-green tgl-label">운영 중</span>
                            <button class="btn btn-secondary btn-xs" onclick="facilityManager.toggleFac('GUEST')">상태변경</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="content-box">
                <div class="section-header">
                    <div class="section-title">📅 시설별 예약 현황</div>
                </div>

                <div class="tab-wrapper">
                    <div class="tab-container">
                        <button class="tab-btn active" onclick="facilityManager.filterRes('ALL', this)">전체</button>
                        <button class="tab-btn" onclick="facilityManager.filterRes('POOL', this)">수영장</button>
                        <button class="tab-btn" onclick="facilityManager.filterRes('GYM', this)">헬스장</button>
                        <button class="tab-btn" onclick="facilityManager.filterRes('GOLF', this)">골프장</button>
                        <button class="tab-btn" onclick="facilityManager.filterRes('GUEST', this)">게스트하우스</button>
                    </div>
                </div>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>시설명</th> <th>예약자</th> <th>동/호수</th> <th>이용시간</th> <th>상태</th> <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="res-body">
                        <tr data-res-id="1001" data-fac-id="POOL" data-user-id="user_kim" data-res-status="WAITING">
                            <td>수영장</td>
                            <td>김철수</td>
                            <td>101-1201</td>
                            <td>07:00 ~ 08:00</td>
                            <td><span class="badge badge-warning status-badge">● 대기중</span></td>
                            <td class="action-td">
                                <button class="btn btn-primary btn-xs" onclick="facilityManager.approveRes(this)">승인</button>
                                <button class="btn btn-secondary btn-xs" onclick="facilityManager.cancelWithReason(this)">취소</button>
                            </td>
                        </tr>

                        <tr data-res-id="1002" data-fac-id="GYM" data-user-id="user_park" data-res-status="APPROVED">
                            <td>헬스장</td>
                            <td>박영희</td>
                            <td>103-505</td>
                            <td>14:00 ~ 16:00</td>
                            <td><span class="badge badge-success status-badge">● 승인완료</span></td>
                            <td class="action-td">
                                <button class="btn btn-secondary btn-xs text-danger" onclick="facilityManager.cancelWithReason(this)">예약취소</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </main>
    </div>

    <div class="modal-overlay" id="historyModal">
        <div class="modal-container">
            <div class="section-header">
                <h3 class="section-title" id="modalTitle">통계 기록</h3>
                <button class="btn btn-secondary btn-xs" onclick="facilityManager.closeModal()">✕ 닫기</button>
            </div>
            
            <div style="margin-bottom: 15px; text-align: right;">
                <select class="form-select" id="yearSelector" onchange="facilityManager.renderHistory()" style="width: 120px;">
                    <option value="2026">2026년</option>
                    <option value="2025">2025년</option>
                    <option value="2024">2024년</option>
                </select>
            </div>

            <table class="admin-table">
                <thead>
                    <tr><th>월별</th><th>구분</th><th>수치/금액</th><th>비고</th></tr>
                </thead>
                <tbody id="modal-body">
                </tbody>
            </table>
        </div>
    </div>

    <script src="/js/community_manage.js"></script>
</body>
</html>