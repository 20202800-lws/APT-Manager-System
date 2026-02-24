/* ============================================================
   [공통 데이터] 활동 내역 및 관리비 데이터
   ============================================================ */
   function changeMenu(element, fileName) {
       // 1. 모든 메뉴(메인/서브)에서 active 클래스 제거
       const items = document.querySelectorAll('.menu-item, .sub-item');
       items.forEach(item => item.classList.remove('active'));

       // 2. 현재 클릭한 메뉴에만 active 클래스 추가 (보라색 배경 적용)
       element.classList.add('active');

       // 3. 우측 컨텐츠 영역에 해당 JSP 내용을 로드 (Ajax 예시)
       console.log(fileName + " 내용을 불러옵니다.");
       
       /* fetch(fileName)
           .then(res => res.text())
           .then(html => {
               document.querySelector('.content-area').innerHTML = html;
           });
       */
   }
// 1. 활동 내역 데이터
const myData = {
    posts: [
        { id: 1, category: "[자유게시판]", subject: "이번 주말 플리마켓 행사 기대되네요!", date: "2026.02.03", hits: 125, comments: 8 },
        { id: 2, category: "[민원게시판]", subject: "103동 지하주차장 차단기 오작동", date: "2026.01.28", hits: 42, comments: 1 }
    ],
    comments: [
        { id: 101, category: "[자유게시판]", subject: "저도 참여하고 싶어요! 어디서 신청하나요?", date: "2026.02.04", originPost: "이번 주말 플리마켓 행사 안내" },
        { id: 102, category: "[나눔게시판]", subject: "좋은 정보 감사합니다.", date: "2026.01.30", originPost: "아이 장난감 무료 나눔합니다." }
    ]
};

// 2. 관리비 데이터 생성 (기존 로직 유지)
const feeData = {};
let currentGraphMode = 'electric';

for (let i = 0; i < 24; i++) {
    let d = new Date(2026, 2 - i, 1);
    let year = d.getFullYear();
    let month = String(d.getMonth() + 1).padStart(2, '0');
    let key = `${year}-${month}`;
    let baseAmount = 200000 + Math.floor(Math.random() * 80000);
    let status = (key === '2026-02') ? 'unpaid' : 'paid';
    let elecTrend = Array.from({length: 6}, () => 200 + Math.floor(Math.random() * 150));
    let heatTrend = Array.from({length: 6}, () => 50 + Math.floor(Math.random() * 80));
    let totalTrend = Array.from({length: 6}, () => 180000 + Math.floor(Math.random() * 100000));

    feeData[key] = {
        total: baseAmount.toLocaleString(),
        rawTotal: baseAmount,
        due: `${year}.${month}.${month==='02'?'28':'30'}`,
        status: status,
        graphs: {
            electric: { data: elecTrend, unit: 'kWh' },
            heating: { data: heatTrend, unit: '㎥' },
            total: { data: totalTrend, unit: '원' }
        },
     items: [
            {name: "일반 관리비", desc: "인건비, 제사무비", price: (65000 + Math.floor(Math.random()*1000)).toLocaleString()},
            {name: "청소비", desc: "단지 청소 용역", price: "12,000"},
            {name: "경비비", desc: "보안 경비 용역", price: "35,000"},
            {name: "승강기 유지비", desc: "엘리베이터 점검", price: "12,200"},
            {name: "장기수선충당금", desc: "시설 보수 적립금", price: "28,500"},
            {name: "세대 전기료", desc: `월간 사용량 ${elecTrend[5]}kWh`, price: (elecTrend[5]*150).toLocaleString()},
            {name: "세대 난방비", desc: `월간 사용량 ${heatTrend[5]}㎥`, price: (heatTrend[5]*700).toLocaleString()},
            {name: "공동 전기료", desc: "공용시설 전기", price: "24,000"},
            {name: "TV 수신료", desc: "KBS 수신료", price: "2,500"},
            {name: "위탁수수료", desc: "관리업체 수수료", price: "500"},
            {name: "소독비", desc: "정기 소독", price: "2,500"},
            {name: "생활폐기물", desc: "음식물 처리비", price: "1,800"},
            {name: "입주자회비", desc: "대표회의 운영비", price: "3,000"}
        ]
    };
}


/* ============================================================
   [초기화] 페이지 로드 시 실행
   ============================================================ */
