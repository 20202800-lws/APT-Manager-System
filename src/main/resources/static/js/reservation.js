// [1. 데이터 초기값 및 로드] 로컬스토리지에 저장된 데이터가 있으면 가져오고, 없으면 기본 배열 사용
let reservations = JSON.parse(localStorage.getItem('my_reservations')) || [
    { id: 101, type: '스크린골프', detail: '3번 타석 / 10:00~11:00 (1시간)', date: '2026-02-01', price: '10,000원', status: '예약완료', startTime: '10:00', endTime: '11:00', seat: 3 },
    { id: 102, type: '헬스장', detail: '1명 / 1개월', date: '2026-01-01', price: '0원', status: '취소됨' }
];

let selectedGolfSeat = null;
let selectedGolfMonthValue = null; // 골프 월 정기권용 변수
let selectedGuestRoom = null;
let pendingAction = null; 

// [설정] 시설 요금 데이터
const guestRoomData = {
    'A': { name: 'A타입 (원룸형)', weekday: 40000, weekend: 60000 },
    'B': { name: 'B타입 (투룸형)', weekday: 60000, weekend: 80000 },
    'C': { name: 'C타입 (스위트)', weekday: 80000, weekend: 100000 }
};

const poolPrice = "15,000원";
const golfHourPrice = 10000; 
const golfMonthPrice = "150,000원";

// [데이터 저장 함수]
function saveToStorage() {
    localStorage.setItem('my_reservations', JSON.stringify(reservations));
}

// [탭 전환 함수] 내역 탭 이동 시 렌더링 호출
function switchTab(tabName) {
    document.getElementById('tab-booking').classList.remove('active');
    document.getElementById('tab-history').classList.remove('active');
    
    if(tabName === 'booking') {
        document.getElementById('tab-booking').classList.add('active');
        document.getElementById('view-booking').style.display = 'block';
        document.getElementById('view-history').style.display = 'none';
    } else {
        document.getElementById('tab-history').classList.add('active');
        document.getElementById('view-booking').style.display = 'none';
        document.getElementById('view-history').style.display = 'block';
        renderHistory(); // 내역 화면 갱신
    }
}

