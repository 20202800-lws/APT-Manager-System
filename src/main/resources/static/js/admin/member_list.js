/**
 * admin_member.js
 * 회원 관리 페이지 로직을 처리하는 스크립트 (서버 페이징 연동 완료)
 */

const adminMember = (function() {
    
    // JSP에서 전달받은 서버 데이터
    let memberList = window.globalMemberList || [];
    const modal = document.getElementById('memberModal');

    // 초기화 및 이벤트 리스너 등록
    document.addEventListener('DOMContentLoaded', () => {
        // 백엔드에서 받은 데이터 즉시 렌더링
        renderTable(memberList);

        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target && event.target.classList.contains('modal-overlay')) {
                closeModal();
            }
        }
    });

    /* =========================================
       1. 필터 및 검색 로직 (서버 연동)
       ========================================= */

    // 탭(상태별) 클릭 시 서버로 이동
    function filterTab(tabCode) {
        // 탭 이동 시에도 현재 입력해둔 검색어가 있다면 유지해줍니다.
        const type = document.getElementById('searchType').value;
        const kw = document.getElementById('keyword').value.trim();
        
        let targetUrl = `?page=0&tab=${tabCode}`;
        
        // 검색어가 있으면 해당 타입(kwName, kwAddress, kwPhone) 파라미터 추가
        if(kw) {
            targetUrl += `&${type}=${encodeURIComponent(kw)}`;
        }
        
        location.href = targetUrl;
    }

    // 돋보기 버튼 클릭 시 서버로 이동
    function searchTable() {
        const urlParams = new URLSearchParams(window.location.search);
        const tab = urlParams.get('tab') || 'ALL'; // 현재 탭 유지
        
        const type = document.getElementById('searchType').value; // kwName, kwAddress, kwPhone 중 하나
        const kw = document.getElementById('keyword').value.trim();
        
        let targetUrl = `?page=0&tab=${tab}`;
        
        if(kw) {
            targetUrl += `&${type}=${encodeURIComponent(kw)}`;
        }
        
        location.href = targetUrl;
    }

    /* =========================================
       2. 화면 렌더링 로직
       ========================================= */

    // 테이블 렌더링 (서버에서 받은 1페이지 분량 데이터만 그림)
    function renderTable(data) {
        const tbody = document.getElementById('memberTableBody');
        if(!tbody) return;
        
        if (!data || data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="padding:40px; color:#999; text-align:center;">조건에 맞는 회원이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = data.map(item => {
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
                case 'ADMIN':
                    badgeHtml = '<span class="badge badge-blue">관리자</span>';
                    btnHtml = `<button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')">관리</button>`;
                    break;
                default:
                    badgeHtml = '<span class="badge badge-gray">알수없음</span>';
                    btnHtml = `<button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')">상세</button>`;
            }

            // 동/호수가 null이거나 숫자가 아닐 경우의 예외 처리
            let dongHoText = (!item.dong || item.dong === 'null') ? '-' : `${item.dong}동 ${item.ho}호`;

            return `
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
        }).join('');
    }

    /* =========================================
       3. CRUD 및 모달 비즈니스 로직
       ========================================= */

    // 회원 승인 (AJAX 연동)
    function approveMember(id) {
        if(!confirm('해당 회원의 가입을 승인하시겠습니까?')) return;

        fetch('/admin/member/approve', { 
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 'userId': id })
        })
        .then(response => {
            if (response.ok) {
                alert("성공적으로 승인 처리되었습니다.");
                // 성공 시 화면을 새로고침하여 상단 통계(대기 인원 등)와 목록을 즉시 갱신!
                location.reload(); 
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

        // JSP에서 추가했던 hidden input에 아이디 심기
        document.getElementById('modalUserId').value = item.userId; 
        
        document.getElementById('modalUserName').value = item.userName;
        document.getElementById('modalDong').value = item.dong;
        document.getElementById('modalHo').value = item.ho;
        document.getElementById('modalPhone').value = item.phone;
        document.getElementById('modalEmail').value = item.email;
        document.getElementById('modalJoinDate').innerText = item.joinDate;
        document.getElementById('modalApprovalStatus').value = item.approvalStatus;

        modal.style.display = 'flex'; // admin.css 모달 띄우기 방식
    }

    function closeModal() {
        if(modal) modal.style.display = 'none';
    }

    function saveMember() {
        const id = document.getElementById('modalUserId').value;
        // TODO: 향후 AdminMemberController 에 수정 API(/admin/member/update) 추가 필요
        alert(`[API 연동 필요] 회원(${id}) 정보가 정상적으로 수정되었습니다.`);
        closeModal();
    }

    function deleteMember() {
        const id = document.getElementById('modalUserId').value;
        if(confirm('이 회원을 강제 탈퇴 처리하시겠습니까? (이 작업은 복구할 수 없습니다)')) {
            // TODO: 향후 AdminMemberController 에 삭제 API(/admin/member/delete) 추가 필요
            alert(`[API 연동 필요] 회원(${id})이 시스템에서 삭제되었습니다.`);
            closeModal();
        }
    }

    // 캡슐화된 함수 노출
    return {
        filterTab, searchTable, approveMember,
        openModal, closeModal, saveMember, deleteMember
    };

})();