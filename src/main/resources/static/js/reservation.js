/**
 * =========================================================
 * 커뮤니티 시설 예약 및 프로그램 신청 전용 JS (실전 API 연동 완료)
 * =========================================================
 */

// [1. 전역 상태 변수]
let selectedGolfSeat = null;
let selectedGuestRoom = null;
let currentProgId = null; // 현재 선택된 강습 ID

// [2. 설정] 시설 요금 데이터
const guestRoomData = {
    'A': { name: 'A타입 (원룸형/8평)', weekday: 40000, weekend: 60000 },
    'B': { name: 'B타입 (15평)', weekday: 60000, weekend: 80000 },
    'C': { name: 'C타입 (24평)', weekday: 80000, weekend: 100000 }
};
const poolDailyPrice = 3000;
const golfHourPrice = 10000;

// ==========================================
// 1. 시설 예약 모달 (fac_book.jsp)
// ==========================================
function openModal(type) {
    const modal = document.getElementById('bookingModal');
    const body = document.getElementById('modalBody');
    const title = document.getElementById('modalTitle');
    modal.style.display = 'flex';
    const today = new Date().toISOString().substring(0, 10);
    const tomorrow = new Date(Date.now() + 86400000).toISOString().substring(0, 10);

    if (type === 'pool') {
        title.innerText = "🏊 수영장 일일 자유수영 예약";
        body.innerHTML = `
            <div class="form-group"><label>이용 날짜</label><input type="date" id="poolDate" value="${today}"></div>
            <div class="form-group"><label>이용 인원 (입주민)</label>
                <select id="poolPeople"><option value="1">1명</option><option value="2">2명</option><option value="3">3명</option></select>
            </div>
            <div class="total-price">결제 예정 금액: <span id="poolPriceDisplay">3,000원</span></div>
            <button class="btn-confirm" onclick="preConfirmFacility('pool')">예약 확정하기</button>
        `;
        document.getElementById('poolPeople').addEventListener('change', function() {
            document.getElementById('poolPriceDisplay').innerText = (this.value * poolDailyPrice).toLocaleString() + "원";
        });
    }
    else if (type === 'gym') {
        title.innerText = "🏋️ 피트니스센터 이용 신청";
        let monthOptions = "";
        for (let i = 1;i <= 12;i++) monthOptions += `<option value="${i}월">${i}월</option>`;
        body.innerHTML = `
            <div class="gym-notice" style="background:#f8f9fa; padding:10px; font-size:13px; margin-bottom:15px;">💡 1인 무료, 인원 추가 시 월 30,000원 부과 (최대 2인 추가)</div>
            <div class="form-group"><label>시작 월 선택</label><select id="gymStartMonth">${monthOptions}</select></div>
            <div class="form-group">
                <label>추가 인원</label>
                <select id="gymExtraPeople" onchange="calculateGymPrice()">
                    <option value="0">추가 안함 (본인만 무료이용)</option>
                    <option value="1">1명 추가 (+30,000원/월)</option>
                    <option value="2">2명 추가 (+60,000원/월)</option>
                </select>
            </div>
            <div class="form-group">
                <label>이용 기간 선택</label>
                <select id="gymMonths" onchange="calculateGymPrice()">
                    <option value="1">1개월</option><option value="3">3개월</option><option value="6">6개월</option>
                </select>
            </div>
            <div class="total-price">총 결제 금액: <span id="gymPriceDisplay">0원</span></div>
            <button class="btn-confirm" onclick="preConfirmFacility('gym')">신청하기</button>
        `;
    }
    else if (type === 'guest') {
        title.innerText = "🛏️ 게스트하우스 객실 선택";
        selectedGuestRoom = null;
        body.innerHTML = `
            <div class="form-group"><label>객실 타입 선택</label><div class="room-grid" style="display:grid; gap:10px;">
                ${Object.keys(guestRoomData).map(key => `
                    <div class="room-item" onclick="selectRoom(this, '${key}')" style="padding:15px; border:1px solid #ddd; cursor:pointer; border-radius:8px;">
                        <div style="font-weight:bold;">${guestRoomData[key].name}</div>
                        <div style="color:#e74c3c; font-size:14px;">평일 ${guestRoomData[key].weekday.toLocaleString()}원 / 주말 ${guestRoomData[key].weekend.toLocaleString()}원</div>
                    </div>
                `).join('')}
            </div></div>
            <div class="form-group" style="margin-top:20px;">
                <label>숙박 기간 선택</label>
                <div style="display:flex; gap:10px; align-items:center;">
                    <input type="date" id="guestStart" value="${today}" onchange="calculateGuestPrice()"> <span>~</span> 
                    <input type="date" id="guestEnd" value="${tomorrow}" onchange="calculateGuestPrice()">
                </div>
            </div>
            <div class="total-price" style="margin-top:20px;">결제 예정 금액: <span id="guestPriceDisplay">0원</span></div>
            <button class="btn-confirm" onclick="preConfirmFacility('guest')">예약 확정하기</button>
        `;
    }
    else if (type === 'golf') {
        title.innerText = "⛳ 스크린골프 예약";
        selectedGolfSeat = null;
        body.innerHTML = `
            <div class="form-group"><label>이용 날짜</label><input type="date" id="golfDateInput" value="${today}"></div>
            <div class="form-group"><label>이용 시작 시간</label><select id="golfStartTime">${generateTimeOptions()}</select></div>
            <div class="form-group"><label>이용 시간</label><select id="golfDuration" onchange="calculateGolfPrice()">
                <option value="1">1시간 (10,000원)</option><option value="2">2시간 (20,000원)</option>
            </select></div>
            <label>타석 선택 (1~5번)</label>
            <div id="golfGrid" style="display:flex; gap:10px; margin-top:10px;"></div>
            <div class="total-price" style="margin-top:20px;">결제 예정 금액: <span id="golfPriceDisplay">10,000원</span></div>
            <button class="btn-confirm" onclick="preConfirmFacility('golf')">신청하기</button>
        `;
        refreshGolfAvailability();
    }
}