// ================= 모달 로직 =================
function openModal(type) {
    const modal = document.getElementById('bookingModal');
    const body = document.getElementById('modalBody');
    const title = document.getElementById('modalTitle');
    modal.style.display = 'flex'; 
    const today = new Date().toISOString().substring(0, 10);
    const tomorrow = new Date(Date.now() + 86400000).toISOString().substring(0, 10);

    if(type === 'pool') {
        title.innerText = "🏊 수영장 강습 예약";
        body.innerHTML = `
            <div class="form-group">
                <label>강습 월 선택</label>
                <select id="poolMonth"><option value="2026년 2월">2026년 2월</option><option value="2026년 3월">2026년 3월</option></select>
            </div>
            <div class="selection-list">
                <div class="selection-item">
                    <div class="selection-info"><span class="name">초급반 (07:00)</span><span class="pool-count">신청 5 / 모집 20</span></div>
                    <button class="btn-mini" onclick="preConfirmPool('초급반 (07:00)')">예약하기</button>
                </div>
                <div class="selection-item">
                    <div class="selection-info"><span class="name">중급반 (08:00)</span><span class="pool-count">신청 8 / 모집 20</span></div>
                    <button class="btn-mini" onclick="preConfirmPool('중급반 (08:00)')">예약하기</button>
                </div>
            </div>
        `;
    } 
    else if(type === 'gym') {
        title.innerText = "🏋️ 헬스장 예약";
        let monthOptions = "";
        for(let i=1; i<=12; i++) monthOptions += `<option value="${i}월">${i}월</option>`;
        body.innerHTML = `
            <div class="gym-notice">💡 1인 무료, 2인째부터 월 30,000원 부과</div>
            <div class="form-group"><label>시작 월 선택</label><select id="gymStartMonth">${monthOptions}</select></div>
            <div class="form-group">
                <label>이용 인원</label>
                <div class="stepper-box">
                    <button class="step-btn" onclick="updatePeople(-1)">-</button><span id="gymPeopleDisplay">1</span><button class="step-btn" onclick="updatePeople(1)">+</button>
                </div>
                <input type="hidden" id="gymPeople" value="1">
            </div>
            <div class="form-group">
                <label>이용 기간 선택</label>
                <select id="gymMonths" onchange="calculateGymPrice()">
                    <option value="1">1개월</option><option value="2">2개월</option><option value="3">3개월</option><option value="3">6개월</option><option value="3">12개월</option>
                </select>
            </div>
            <div class="total-price">총 이용금액: <span id="gymPriceDisplay">0원</span></div>
            <button class="btn-confirm" onclick="preConfirmGym()">헬스장 이용 신청</button>
        `;
        calculateGymPrice();
    }
    else if(type === 'guest') {
        title.innerText = "🏠 게스트하우스 객실 선택";
        selectedGuestRoom = null;
        body.innerHTML = `
            <div class="form-group"><label>객실 타입 선택</label><div class="room-grid">
                ${Object.keys(guestRoomData).map(key => `
                    <div class="room-item" onclick="selectRoom(this, '${key}')">
                        <div class="room-info"><span class="room-name">${guestRoomData[key].name}</span></div>
                        <div class="room-price">${guestRoomData[key].weekday.toLocaleString()}원~</div>
                    </div>
                `).join('')}
            </div></div>
            <div class="form-group" style="margin-top:20px;">
                <label>숙박 기간 선택</label>
                <div style="display:flex; gap:10px; align-items:center;">
                    <input type="date" id="guestStart" value="${today}" onchange="calcGuestTotal()"> <span>~</span> 
                    <input type="date" id="guestEnd" value="${tomorrow}" onchange="calcGuestTotal()">
                </div>
            </div>
            <div class="total-price">결제 예정 금액: <span id="guestPriceDisplay">0원</span></div>
            <button class="btn-confirm" onclick="preConfirmGuest()">예약 확정하기</button>
        `;
    }
    else if(type === 'golf') {
        title.innerText = "⛳ 스크린골프 예약";
        selectedGolfSeat = null;
        selectedGolfMonthValue = null;
        body.innerHTML = `
            <div class="form-group">
                <label>이용권 종류</label>
                <select id="golfTicketType" onchange="toggleGolfUI()">
                    <option value="day">일일권 (타석 지정 예약)</option>
                    <option value="month">월 정기 이용권 (공석 이용)</option>
                </select>
            </div>
            <div id="golfReservationUI">
                <div class="form-group"><label>이용 날짜 선택</label><input type="date" id="golfDateInput" value="${today}"></div>
                <div class="form-group"><label>이용 시작 시간</label><select id="golfStartTime">${generateTimeOptions()}</select></div>
                <div class="form-group"><label>이용 시간</label><select id="golfDuration" onchange="calculateGolfPrice()">
                    <option value="1">1시간</option><option value="2">2시간</option>
                </select></div>
                <label>타석 선택</label><div class="golf-grid" id="golfGrid"></div>
            </div>
            <div id="golfMonthlyUI" style="display:none; margin-top:15px;">
                <label>이용하실 달을 선택해주세요</label>
                <div class="month-grid" style="display:grid; grid-template-columns: repeat(4, 1fr); gap:8px; margin-top:10px;">
                    ${Array.from({length: 12}, (_, i) => `<button type="button" class="golf-btn month-btn" onclick="selectGolfMonth(this, ${i+1})">${i+1}월</button>`).join('')}
                </div>
            </div>
            <div class="total-price" style="margin-top:20px;">결제 예정 금액: <span id="golfPriceDisplay">0원</span></div>
            <button class="btn-confirm" onclick="preConfirmGolf()">신청하기</button>
        `;
        calculateGolfPrice();
        refreshGolfAvailability();
    }
}

// --- 골프 헬퍼 함수 ---
function selectGolfMonth(el, month) {
    document.querySelectorAll('.month-btn').forEach(b => b.classList.remove('selected'));
    el.classList.add('selected');
    selectedGolfMonthValue = month;
}
function toggleGolfUI() {
    const type = document.getElementById('golfTicketType').value;
    document.getElementById('golfReservationUI').style.display = (type === 'month') ? 'none' : 'block';
    document.getElementById('golfMonthlyUI').style.display = (type === 'month') ? 'block' : 'none';
    calculateGolfPrice();
}
function calculateGolfPrice() {
    const type = document.getElementById('golfTicketType').value;
    const display = document.getElementById('golfPriceDisplay');
    if(type === 'month') { display.innerText = golfMonthPrice; }
    else { const duration = parseInt(document.getElementById('golfDuration').value); display.innerText = (duration * golfHourPrice).toLocaleString() + "원"; }
}

// --- 공통 신청 로직 (연동의 핵심) ---
function addReservation(type, detail, dateStr, priceStr) {
    const newId = reservations.length > 0 ? Math.max(...reservations.map(r=>r.id)) + 1 : 1;
    // 배열에 데이터 추가
    reservations.push({ id: newId, type, detail, date: dateStr, price: priceStr, status: '예약완료' });
    
    saveToStorage(); // 로컬 스토리지 저장
    alert(`${type} 신청 완료!`);
    closeModal();
    
    // 연동: 내역 탭으로 자동 이동 및 렌더링
    switchTab('history');
}

// --- 각 시설별 최종 컨펌 호출 ---
function preConfirmPool(name) { askConfirm(`"${name}" 강습을 신청하시겠습니까?`, () => addReservation('수영장', name, "2026년 2월", poolPrice)); }

function preConfirmGym() {
    const people = document.getElementById('gymPeople').value;
    const months = document.getElementById('gymMonths').value;
    const price = document.getElementById('gymPriceDisplay').innerText;
    askConfirm(`헬스장 신청하시겠습니까?`, () => addReservation('헬스장', `${people}명 / ${months}개월`, new Date().toLocaleDateString(), price));
}

