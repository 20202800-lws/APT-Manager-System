/**
 * admin_member.js
 * 회원 관리 페이지 로직을 처리하는 스크립트
 */

const adminMember = (function() {
    
    let memberList = window.globalMemberList || [];
    const modal = document.getElementById('memberModal');
    const tModal = document.getElementById('teacherModal');

    document.addEventListener('DOMContentLoaded', () => {
        renderTable(memberList);
        window.onclick = function(event) {
            if (event.target && event.target.classList.contains('modal-overlay')) {
                closeModal();
                closeTeacherModal();
            }
        }
    });

    function filterTab(tabCode) {
        const type = document.getElementById('searchType').value;
        const kw = document.getElementById('keyword').value.trim();
        let targetUrl = `?page=0&tab=${tabCode}`;
        if(kw) targetUrl += `&${type}=${encodeURIComponent(kw)}`;
        location.href = targetUrl;
    }

    function searchTable() {
        const urlParams = new URLSearchParams(window.location.search);
        const tab = urlParams.get('tab') || 'ALL'; 
        const type = document.getElementById('searchType').value;
        const kw = document.getElementById('keyword').value.trim();
        let targetUrl = `?page=0&tab=${tab}`;
        if(kw) targetUrl += `&${type}=${encodeURIComponent(kw)}`;
        location.href = targetUrl;
    }

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
                    btnHtml = `<button class="btn btn-primary btn-xs" onclick="adminMember.approveMember('${item.userId}')">승인</button> <button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')"><i class="fa-solid fa-gear"></i></button>`;
                    break;
                case 'USER':
                    badgeHtml = '<span class="badge badge-success">입주민</span>';
                    btnHtml = `<button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')">상세</button>`;
                    break;
                case 'PARENT':
                    badgeHtml = '<span class="badge" style="background:#f67280; color:white;">학부모</span>';
                    btnHtml = `<button class="btn btn-secondary btn-xs" onclick="adminMember.openModal('${item.userId}')">상세</button>`;
                    break;
                case 'TEACHER':
                    badgeHtml = '<span class="badge" style="background:#f8b195; color:white;">선생님</span>';
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

            let dongHoText = (!item.dong || item.dong === 'null' || item.dong === '') ? '-' : `${item.dong}동 ${item.ho}호`;

            // ★ 학부모 신청을 한 유저에게 예쁜 [학부모 신청] 뱃지 부착
            let nameHtml = item.userName;
            if (item.parentRoleApply && item.approvalStatus === 'USER') {
                nameHtml += ' <span style="background:#fff3e0; color:#f57c00; font-size:11px; padding:2px 6px; border-radius:4px; margin-left:6px; font-weight:bold; vertical-align:middle;">학부모 신청</span>';
            }

            return `
                <tr>
                    <td>${badgeHtml}</td>
                    <td style="font-weight:600;">${dongHoText}</td>
                    <td>${nameHtml}</td>
                    <td>${item.phone}</td>
                    <td style="color:#666;">${item.email}</td>
                    <td>${item.joinDate}</td>
                    <td style="display:flex; justify-content:center; gap:5px;">${btnHtml}</td>
                </tr>
            `;
        }).join('');
    }

    function approveMember(id) {
        if(!confirm('승인하시겠습니까?')) return;
        fetch('/admin/member/approve', { 
            method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: new URLSearchParams({ 'userId': id })
        }).then(res => res.text()).then(result => {
            if (result === 'success') { alert("승인 완료"); location.reload(); } else alert("오류: " + result);
        });
    }

    function openModal(id) {
        const item = memberList.find(d => d.userId === id);
        if(!item || !modal) return;
        document.getElementById('modalUserId').value = item.userId; 
        document.getElementById('modalUserName').value = item.userName;
        document.getElementById('modalDong').value = item.dong;
        document.getElementById('modalHo').value = item.ho;
        document.getElementById('modalPhone').value = item.phone;
        document.getElementById('modalEmail').value = item.email;
        document.getElementById('modalJoinDate').innerText = item.joinDate;
        document.getElementById('modalApprovalStatus').value = item.approvalStatus;
        modal.style.display = 'flex';
    }

    function closeModal() {
        if(modal) modal.style.display = 'none';
    }

    function saveMember() {
        const data = new URLSearchParams({
            userId: document.getElementById('modalUserId').value,
            userName: document.getElementById('modalUserName').value,
            dong: document.getElementById('modalDong').value,
            ho: document.getElementById('modalHo').value,
            phone: document.getElementById('modalPhone').value,
            userRole: document.getElementById('modalApprovalStatus').value
        });

        fetch('/admin/member/update', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: data })
        .then(res => res.text()).then(result => {
            if (result === 'success') { alert("수정 완료"); location.reload(); } else alert("수정 실패: " + result);
        }).catch(err => alert("네트워크 오류"));
    }

    function deleteMember() {
        const id = document.getElementById('modalUserId').value;
        if(confirm('강제 탈퇴 시키겠습니까?')) {
            fetch('/admin/member/delete', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: new URLSearchParams({ 'userId': id }) })
            .then(res => res.text()).then(result => {
                if (result === 'success') { alert(`삭제 완료`); location.reload(); } else alert("삭제 실패: " + result);
            }).catch(err => alert("네트워크 오류"));
        }
    }

    function openTeacherModal() {
        if(tModal) tModal.style.display = 'flex';
    }

    function closeTeacherModal() {
        if(tModal) {
            tModal.style.display = 'none';
            document.getElementById('t_userId').value = '';
            document.getElementById('t_userPw').value = '';
            document.getElementById('t_userName').value = '';
            document.getElementById('t_phone').value = '';
        }
    }

    function autoHyphenPhone(target) {
        let raw = target.value.replace(/[^0-9]/g, '');
        let format = '';
        
        if (raw.length < 4) {
            format = raw;
        } else if (raw.length < 7) {
            format = raw.substr(0, 3) + '-' + raw.substr(3);
        } else if (raw.length < 11) {
            format = raw.substr(0, 3) + '-' + raw.substr(3, 3) + '-' + raw.substr(6);
        } else {
            format = raw.substr(0, 3) + '-' + raw.substr(3, 4) + '-' + raw.substr(7);
        }
        
        target.value = format; 
    }

    function createTeacher() {
        const userId = document.getElementById('t_userId').value.trim();
        const userPw = document.getElementById('t_userPw').value.trim();
        const userName = document.getElementById('t_userName').value.trim();
        const fullPhone = document.getElementById('t_phone').value.trim();

        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.(com|net|org|kr|co\.kr|go\.kr|ac\.kr)$/i;
        if (!emailRegex.test(userId)) {
            alert("아이디는 올바른 이메일 형식이어야 합니다.\n(예: teacher@naver.com)");
            return;
        }

        const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&~^])[A-Za-z\d@$!%*#?&~^]{8,}$/;
        if (!pwRegex.test(userPw)) {
            alert("비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.");
            return;
        }

        if(!userName) {
            alert("선생님 이름을 입력해주세요.");
            return;
        }

        const phoneRegex = /^\d{3}-\d{3,4}-\d{4}$/;
        if(!phoneRegex.test(fullPhone)) {
            alert("올바른 휴대전화 번호를 끝까지 입력해주세요. (예: 010-1234-5678)");
            return;
        }

        fetch('/admin/member/create-teacher', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 
                userId: userId, 
                userPw: userPw, 
                userName: userName, 
                phone: fullPhone 
            })
        })
        .then(res => res.text())
        .then(result => {
            if (result === 'success') {
                alert("선생님 계정이 성공적으로 생성되었습니다.");
                location.reload();
            } else {
                alert("계정 생성 실패: " + result);
            }
        }).catch(err => alert("네트워크 오류!"));
    }

    return {
        filterTab, searchTable, approveMember,
        openModal, closeModal, saveMember, deleteMember,
        openTeacherModal, closeTeacherModal, createTeacher,
        autoHyphenPhone 
    };

})();