/* =========================================
   민원 접수 현황 (Admin Complaint Logic)
   Refactored based on ERD: COMPLAINT Table
   ========================================= */

const complaintManager = (function() {

    // 1. Mock Data (ERD Mapping Applied)
    // [Change Log]
    // complaintNo -> compId
    // categoryCode -> category
    // writerName -> userName (Mapped to USERS.user_name)
    // complaintStatus -> compStatus
    // replyContent -> reply
    let complaintList = [
        { compId: 1, category: 'FACILITY', title: '지하주차장 누수', content: '물 떨어짐', userName: '김철수(105-1204)', regDate: '2024-02-04', compStatus: 'PENDING', reply: '' },
        { compId: 2, category: 'NOISE', title: '층간소음 문의', content: '너무 시끄러움', userName: '이영희(101-502)', regDate: '2024-02-04', compStatus: 'PROCESSING', reply: '전달 완료' },
        { compId: 3, category: 'ETC', title: '헬스장 건의', content: '시간 조정 요청', userName: '박민수(103-201)', regDate: '2024-02-03', compStatus: 'COMPLETED', reply: '검토 예정' },
        { compId: 4, category: 'PARKING', title: '불법 주차', content: '외부 차량', userName: '최지훈(102-101)', regDate: '2024-02-02', compStatus: 'PENDING', reply: '' },
        { compId: 5, category: 'FACILITY', title: '현관문 고장', content: '힌지 파손', userName: '정수진(102-305)', regDate: '2024-02-01', compStatus: 'COMPLETED', reply: '수리 완료' }
    ];

    document.addEventListener('DOMContentLoaded', () => {
        updateStats();
        renderTable(complaintList);
        
        // Modal Outside Click Close
        const modal = document.getElementById('complaintModal');
        window.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });
    });

    /* =========================================
       2. Logic Functions
       ========================================= */
    function updateStats() {
        const setHtml = (id, count) => {
            const el = document.getElementById(id);
            if(el) el.innerHTML = `${count}<span class="unit">건</span>`;
        };

        // [Mapping Change] complaintStatus -> compStatus
        setHtml('statPendingCount', complaintList.filter(d => d.compStatus === 'PENDING').length);
        setHtml('statProcessingCount', complaintList.filter(d => d.compStatus === 'PROCESSING').length);
        setHtml('statCompletedCount', complaintList.filter(d => d.compStatus === 'COMPLETED').length);
        setHtml('statTotalCount', complaintList.length);
    }

    function searchTable() {
        const categoryVal = document.getElementById('categoryFilter').value;
        const statusVal = document.getElementById('statusFilter').value;
        const keyword = document.getElementById('keyword').value.toLowerCase().trim();

        const filtered = complaintList.filter(item => {
            // [Mapping Change] categoryCode -> category
            if (categoryVal && item.category !== categoryVal) return false;
            
            // [Mapping Change] complaintStatus -> compStatus
            if (statusVal && item.compStatus !== statusVal) return false;
            
            if (keyword) {
                const matchTitle = item.title.toLowerCase().includes(keyword);
                // [Mapping Change] writerName -> userName
                const matchUser = item.userName.toLowerCase().includes(keyword);
                if (!matchTitle && !matchUser) return false;
            }
            return true;
        });
        
        renderTable(filtered);
    }

    function renderTable(data) {
        const tbody = document.getElementById('complaintTableBody');
        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="padding:40px; text-align:center; color:#999;">데이터가 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = data.map(item => {
            let catName = '기타';
            let catClass = 'badge-gray';
            
            // [Mapping Change] categoryCode -> category
            switch(item.category) {
                case 'FACILITY': catName = '시설보수'; catClass = 'badge-red'; break;
                case 'NOISE': catName = '층간소음'; catClass = 'badge-blue'; break;
                case 'PARKING': catName = '주차문제'; catClass = 'badge-warning'; break;
                case 'ETC': catName = '기타'; catClass = 'badge-gray'; break;
            }

            let statusBadge = '';
            // [Mapping Change] complaintStatus -> compStatus
            if(item.compStatus === 'PENDING') statusBadge = '<span class="badge badge-gray">접수</span>';
            else if(item.compStatus === 'PROCESSING') statusBadge = '<span class="badge badge-blue">진행중</span>';
            else if(item.compStatus === 'COMPLETED') statusBadge = '<span class="badge badge-green">완료</span>';

            // [Mapping Change] complaintNo -> compId, writerName -> userName
            return `
                <tr>
                    <td style="color:#666;">${item.compId}</td>
                    <td><span class="badge ${catClass}">${catName}</span></td>
                    <td style="text-align:left; padding-left:15px; font-weight:500; cursor:pointer; color:#333;" 
                        onclick="complaintManager.openModal(${item.compId})">
                        ${item.title}
                    </td>
                    <td>${item.userName}</td>
                    <td style="color:#666;">${item.regDate}</td>
                    <td>${statusBadge}</td>
                    <td>
                        <button class="btn btn-secondary btn-xs" onclick="complaintManager.openModal(${item.compId})">
                            <i class="fa-solid fa-pen-to-square"></i> 관리
                        </button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    /* =========================================
       3. Modal Logic
       ========================================= */
    const modal = document.getElementById('complaintModal');

    function openModal(id) {
        // [Mapping Change] complaintNo -> compId
        const item = complaintList.find(d => d.compId === id);
        if(!item) return;

        const catMap = { 'FACILITY': '시설보수', 'NOISE': '층간소음', 'PARKING': '주차문제', 'ETC': '기타' };

        // [Mapping Change] Binding to Modal Inputs
        document.getElementById('targetCompId').value = item.compId; // Changed ID
        document.getElementById('modalCategory').innerText = catMap[item.category] || item.category;
        document.getElementById('modalUserName').innerText = item.userName; // Changed ID
        document.getElementById('modalRegDate').innerText = item.regDate;
        document.getElementById('modalContent').innerText = item.content;
        
        // [Mapping Change] replyContent -> reply, complaintStatus -> compStatus
        document.getElementById('modalReply').value = item.reply || ''; 
        document.getElementById('modalCompStatus').value = item.compStatus;

        if(modal) modal.classList.add('active');
    }

    function closeModal() {
        if(modal) modal.classList.remove('active');
    }

    function saveComplaint() {
        // [Mapping Change] Collecting Data
        const id = parseInt(document.getElementById('targetCompId').value);
        const replyText = document.getElementById('modalReply').value;
        const statusText = document.getElementById('modalCompStatus').value;
        
        const item = complaintList.find(d => d.compId === id);
        if(item) {
            // [Mapping Change] Update Object
            item.reply = replyText;
            item.compStatus = statusText;

            /* // TODO: Server-side fetch example (Mapping check)
            fetch('/admin/complaint/update', {
                method: 'POST',
                body: JSON.stringify({
                    compId: id,         // Matches ERD comp_id
                    reply: replyText,   // Matches ERD reply
                    compStatus: statusText // Matches ERD comp_status
                })
            });
            */
            
            alert("저장되었습니다.");
            closeModal();
            updateStats();
            searchTable(); 
        }
    }

    return { openModal, closeModal, saveComplaint, searchTable };

})();