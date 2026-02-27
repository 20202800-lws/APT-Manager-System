/**
 * admin_member.js
 * 회원 관리 페이지 로직을 처리하는 스크립트 (페이징 연동 완료)
 */

const adminMember = (function() {
    
    // JSP에서 전달받은 전체 데이터
    let memberList = window.globalMemberList || [];
    let currentFilteredList = []; 
    
    let currentFilterCode = 'ALL'; 
    const TAB_WIDTH = 140; 
    let currentUserId = null; 
    const modal = document.getElementById('memberModal');

    // 페이징 관련 변수
    let currentPage = 1;
    const rowsPerPage = 10; 

    // 초기화 함수
    function init() {
        updateStats();
        filterTab('ALL', 0); 

        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target === modal) {
                closeModal();
            }
        }
    }

    // 통계 업데이트
    function updateStats() {
        const counts = {
            total: memberList.length,
            wait: memberList.filter(m => m.approvalStatus === 'WAIT').length,
            active: memberList.filter(m => m.approvalStatus === 'ACT').length,
            admin: memberList.filter(m => m.approvalStatus === 'ADM').length
        };

        const totalEl = document.getElementById('statTotalCount');
        const waitEl = document.getElementById('statWaitCount');
        const activeEl = document.getElementById('statActiveCount');
        const adminEl = document.getElementById('statAdminCount');

        if(totalEl) totalEl.innerHTML = `${counts.total}<span class="unit">명</span>`;
        if(waitEl) waitEl.innerHTML = `${counts.wait}<span class="unit">명</span>`;
        if(activeEl) activeEl.innerHTML = `${counts.active}<span class="unit">명</span>`;
        if(adminEl) adminEl.innerHTML = `${counts.admin}<span class="unit">명</span>`;
    }

    // 탭 필터링
    function filterTab(code, index) {
        currentFilterCode = code;

        const highlighter = document.getElementById('tabHighlighter');
        if (highlighter) {
            highlighter.style.transform = `translateX(${index * TAB_WIDTH}px)`;
        }
        
        document.querySelectorAll('.tab-btn').forEach((btn, i) => {
            if(i === index) btn.classList.add('active');
            else btn.classList.remove('active');
        });

        const titles = { 
            'ALL': '전체 회원 목록', 
            'WAIT': '가입 승인 대기 목록', 
            'ACT': '입주민 회원 목록',
            'ADM': '관리자 목록'
        };
        const titleEl = document.getElementById('tableTitle');
        if(titleEl) titleEl.innerText = titles[code] || '회원 목록';

        // 탭이 바뀌면 무조건 1페이지부터 보여줌
        searchTable(true);
    }

    // 검색 및 데이터 필터링
    function searchTable(isResetPage = false) {
        if (isResetPage) currentPage = 1;

        const searchInput = document.getElementById('searchInput');
        const keyword = searchInput ? searchInput.value.toLowerCase().trim() : '';
        
        currentFilteredList = memberList.filter(item => {
            if (currentFilterCode !== 'ALL' && item.approvalStatus !== currentFilterCode) return false;
            
            if (keyword) {
                const dongStr = String(item.dong);
                const hoStr = String(item.ho);
                
                return item.userName.toLowerCase().includes(keyword) || 
                       dongStr.includes(keyword) || 
                       hoStr.includes(keyword) || 
                       item.phone.includes(keyword);
            }
            return true;
        });

        renderTable();
    }

    // 테이블 렌더링 (페이징 적용)
    function renderTable() {
        const tbody = document.getElementById('memberTableBody');
        if(!tbody) return;
        
        if (currentFilteredList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="padding:40px; color:#999; text-align:center;">조건에 맞는 회원이 없습니다.</td></tr>';
            renderPagination(0);
            return;
        }

        const totalPages = Math.ceil(currentFilteredList.length / rowsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const startIndex = (currentPage - 1) * rowsPerPage;
        const paginatedData = currentFilteredList.slice(startIndex, startIndex + rowsPerPage);

        let rowsHtml = '';
        paginatedData.forEach(item => {
            let badgeHtml = '';
            let btnHtml = '';
            
            switch(item.approvalStatus) {
                case 'WAIT':
                    badgeHtml = '<span class="badge badge-warning">승인대기</span>';
                    btnHtml = `
                        <button class="btn btn-primary btn-xs" onclick="adminMember.approveMember('${item.userId}')">승인</button>
                        <button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')"><i class="fa-solid fa-gear"></i></button>
                    `;
                    break;
                case 'ACT':
                    badgeHtml = '<span class="badge badge-success">입주민</span>';
                    btnHtml = `<button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')">상세</button>`;
                    break;
                case 'ADM':
                    // ★ 수정: 없는 badge-dark 대신 badge-blue 사용
                    badgeHtml = '<span class="badge badge-blue">관리자</span>';
                    btnHtml = `<button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')">관리</button>`;
                    break;
                default:
                    badgeHtml = '<span class="badge badge-red">정지</span>';
                    btnHtml = `<button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')">상세</button>`;
            }

            let dongHoText = isNaN(item.dong) ? item.dong : `${item.dong}동 ${item.ho}호`;

            rowsHtml += `
                <tr>
                    <td>${badgeHtml}</td>
                    <td style="font-weight:600;">${dongHoText}</td>
                    <td>${item.userName}</td>
                    <td>${item.phone}</td>
                    <td style="color:#666;">${item.email}</td>
                    <td>${item.joinDate}</td>
                    <td style="display:flex; justify-content:center; gap:5px;">
                        ${btnHtml}
                    </td>
                </tr>
            `;
        });

        tbody.innerHTML = rowsHtml;
        renderPagination(currentFilteredList.length);
    }

    // 페이징 버튼 렌더링
    function renderPagination(totalCount) {
        const container = document.getElementById('paginationWrapper');
        if (!container) return;

        // ★ 수정: 데이터가 0개일 때만 비우고, 1페이지라도 있으면 [1] 버튼 유지
        if (totalCount === 0) { 
            container.innerHTML = ''; 
            return; 
        }

        const totalPages = Math.ceil(totalCount / rowsPerPage);

        let html = `<button class="btn btn-secondary btn-xs" ${currentPage === 1 ? 'disabled' : `onclick="adminMember.goToPage(${currentPage - 1})"`}>&lt;</button> `;

        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'btn-primary' : 'btn-secondary';
            html += `<button class="btn ${activeClass} btn-xs" onclick="adminMember.goToPage(${i})">${i}</button> `;
        }

        html += `<button class="btn btn-secondary btn-xs" ${currentPage === totalPages ? 'disabled' : `onclick="adminMember.goToPage(${currentPage + 1})"`}>&gt;</button>`;
        
        container.innerHTML = html;
    }

    // 페이지 이동 로직
    function goToPage(page) {
        currentPage = page;
        renderTable();
    }

    /* =========================================
       CRUD 비즈니스 로직
       ========================================= */

    /*function approveMember(id) {
        if(confirm('해당 회원의 가입을 승인하시겠습니까?')) {
            const member = memberList.find(m => m.userId === id);
            if(member) {
                member.approvalStatus = 'ACT'; 
                updateStats(); 
                searchTable(false); // 페이지 유지
                alert("승인 처리되었습니다.");
            }
        }
    }*/
	
	function approveMember(id) {
	    if(!confirm('해당 회원의 가입을 승인하시겠습니까?')) return;

	    
	    fetch('/admin/member/approve', { 
	        method: 'POST',
	        headers: {
	            'Content-Type': 'application/x-www-form-urlencoded',
	            
	        },
	        body: new URLSearchParams({ 'userId': id })
	    })
	    .then(response => {
	        if (response.ok) {
	            const member = memberList.find(m => m.userId === id);
	            if(member) {
	                member.approvalStatus = 'ACT'; 
	                updateStats(); 
	                searchTable(false); // 리스트 새로고침 (JS 내부 함수)
	                alert("성공적으로 승인 처리되었습니다.");
	            }
	        } else {
	            alert("서버 오류로 인해 승인에 실패했습니다.");
	        }
	    })
	    .catch(err => {
	        console.error("Error:", err);
	        alert("요청 중 네트워크 오류가 발생했습니다.");
	    });
	}

    function openModal(id) {
        const item = memberList.find(d => d.userId === id);
        if(!item || !modal) return;

        currentUserId = id;

        document.getElementById('modalUserName').value = item.userName;
        document.getElementById('modalDong').value = item.dong;
        document.getElementById('modalHo').value = item.ho;
        document.getElementById('modalPhone').value = item.phone;
        document.getElementById('modalEmail').value = item.email;
        document.getElementById('modalJoinDate').innerText = item.joinDate;
        document.getElementById('modalApprovalStatus').value = item.approvalStatus;

        // ★ 수정: setTimeout 제거하고 admin.css의 애니메이션 활용
        modal.style.display = 'flex';
    }

    function saveMember() {
        const item = memberList.find(d => d.userId === currentUserId);
        if(item) {
            item.userName = document.getElementById('modalUserName').value;
            item.dong = document.getElementById('modalDong').value;
            item.ho = document.getElementById('modalHo').value;
            item.phone = document.getElementById('modalPhone').value;
            item.approvalStatus = document.getElementById('modalApprovalStatus').value;
            
            alert('회원 정보가 수정되었습니다.');
            closeModal();
            updateStats();
            searchTable(false); // 페이지 유지
        }
    }

    function deleteMember() {
        if(confirm('회원을 삭제하시겠습니까? (DB Soft Delete 권장)')) {
            memberList = memberList.filter(m => m.userId !== currentUserId);
            alert('삭제되었습니다.');
            closeModal();
            updateStats();
            searchTable(false); 
        }
    }

    function closeModal() {
        if(!modal) return;
        // ★ 수정: setTimeout 제거하고 즉시 display none 처리
        modal.style.display = 'none';
        currentUserId = null; 
    }

    // 초기화 실행
    document.addEventListener('DOMContentLoaded', init);

    // 외부 노출
    return {
        filterTab,
        searchTable,
        goToPage,
        approveMember,
        openModal,
        saveMember,
        deleteMember,
        closeModal
    };

})();