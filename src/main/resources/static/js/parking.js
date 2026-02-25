
let vehicleData = [
    { id: 1, type: 'household', carNum: '123가 4567', model: '그랜저', owner: '홍길동(본인)', date: '2024-02-10', visit_status: '정상', price: '무료' },
    { id: 2, type: 'visitor', carNum: '89너 1234', model: '지인 방문', owner: '김철수', date: '2024-02-14', visit_status: '예약됨', price: '-' }
];

function openModal(type) {
    const modal = document.getElementById('parkingModal');
    const typeLabel = document.getElementById('typeSpecificLabel');
    const typeInput = document.getElementById('typeSpecificInput');
    const priceInfo = document.getElementById('priceInfo');
    const visitDateGroup = document.getElementById('visitDateGroup');
    const relationType = document.getElementById('relationType');
    
    document.getElementById('entryType').value = type;
    modal.style.display = 'flex';

    if (type === 'household') {
        document.getElementById('modalTitle').innerText = '세대 차량 등록';
        typeLabel.innerText = '차종';
        typeInput.placeholder = '예: 쏘렌토';
        relationType.style.display = 'block'; 
        visitDateGroup.style.display = 'none';
        
        const householdCount = vehicleData.filter(v => v.type === 'household').length;
        priceInfo.style.display = 'block';
        priceInfo.innerText = householdCount === 0 ? "💡 첫 번째 차량: 등록 무료" : `💡 추가 차량 등록: 월 30,000원 부과 (기존 ${householdCount}대)`;
    } else {
        document.getElementById('modalTitle').innerText = '방문 차량 예약';
        typeLabel.innerText = '방문 목적';
        typeInput.placeholder = '예: 이사, 지인방문 등';
        relationType.style.display = 'none'; 
        visitDateGroup.style.display = 'block';
        document.getElementById('visitDate').valueAsDate = new Date();
        priceInfo.style.display = 'none';
    }
}

function closeModal() {
    document.getElementById('parkingModal').style.display = 'none';
    document.getElementById('vehicleForm').reset();
}

function submitVehicle(e) {
    e.preventDefault();
    const type = document.getElementById('entryType').value;
    const carNum = document.getElementById('car_Number').value;
    const typeSpecific = document.getElementById('typeSpecificInput').value || '-';
    let ownerName = document.getElementById('ownerName').value;
    
    let price = '-';
    let visit_status = '정상';
    let entryDate = '';

    if (type === 'household') {
        ownerName += `(${document.getElementById('relationType').value})`;
        entryDate = new Date().toISOString().split('T')[0];
        const householdCount = vehicleData.filter(v => v.type === 'household').length;
        price = householdCount === 0 ? '무료' : '30,000원';
    } else {
        entryDate = document.getElementById('visitDate').value;
        const today = new Date().toISOString().split('T')[0];
        visit_status = entryDate !== today ? '예약됨' : '입차가능';
    }

    vehicleData.unshift({ id: Date.now(), type, carNum, model: typeSpecific, owner: ownerName, date: entryDate, visit_status, price });
    renderTable();
    closeModal();
    setTimeout(() => showAlert('성공적으로 등록되었습니다.'), 300);
}

function renderTable() {
    const tbody = document.getElementById('vehicleTableBody');
    tbody.innerHTML = '';
    
    vehicleData.forEach(v => {
        const tr = document.createElement('tr');
        let sCol = v.visit_status === '예약됨' ? 'var(--accent)' : (v.visit_status === '입차가능' ? 'var(--warning)' : 'var(--success)');
        tr.innerHTML = `
            <td><span class="badge ${v.type==='household'?'badge-h':'badge-v'}">${v.type==='household'?'세대':'방문'}</span></td>
            <td style="font-weight:700;">${v.carNum}</td>
            <td>${v.model}</td>
            <td>${v.owner}</td>
            <td>${v.date}</td>
            <td style="font-weight:600; color:${v.price==='30,000원'?'var(--danger)':'var(--text)'}">${v.price}</td>
            <td><span style="color:${sCol}; font-weight:600;">${v.visit_status}</span></td>
            <td><button class="btn-delete" onclick="deleteVehicle(${v.id})">삭제</button></td>
        `;
        tbody.appendChild(tr);
    });
}

function deleteVehicle(id) {
    if(confirm('삭제하시겠습니까?')) {
        vehicleData = vehicleData.filter(v => v.id !== id);
        renderTable();
    }
}

function showAlert(msg) {
    const alertModal = document.getElementById('customAlert');
    document.getElementById('alertMessage').innerText = msg;
    document.getElementById('alertBtns').innerHTML = `<button class="btn-submit" onclick="document.getElementById('customAlert').style.display='none'">확인</button>`;
    alertModal.style.display = 'flex';
}

window.onload = renderTable;