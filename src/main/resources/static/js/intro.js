/*아파트 소개 */

const planData = {
    '59A': { img: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=1200', title: '59㎡ A TYPE' },
    '59B': { img: 'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?w=1200', title: '59㎡ B TYPE' },
    '84A': { img: 'https://images.unsplash.com/photo-1600607687940-c52af0424225?w=1200', title: '84㎡ A TYPE' },
    '84B': { img: 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=1200', title: '84㎡ B TYPE' },
    '84C': { img: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=1200', title: '84㎡ C TYPE' }
};

function changePlan(type, btn) {
    const imgEl = document.getElementById('planImg');
    const titleEl = document.getElementById('planTitle');
    
    if (imgEl && titleEl) {
        imgEl.src = planData[type].img;
        titleEl.innerText = planData[type].title;
        
        document.querySelectorAll('.type-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }
}