function preConfirmGuest() {
    const start = document.getElementById('guestStart').value;
    const end = document.getElementById('guestEnd').value;
    const price = document.getElementById('guestPriceDisplay').innerText;
    if(!selectedGuestRoom) return;
    askConfirm(`${selectedGuestRoom.name} 예약하시겠습니까?`, () => addReservation('게스트하우스', selectedGuestRoom.name, `${start} ~ ${end}`, price));
}

function preConfirmGolf() {
    const type = document.getElementById('golfTicketType').value;
    const price = document.getElementById('golfPriceDisplay').innerText;
    if(type === 'month') {
        if(!selectedGolfMonthValue) { alert('달을 선택해주세요.'); return; }
        askConfirm(`${selectedGolfMonthValue}월 정기권을 신청하시겠습니까?`, () => addReservation('스크린골프', `월 정기권 (${selectedGolfMonthValue}월)`, '2026-02-01', price));
    } else {
        if(!selectedGolfSeat) { alert('타석을 선택해주세요.'); return; }
        const duration = document.getElementById('golfDuration').value;
        const date = document.getElementById('golfDateInput').value;
        askConfirm(`예약하시겠습니까?`, () => addReservation('스크린골프', `${selectedGolfSeat}번 타석 / ${duration}시간`, date, price));
    }
}

// --- 내역 렌더링 함수 ---
function renderHistory() {
    const tbody = document.getElementById('historyList');
    if(!tbody) return;
    tbody.innerHTML = '';
    
    [...reservations].reverse().forEach(item => {
        const tr = document.createElement('tr');
        let badge = item.status === '예약완료' ? 'badge-active' : (item.status === '취소됨' ? 'badge-cancel' : 'badge-used');
        tr.innerHTML = `
            <td><b>${item.type}</b></td>
            <td>${item.detail}</td>
            <td>${item.date}</td>
            <td style="font-weight:600; color:#e67e22;">${item.price}</td>
            <td><span class="${badge}">${item.status}</span></td>
            <td>${item.status === '예약완료' ? `<button class="btn-cancel" onclick="cancelReservation(${item.id})">취소</button>` : '-'}</td>`;
        tbody.appendChild(tr);
    });
}

function cancelReservation(id) {
    if(confirm('취소하시겠습니까?')) {
        const item = reservations.find(r => r.id === id);
        if(item) {
            item.status = '취소됨';
            saveToStorage();
            renderHistory();
        }
    }
}

// --- 유틸리티 및 초기 로드 ---
function askConfirm(msg, action) { document.getElementById('confirmMessage').innerText = msg; pendingAction = action; document.getElementById('confirmModal').style.display = 'flex'; }
function processConfirm(isYes) { document.getElementById('confirmModal').style.display = 'none'; if (isYes && pendingAction) { pendingAction(); pendingAction = null; } }
function calculateGymPrice() {
    const people = parseInt(document.getElementById('gymPeople').value);
    const months = parseInt(document.getElementById('gymMonths').value);
    let price = people > 1 ? (people - 1) * 30000 * months : 0;
    document.getElementById('gymPriceDisplay').innerText = price.toLocaleString() + "원";
}
function updatePeople(change) {
    const input = document.getElementById('gymPeople');
    let val = parseInt(input.value) + change;
    if(val < 1) val = 1;
    input.value = val;
    document.getElementById('gymPeopleDisplay').innerText = val;
    calculateGymPrice();
}
function selectRoom(el, key) {
    document.querySelectorAll('.room-item').forEach(item => item.classList.remove('selected'));
    el.classList.add('selected');
    selectedGuestRoom = { name: guestRoomData[key].name, weekday: guestRoomData[key].weekday, weekend: guestRoomData[key].weekend };
    calcGuestTotal();
}
function calcGuestTotal() {
    const display = document.getElementById('guestPriceDisplay');
    if(!selectedGuestRoom) return;
    display.innerText = selectedGuestRoom.weekday.toLocaleString() + "원"; // 단순 계산 예시
}
function generateTimeOptions() {
    let opt = ''; for(let i=6; i<=22; i++) { let h = i < 10 ? '0'+i : i; opt += `<option value="${h}:00">${h}:00</option>`; } return opt;
}
function refreshGolfAvailability() {
    const grid = document.getElementById('golfGrid'); grid.innerHTML = '';
    for(let i=1; i<=5; i++) {
        const btn = document.createElement('button'); btn.className = 'golf-btn'; btn.innerText = i + '번';
        btn.onclick = () => { document.querySelectorAll('.golf-btn').forEach(b => b.classList.remove('selected')); btn.classList.add('selected'); selectedGolfSeat = i; };
        grid.appendChild(btn);
    }
}
function closeModal() { document.getElementById('bookingModal').style.display = 'none'; }

window.onload = function() {
    renderHistory(); // 페이지 로드 시 내역 먼저 그림
};