document.addEventListener('DOMContentLoaded', () => {
    
    // 1. 이미지 미리보기 (수정페이지)
    const fileInput = document.getElementById('fileInput');
    if (fileInput) {
        fileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const preview = document.getElementById('imagePreview');
                    if(preview) preview.innerHTML = `<img src="${e.target.result}" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">`;
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    }

    // 2. 관리비 셀렉트 박스 채우기 (관리비페이지)
    const selector = document.getElementById('monthSelector');
    if (selector) {
        Object.keys(feeData).forEach(date => {
            const opt = document.createElement('option');
            opt.value = date;
            opt.innerText = `${date.split('-')[0]}년 ${date.split('-')[1]}월분`;
            selector.appendChild(opt);
        });
        updateMonthDetail(); // 초기 상세내용 로드
    }

    // 3. 활동내역 초기 로드
    if(document.getElementById('activityList')) {
        showActivity('posts');
    }

    // 4. 회원 탈퇴 버튼
    const withdrawBtn = document.getElementById('withdrawBtn');
    if (withdrawBtn) {
        withdrawBtn.addEventListener('click', () => {
            if (confirm("정말로 탈퇴하시겠습니까?")) location.href = "withdraw.jsp";
        });
    }
});

/* ============================================================
   [함수] 각 기능별 전역 함수
   ============================================================ */

// --- 관리비 관련 ---
function updateMonthDetail() {
    const selector = document.getElementById('monthSelector');
    if(!selector) return;
    const val = selector.value;
    const data = feeData[val];

    document.getElementById('targetMonthTxt').innerText = `${val}월분 총 부과금액`;
    document.getElementById('totalAmountDisplay').innerHTML = `${data.total}<span>원</span>`;
    document.getElementById('dueDateTxt').innerText = data.due;
    
    const badge = document.getElementById('paymentBadge');
    badge.innerText = data.status === 'paid' ? "납부완료" : "미납";
    badge.className = `status-badge ${data.status}`;

    const tbody = document.getElementById('feeTableBody');
    tbody.innerHTML = data.items.map(item => `
        <tr><td>${item.name}</td><td>${item.desc}</td><td style="text-align:right;">${item.price}</td></tr>
    `).join('');

    renderGraph();
    updatePayTabStatus(val, data);
}

function renderGraph() {
    const val = document.getElementById('monthSelector').value;
    const data = feeData[val].graphs[currentGraphMode];
    const graphContainer = document.getElementById('usageGraph');
    if(!graphContainer) return;

    const maxVal = Math.max(...data.data) * 1.2;
    graphContainer.innerHTML = data.data.map((v, i) => `
        <div class="bar-wrap">
            <div class="bar ${currentGraphMode} ${i===5?'current':''}" style="height:${(v/maxVal)*100}%" data-value="${v}${data.unit}"></div>
            <span class="bar-label">${i+1}월</span>
        </div>
    `).join('');
}

function setGraphMode(mode, btn) {
    currentGraphMode = mode;
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    renderGraph();
}

function switchFeeTab(type) {
    const view = document.getElementById('viewSection');
    const pay = document.getElementById('paySection');
    if(!view || !pay) return;
    view.classList.toggle('active', type === 'view');
    pay.classList.toggle('active', type === 'pay');
    document.getElementById('pageTitle').innerText = type === 'view' ? "💳 관리비 조회 / 상세 내역" : "💰 관리비 납부 / 결제";
}

function updatePayTabStatus(monthStr, data) {
    const btnPay = document.getElementById('btnPay');
    if(!btnPay) return;
    document.getElementById('payMonthTxt').innerText = `${monthStr.split('-')[0]}년 ${monthStr.split('-')[1]}월분`;
    document.getElementById('payAmountTxt').innerText = data.total + "원";
    btnPay.disabled = data.status === 'paid';
    btnPay.innerText = data.status === 'paid' ? "이미 납부 완료됨" : "결제하기";
}

// --- 활동 내역 관련 ---
function renderActivity(type) {
    const listContainer = document.getElementById('activityList');
    if (!listContainer) return;
    const data = myData[type];
    listContainer.innerHTML = data.map((item, index) => `
        <li class="list-item">
            <div class="item-info">
                ${type === 'comments' ? `<span style="color:#999; font-size:11px;">Re: ${item.originPost}</span>` : `<span class="category">${item.category}</span>`}
                <a href="#" class="subject">${type === 'posts' ? item.subject : item.subject}</a>
                <span class="date">${item.date}</span>
            </div>
            <button class="btn-delete" onclick="deleteItem(this, '${type}', ${index})">&times;</button>
        </li>
    `).join('');
    document.getElementById('totalCount').innerText = data.length;
}

function showActivity(type) {
    document.getElementById('menuPost').classList.toggle('active', type === 'posts');
    document.getElementById('menuComment').classList.toggle('active', type === 'comments');
    document.getElementById('pageTitle').innerText = type === 'posts' ? '📝 내가 쓴 게시물' : '💬 내가 쓴 댓글';
    renderActivity(type);
}

function deleteItem(btn, type, index) {
    if(confirm('정말로 삭제하시겠습니까?')) {
        myData[type].splice(index, 1);
        renderActivity(type);
    }
}