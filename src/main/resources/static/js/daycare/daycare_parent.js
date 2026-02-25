/* =========================================
   /js/daycare/daycare_parent.js - 학부모 의견란 피드 전용
   ========================================= */

// 백엔드 연동 전 화면 확인용 피드 데이터 (최신순 정렬 가정)
const feedData = [
    { 
        id: 3, 
        author: "지우 아빠", 
        date: "2026.02.24 14:30", 
        content: "이번 주 식단표를 보니 아이들이 좋아하는 반찬이 많네요! 영양사 선생님 항상 고생 많으십니다. 혹시 알레르기 유발 물질 표기를 조금만 더 크게 해주실 수 있을까요? 폰트가 작아서 모바일로 볼 때 약간 헷갈릴 때가 있어서요. ^^",
        isMine: true // 내가 쓴 글인지 판별하는 플래그 (삭제/수정 버튼 노출용)
    },
    { 
        id: 2, 
        author: "서연 맘", 
        date: "2026.02.23 10:15", 
        content: "봄맞이 소풍 장소로 근처 생태공원은 어떨까요? 지난 주말에 다녀왔는데 돗자리 펴고 밥 먹기도 좋고 안전하더라고요. 의견 내봅니다!",
        isMine: false 
    },
    { 
        id: 1, 
        author: "도윤 맘", 
        date: "2026.02.21 09:00", 
        content: "아침 등원 시간에 차량 탑승 장소에 불법 주차된 차들이 가끔 있어서 위험해 보입니다. 아파트 관리사무소 쪽에 협조 요청을 한 번 해주시면 감사하겠습니다.",
        isMine: false 
    }
];

document.addEventListener("DOMContentLoaded", () => {
    renderFeed();
});

/* 피드 렌더링 함수 */
function renderFeed() {
    const container = document.getElementById('feedContainer');
    
    container.innerHTML = feedData.map(feed => `
        <div class="feed-item">
            <div class="feed-header">
                <span class="feed-author">👤 ${feed.author}</span>
                <span class="feed-date">${feed.date}</span>
            </div>
            <div class="feed-content">${feed.content}</div>
            
            ${feed.isMine ? `
                <div class="feed-actions">
                    <button class="btn-sub" style="padding: 5px 12px; font-size: 12px;" onclick="editFeed(${feed.id})">수정</button>
                    <form action="/daycare/parent/delete" method="post" style="display:inline-block; margin-left:5px;" onsubmit="return confirm('이 의견을 삭제하시겠습니까?');">
                        <input type="hidden" name="id" value="${feed.id}">
                        <button type="submit" class="btn-danger" style="padding: 5px 12px; font-size: 12px;">삭제</button>
                    </form>
                </div>
            ` : ''}
        </div>
    `).join('') || '<div style="text-align:center; padding:50px; color:#888;">첫 번째 의견을 남겨주세요!</div>';
}

/* 임시 수정 기능 (추후 백엔드 연동 필요) */
function editFeed(id) {
    alert("실제 백엔드 연동 시, 이 글을 수정하는 팝업이나 화면으로 이동합니다.\n(선택된 글 번호: " + id + ")");
}