// ==========================================
// 2. 프로그램 신청 모달 (prog_book.jsp)
// ==========================================
function openProgramModal(progId, progName, fee) {
    currentProgId = progId; // 신청할 강습 번호 저장

    const modal = document.getElementById('programModal');
    const body = document.getElementById('progModalBody');
    const title = document.getElementById('progModalTitle');

    title.innerText = "📝 강습 수강 신청";
    body.innerHTML = `
        <div style="background:#f8f9fa; padding:15px; border-radius:8px; margin-bottom:20px;">
            <h4 style="margin:0 0 10px 0; color:var(--primary-color);">${progName}</h4>
            <p style="margin:0; font-size:14px; color:#555;">해당 강습의 수강을 신청하시겠습니까?</p>
        </div>
        <div class="total-price">결제 예정 금액: <span>${Number(fee).toLocaleString()}원</span></div>
        <button class="btn-confirm" onclick="submitProgram()">신청 확정하기</button>
    `;
    modal.style.display = 'flex';
}

function closeProgramModal() {
    document.getElementById('programModal').style.display = 'none';
}

function closeModal() {
    document.getElementById('bookingModal').style.display = 'none';
}

// ==========================================
// 3. UI 헬퍼 함수
// ==========================================
function calculateGymPrice() {
    const extra = parseInt(document.getElementById('gymExtraPeople').value);
    const months = parseInt(document.getElementById('gymMonths').value);
    const price = extra * 30000 * months;
    document.getElementById('gymPriceDisplay').innerText = price.toLocaleString() + "원";
}

function calculateGolfPrice() {
    const duration = parseInt(document.getElementById('golfDuration').value);
    document.getElementById('golfPriceDisplay').innerText = (duration * golfHourPrice).toLocaleString() + "원";
}

// 방 선택 시 테두리 색상 변경 및 가격 계산
function selectRoom(el, key) {
    document.querySelectorAll('.room-item').forEach(item => item.style.borderColor = '#ddd');
    el.style.borderColor = 'var(--accent-color)';
    el.style.borderWidth = '2px';
    selectedGuestRoom = guestRoomData[key];
    calculateGuestPrice(); // 방을 선택하면 즉시 가격 재계산!
}

