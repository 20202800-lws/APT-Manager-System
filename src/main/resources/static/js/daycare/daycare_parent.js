/* =========================================
   /js/daycare/daycare_parent.js - 실시간 DB 연동
   ========================================= */

   document.addEventListener("DOMContentLoaded", () => {
       loadFeeds();
   });

   function loadFeeds() {
       fetch('/api/daycare/parents')
           .then(res => res.json())
           .then(data => renderFeed(data))
           .catch(err => console.error("로드 에러:", err));
   }

   function renderFeed(feedList) {
       const container = document.getElementById('feedContainer');
       container.innerHTML = feedList.map(feed => `
           <div class="feed-item">
               <div class="feed-header">
                   <span class="feed-author">👤 ${feed.authorName}</span>
                   <span class="feed-date">${feed.regDate}</span>
               </div>
               <div class="feed-content">${feed.content}</div>
               ${feed.isMine ? `
                   <div class="feed-actions">
                       <button class="btn-sub" onclick="editFeed(${feed.id}, '${feed.content}')">수정</button>
                       <form action="/daycare/parent/delete" method="post" style="display:inline-block;" onsubmit="return confirm('삭제하시겠습니까?');">
                           <input type="hidden" name="id" value="${feed.id}">
                           <button type="submit" class="btn-danger">삭제</button>
                       </form>
                   </div>
               ` : ''}
           </div>
       `).join('') || '<div style="text-align:center; padding:50px;">첫 의견을 남겨주세요!</div>';
   }

   function editFeed(id, oldContent) {
       const newContent = prompt("의견을 수정하시겠습니까?", oldContent);
       if (newContent && newContent.trim() !== "" && newContent !== oldContent) {
           const form = document.createElement('form');
           form.method = 'POST';
           form.action = '/daycare/parent/update';

           const idIn = document.createElement('input');
           idIn.type = 'hidden'; idIn.name = 'id'; idIn.value = id;
           
           const conIn = document.createElement('input');
           conIn.type = 'hidden'; conIn.name = 'content'; conIn.value = newContent;

           form.appendChild(idIn); form.appendChild(conIn);
           document.body.appendChild(form);
           form.submit();
       }
   }