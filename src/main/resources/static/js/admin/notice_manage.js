/* =========================================
   관리자 | 공지사항 관리 로직 (서버 페이징 연동 완료)
   ========================================= */

const noticeManager = (function() {

    let noticeList = window.globalNoticeList || [];

    document.addEventListener('DOMContentLoaded', () => {
        renderTable();

        const modal = document.getElementById('noticeModal');
        window.addEventListener('click', (event) => {
            if (event.target === modal) closeModal();
        });
    });

    function searchTable() {
        const keywordInput = document.getElementById('searchKeyword');
        const keyword = keywordInput ? keywordInput.value.trim() : '';
        const filterEl = document.getElementById('searchType');
        const filter = filterEl ? filterEl.value : 'title';

        location.href = `?page=0&searchInput=${encodeURIComponent(keyword)}&searchType=${filter}`;
    }

    function renderTable() {
        const tbody = document.getElementById('noticeTableBody');
        if (!tbody) return;

        const data = noticeList;

        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="padding:40px; color:#999; text-align:center;">조건에 맞는 공지사항이 없습니다.</td></tr>';
            return;
        }

        tbody.innerHTML = data.map(item => {
            const titlePrefix = item.isImportant ? '<span style="color:var(--danger); font-weight:700; margin-right:5px;">[필독]</span>' : '';
            const statusBadge = item.isVisible
                ? '<span class="badge badge-success">공개</span>'
                : '<span class="badge badge-secondary" style="background-color:#7f8c8d; color:white; padding:3px 6px; border-radius:4px; font-size:12px;">비공개</span>';

            return `
                <tr>
                    <td>${item.noticeId}</td>
                    <td style="text-align:left; font-weight:500; cursor:pointer;" class="td-title" onclick="noticeManager.openModal('edit', ${item.noticeId})">
                        ${titlePrefix}${item.title}
                    </td>
                    <td>${item.writerId}</td>
                    <td>${item.regDate}</td>
                    <td>${item.views}</td>
					<td>
                        ${statusBadge}
                        <button type="button" style="background-color: #e74c3c; color: white; border: none; padding: 4px 8px; border-radius: 4px; cursor: pointer; margin-left: 5px; font-size:12px; font-weight:600;" 
                                onclick="noticeManager.deleteNotice(${item.noticeId}, event)">삭제</button>
                    </td>
                </tr>
            `;
        }).join('');
    }

    function openModal(type, id = null) {
        const modal = document.getElementById('noticeModal');
        if (!modal) return;

        if (type === 'create') {
            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-bullhorn"></i> 공지사항 등록';
            document.getElementById('noticeForm').reset();
            document.getElementById('modalNoticeId').value = '';
            document.getElementById('checkVisible').checked = true;

            document.getElementById('noticeForm').action = "/admin/notice/write_pro";
        } else {
            document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-pen-to-square"></i> 공지사항 수정';

            const item = noticeList.find(n => n.noticeId === id);
            if (item) {
                document.getElementById('modalNoticeId').value = item.noticeId;
                document.getElementById('inputTitle').value = item.title;
                document.getElementById('inputContent').value = item.content || '';
                document.getElementById('checkImportant').checked = item.isImportant;

                document.getElementById('checkHidden').checked = !item.isVisible;

                document.getElementById('noticeForm').action = "/admin/notice/edit_pro";
            }
        }

        modal.style.display = 'flex';
    }

    function closeModal() {
        const modal = document.getElementById('noticeModal');
        if (modal) modal.style.display = 'none';
    }

    function saveNotice() {
        const titleInput = document.getElementById('inputTitle').value.trim();
        const contentInput = document.getElementById('inputContent').value.trim();
        const form = document.getElementById('noticeForm');

        if (!titleInput) {
            alert('제목을 입력해주세요.');
            document.getElementById('inputTitle').focus();
            return;
        }

        if (!contentInput) {
            alert('내용을 입력해주세요.');
            document.getElementById('inputContent').focus();
            return;
        }

        form.submit();
    }

    function deleteNotice(id, event) {
        event.stopPropagation(); // 모달 창이 열리는 것을 방지

        if (confirm('정말 이 공지사항을 삭제하시겠습니까?')) {
            const form = document.createElement('form');
            form.method = 'post';
            form.action = '/admin/notice/delete';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'noticeId';
            input.value = id;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }

    return { searchTable, openModal, closeModal, saveNotice, deleteNotice };

})();