// 게스트하우스 숙박 일수 및 평일/주말 계산 로직
function calculateGuestPrice() {
    if (!selectedGuestRoom) {
        document.getElementById('guestPriceDisplay').innerText = "0원";
        return;
    }

    const start = new Date(document.getElementById('guestStart').value);
    const end = new Date(document.getElementById('guestEnd').value);

    // 날짜를 거꾸로 선택한 경우 방어
    if (start >= end) {
        document.getElementById('guestPriceDisplay').innerText = "0원 (날짜 오류)";
        return;
    }

    let totalPrice = 0;
    let currentDate = new Date(start);

    // 시작일부터 종료일 전날까지 반복하며 가격 합산 (1박 기준)
    while (currentDate < end) {
        const day = currentDate.getDay(); // 0:일, 1:월, ..., 5:금, 6:토
        if (day === 5 || day === 6) {
            totalPrice += selectedGuestRoom.weekend; // 금, 토는 주말 요금
        } else {
            totalPrice += selectedGuestRoom.weekday; // 나머지는 평일 요금
        }
        currentDate.setDate(currentDate.getDate() + 1); // 다음 날로 이동
    }

    document.getElementById('guestPriceDisplay').innerText = totalPrice.toLocaleString() + "원";
}

function generateTimeOptions() {
    let opt = ''; for (let i = 6;i <= 22;i++) { let h = i < 10 ? '0' + i : i; opt += `<option value="${h}:00">${h}:00</option>`; } return opt;
}

function refreshGolfAvailability() {
    const grid = document.getElementById('golfGrid'); grid.innerHTML = '';
    for (let i = 1;i <= 5;i++) {
        const btn = document.createElement('button');
        btn.innerText = i + '번';
        btn.style.padding = '10px 15px'; btn.style.border = '1px solid #ddd'; btn.style.background = '#fff'; btn.style.cursor = 'pointer';
        btn.onclick = () => {
            document.querySelectorAll('#golfGrid button').forEach(b => { b.style.background = '#fff'; b.style.color = '#333'; });
            btn.style.background = 'var(--primary-color)'; btn.style.color = '#fff';
            selectedGolfSeat = i;
        };
        grid.appendChild(btn);
    }
}

// ==========================================
// 4. [진짜 연동] 예약 데이터 수집 및 제출
// ==========================================
function preConfirmFacility(type) {
    if (type === 'pool') {
        const people = document.getElementById('poolPeople').value;
        const date = document.getElementById('poolDate').value;
        const price = document.getElementById('poolPriceDisplay').innerText;
        submitReservation('수영장', `일일 자유수영 (${people}명)`, date, price);
    }
    else if (type === 'gym') {
        const extra = document.getElementById('gymExtraPeople').value;
        const months = document.getElementById('gymMonths').value;
        const price = document.getElementById('gymPriceDisplay').innerText;
        submitReservation('피트니스', `본인 + 추가 ${extra}명 (${months}개월)`, new Date().toLocaleDateString(), price);
    }
    else if (type === 'guest') {
        if (!selectedGuestRoom) return alert("객실을 선택해주세요!");
        const start = document.getElementById('guestStart').value;
        const end = document.getElementById('guestEnd').value;

        // 날짜 유효성 검사
        if (new Date(start) >= new Date(end)) return alert("숙박 기간을 올바르게 설정해주세요.");

        // ★ 화면에 계산된 가격을 가져와서 DB로 전송! (수정 완료)
        const price = document.getElementById('guestPriceDisplay').innerText;
        submitReservation('게스트하우스', selectedGuestRoom.name, `${start} ~ ${end}`, price);
    }
    else if (type === 'golf') {
        if (!selectedGolfSeat) return alert('타석을 선택해주세요!');
        const date = document.getElementById('golfDateInput').value;
        const time = document.getElementById('golfStartTime').value;
        const dur = document.getElementById('golfDuration').value;
        const price = document.getElementById('golfPriceDisplay').innerText;
        submitReservation('스크린골프', `${selectedGolfSeat}번 타석 (${time} 부터 ${dur}시간)`, date, price);
    }
}

// [API 전송] 시설 예약
function submitReservation(type, detail, dateStr, priceStr) {
    if (!confirm(`[${type}] 예약을 확정하시겠습니까?`)) return;

    const requestData = {
        facilityType: type,
        details: detail,
        reserveDate: dateStr,
        price: priceStr
    };

    fetch('/api/reservation/save', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(requestData)
    })
        .then(res => {
            if (res.ok) {
                alert('예약이 성공적으로 완료되었습니다!');
                // 서버에 데이터가 정상 저장되면 내역 페이지로 이동하여 진짜 DB 데이터를 봅니다.
                location.href = '/reservation/my_list';
            } else if (res.status === 401) {
                alert('로그인이 만료되었거나 로그인이 필요합니다.');
                location.href = '/member/login';
            } else {
                res.text().then(msg => alert("오류: " + msg));
            }
        })
        .catch(error => alert("서버 통신 중 오류가 발생했습니다."));
}

