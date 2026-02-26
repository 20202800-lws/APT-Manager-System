/* ============================================================
   [마이페이지 공통 JavaScript]
   ============================================================ */

// ★ 관리비 찐 데이터(feeData)는 fee_view.jsp에서 JSP JSTL로 이미 선언해두었습니다!
// 여기서는 그래프 모드 변수만 선언합니다.
let currentGraphMode = 'electric';

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
    // feeData가 존재하고(JSP에서 넘어옴), 키값이 하나라도 있을 때만 실행!
    if (selector && typeof feeData !== 'undefined' && Object.keys(feeData).length > 0) {
        Object.keys(feeData).forEach(date => {
            const opt = document.createElement('option');
            opt.value = date;
            opt.innerText = `${date.split('-')[0]}년 ${date.split('-')[1]}월분`;
            selector.appendChild(opt);
        });
        updateMonthDetail(); // 초기 상세내용 로드
    } else if (selector) {
        // 데이터가 하나도 없을 때의 처리
        const opt = document.createElement('option');
        opt.innerText = `청구된 관리비 내역이 없습니다.`;
        selector.appendChild(opt);
        selector.disabled = true;
    }

    // 3. 회원 탈퇴 버튼
    const withdrawBtn = document.getElementById('withdrawBtn');
    if (withdrawBtn) {
        withdrawBtn.addEventListener('click', () => {
            if (confirm("정말로 탈퇴하시겠습니까? (복구 불가능)")) {
                alert("탈퇴 API 연결 후 작동합니다.");
            }
        });
    }
});

/* ============================================================
   [함수] 각 기능별 전역 함수
   ============================================================ */

// --- 관리비 관련 ---
function updateMonthDetail() {
    const selector = document.getElementById('monthSelector');
    if(!selector || selector.disabled) return;
    
    const val = selector.value;
    const data = feeData[val];
    if(!data) return; // 데이터 없으면 종료

    document.getElementById('targetMonthTxt').innerText = `${val.split('-')[1]}월분 총 부과금액`;
    document.getElementById('totalAmountDisplay').innerHTML = `${data.total}<span>원</span>`;
    document.getElementById('dueDateTxt').innerText = data.due;
    
    const badge = document.getElementById('paymentBadge');
    badge.innerText = data.status === 'paid' ? "납부완료" : "미납";
    badge.className = `status-badge ${data.status}`;

    // 관리비 세부 내역 표 그리기
    const tbody = document.getElementById('feeTableBody');
    if(data.items && data.items.length > 0) {
        tbody.innerHTML = data.items.map(item => `
            <tr><td>${item.name}</td><td>${item.desc}</td><td style="text-align:right;">${item.price}원</td></tr>
        `).join('');
    } else {
        tbody.innerHTML = `<tr><td colspan="3" style="text-align:center; padding: 20px;">상세 내역이 없습니다.</td></tr>`;
    }

    // 하단 합계 금액 갱신
    const finalPriceSum = document.getElementById('finalPriceSum');
    if(finalPriceSum) {
        finalPriceSum.innerText = data.total + "원";
    }

    renderGraph();
    updatePayTabStatus(val, data);
}

function renderGraph() {
    const val = document.getElementById('monthSelector').value;
    const dataObj = feeData[val];
    if(!dataObj || !dataObj.graphs) return;

    const data = dataObj.graphs[currentGraphMode];
    const graphContainer = document.getElementById('usageGraph');
    if(!graphContainer) return;

    // 최대값 계산 (그래프 높이 비율 설정용)
    const maxVal = Math.max(...data.data) * 1.2;
    // 값이 전부 0이면 방어 로직
    const finalMax = maxVal === 0 ? 100 : maxVal; 

    graphContainer.innerHTML = data.data.map((v, i) => `
        <div class="bar-wrap">
            <div class="bar ${currentGraphMode} ${i===5?'current':''}" style="height:${(v/finalMax)*100}%" data-value="${v}${data.unit}"></div>
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

// ==========================================
// ★ (주의) 활동 내역 관련 가짜 데이터(myData) 및 함수들은
// 백엔드 JSTL 연동으로 인해 더 이상 사용하지 않으므로 모두 삭제했습니다!
// ==========================================