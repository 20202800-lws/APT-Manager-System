/* =========================================
   /js/board/board_comp.js - 민원게시판 전용 (서버 연동형)
   ========================================= */

document.addEventListener("DOMContentLoaded", () => {
    // 1. 리스트 페이지: JSP에서 넘겨준 진짜 데이터를 받아 표를 그립니다.
    const tbody = document.getElementById('boardBody');
    if (tbody) {
        // JSP가 주입한 데이터가 있으면 그걸 쓰고, 없으면 빈 배열
        const boardData = window.globalBoardList || [];
        renderList(boardData, tbody);
    }

    // 2. 검색 엔터키 이벤트 (서버로 검색 요청)
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', e => { 
            if (e.key === 'Enter') searchPost(); 
        });
    }
});

// 백엔드 데이터를 화면에 예쁘게 그리는 함수
function renderList(data, tbody) {
    tbody.innerHTML = data.map(p => {
        // DB의 영문 상태값을 한글과 색상으로 변환
        let statusText = '접수 대기';
        let statusColor = '#ef4444'; // 빨강
        if (p.status === 'PROCESSING') { 
            statusText = '진행중'; 
            statusColor = '#f59e0b'; // 주황
        } else if (p.status === 'COMPLETED') { 
            statusText = '처리 완료'; 
            statusColor = '#10b981'; // 초록
        }

        // 비밀글 자물쇠 아이콘 세팅
        const secretIcon = (p.secret === 'true') ? '<i class="fa-solid fa-lock" style="color:#6366f1; margin-right:5px;"></i>' : '';

        // ★ 핵심: 클릭 시 스프링 부트 컨트롤러의 상세 보기 주소로 이동!
        return `
        <tr onclick="location.href='/board/comp/view/${p.id}'" style="cursor:pointer;">
            <td>${p.id}</td>
            <td class="title-cell" style="text-align:left; padding-left:15px;">
                ${secretIcon} ${p.title}
            </td>
            <td>${p.author}</td>
            <td>${p.date.substring(0, 10)}</td> <td>${p.hits}</td>
            <td style="font-weight:bold; color:${statusColor};">${statusText}</td>
        </tr>
        `;
    }).join('') || '<tr><td colspan="6" style="text-align:center; padding:50px; color:#999;">등록된 민원이 없습니다.</td></tr>';
}

// 서버로 검색 요청 보내기 (자바스크립트 검색이 아닌 찐 DB 검색)
function searchPost() {
    const keyword = document.getElementById('searchInput').value.trim();
    // 스프링 부트 컨트롤러에 keyword 파라미터를 달아서 전송!
    location.href = `/board/comp?keyword=${encodeURIComponent(keyword)}`;
}

// =========================================
// 글쓰기 화면 - 다중 이미지 미리보기 기능
// (JSP에 있던 스크립트를 여기로 옮겨와서 통합 관리!)
// =========================================
function previewImages(input) {
    const container = document.getElementById('imagePreviewContainer');
    if (!container) return; // 글쓰기 화면이 아니면 작동 안 함
    
    container.innerHTML = ''; 

    if (input.files && input.files.length > 0) {
        Array.from(input.files).forEach(file => {
            if (file.type.startsWith('image/')) {
                const img = document.createElement('img');
                img.src = URL.createObjectURL(file);
                img.style.width = '120px';
                img.style.height = '120px';
                img.style.objectFit = 'cover';
                img.style.borderRadius = '8px';
                img.style.border = '1px solid #ddd';
                img.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';
                
                container.appendChild(img);
            }
        });
    }
}