// [API 전송] 강습 프로그램 신청
function submitProgram() {
    if (!confirm('해당 강습을 신청하시겠습니까?')) return;

    const requestData = { progId: currentProgId };

    fetch('/api/reservation/apply', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(requestData)
    })
        .then(res => {
            if (res.ok) {
                alert('강습 신청이 완료되었습니다!');
                location.href = '/reservation/my_list';
            } else if (res.status === 401) {
                alert('로그인이 만료되었거나 로그인이 필요합니다.');
                location.href = '/member/login';
            } else {
                res.text().then(msg => alert(msg)); // 중복 신청 시 서버의 에러 메시지 띄움
            }
        })
        .catch(error => alert("서버 통신 중 오류가 발생했습니다."));
}

// ==========================================
// 5. 취소 처리 (실전 API 연동 완료)
// ==========================================
function cancelReservation(id, type) {
    if(confirm('정말 취소하시겠습니까? (위약금 규정이 적용될 수 있습니다)')) {
        
        // 방금 만든 백엔드 취소 API 호출!
        fetch(`/api/reservation/cancel/${type}/${id}`, { 
            method: 'POST' 
        })
        .then(res => {
            if(res.ok) {
                alert('취소가 완료되었습니다.');
                location.reload(); // 성공 시 화면을 새로고침하여 '취소됨' 뱃지로 바로 변경!
            } else if(res.status === 401) { 
                alert('로그인이 만료되었거나 로그인이 필요합니다.');
                location.href = '/member/login';
            } else {
                res.text().then(msg => alert('취소 처리 실패: ' + msg));
            }
        })
        .catch(error => alert("서버 통신 중 오류가 발생했습니다."));
    }
}

// ==========================================
// 6. 프론트엔드 페이징 (my_list.jsp 전용)
// ==========================================
const rowsPerPage = 10; // 한 페이지에 보여줄 개수
let currentPage = 1;

function displayHistoryPage(page) {
    const tbody = document.getElementById('historyList');
    if (!tbody) return; // 내역 화면이 아니면 작동 안함

    const rows = Array.from(tbody.querySelectorAll('tr'));
    
    // 내역이 없다는 메시지가 떠있을 경우 페이징 작동안함
    if (rows.length === 0 || (rows.length === 1 && rows[0].innerText.includes('없습니다'))) {
        return;
    }

    const totalPages = Math.ceil(rows.length / rowsPerPage);
    if (page < 1) page = 1;
    if (page > totalPages) page = totalPages;
    currentPage = page;

    // 모든 줄을 숨기고, 현재 페이지에 해당하는 10줄만 보여줌
    rows.forEach((row, index) => {
        row.style.display = 'none';
        if (index >= (page - 1) * rowsPerPage && index < page * rowsPerPage) {
            row.style.display = '';
        }
    });

    renderPaginationButtons(totalPages);
}

function renderPaginationButtons(totalPages) {
    const paginationDiv = document.getElementById('pagination');
    if (!paginationDiv) return;
    
    paginationDiv.innerHTML = '';

    // 이전 버튼 (옵션)
    if (totalPages > 1) {
        const prevBtn = document.createElement('button');
        prevBtn.className = 'page-btn';
        prevBtn.innerText = '◁';
        prevBtn.onclick = () => displayHistoryPage(currentPage - 1);
        paginationDiv.appendChild(prevBtn);
    }

    // 숫자 버튼들
    for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement('button');
        btn.className = `page-btn ${i === currentPage ? 'active' : ''}`;
        btn.innerText = i;
        btn.onclick = () => displayHistoryPage(i);
        paginationDiv.appendChild(btn);
    }

    // 다음 버튼 (옵션)
    if (totalPages > 1) {
        const nextBtn = document.createElement('button');
        nextBtn.className = 'page-btn';
        nextBtn.innerText = '▷';
        nextBtn.onclick = () => displayHistoryPage(currentPage + 1);
        paginationDiv.appendChild(nextBtn);
    }
}

// 화면이 모두 로드되면 페이징 1페이지 실행!
document.addEventListener('DOMContentLoaded', () => {
    displayHistoryPage(1);
});