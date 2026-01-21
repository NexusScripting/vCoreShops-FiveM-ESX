let allItems = [];
let cart = [];
let currentCurrency = "$";
let allowedCategories = [];

window.addEventListener('message', function(event) {
    if (event.data.action == 'openShop') {
        $('#shop-ui').css('display', 'flex').hide().fadeIn(250);
        
        allItems = event.data.items;
        currentCurrency = event.data.currency;
        allowedCategories = event.data.allowedCategories || [];
        
        if(event.data.username) {
            $('#player-name').text(event.data.username);
        }
        if(event.data.shopLabel) {
            $('#shop-title').text(event.data.shopLabel);
        }

        updateSidebarVisibility();
        cart = []; 
        updateCartBadge();
        $('#cart-panel').removeClass('open');
        filterItems('all');
        setActiveButton('all');

    } else if (event.data.action == 'closeShop') {
        $('#shop-ui').fadeOut(200);
    }
});

document.onkeydown = function(data) {
    if (data.which == 27) { 
        closeShop();
    }
};

function closeShop() {
    $('#shop-ui').fadeOut(200);
    $.post('https://vCore_Shops/close', JSON.stringify({}));
}

$('.menu-item').not('.logout').click(function() {
    let category = $(this).data('category');
    setActiveButton(category);
    filterItems(category);
});

function setActiveButton(category) {
    $('.menu-item').removeClass('active');
    $(`.menu-item[data-category="${category}"]`).addClass('active');
}

function updateSidebarVisibility() {
    $('.menu-item[data-category="all"]').show();

    $('.menu-item').not('.logout').not('[data-category="all"]').each(function() {
        let cat = $(this).data('category');
        if (allowedCategories.includes(cat)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
}

function filterItems(category) {
    let container = $('#product-container');
    container.html('');

    let filtered = [];
    
    if (category === 'all' || !category) {
        filtered = allItems.filter(item => allowedCategories.includes(item.category));
    } else {
        if(allowedCategories.includes(category)) {
            filtered = allItems.filter(item => item.category === category);
        }
    }

    if (filtered.length === 0) {
        container.html('<div style="color:#64748b; margin-top:40px; width:100%; text-align:center; grid-column: 1/-1;">No products available here.</div>');
        return;
    }

    filtered.forEach((item, index) => {
        let delay = index * 0.05; 
        
        let html = `
            <div class="product-card" style="animation: fadeUp 0.3s ease forwards; animation-delay: ${delay}s; opacity: 0;">
                <div class="img-container">
                    <img src="img/${item.image}" alt="${item.label}">
                </div>
                
                <div class="card-info">
                    <div class="card-title">${item.label}</div>
                    <div class="card-price">${currentCurrency}${item.price}</div>
                </div>

                <button class="btn-add" onclick="addToCart('${item.name}')">
                    <i class="fas fa-plus"></i> Add to Cart
                </button>
            </div>
        `;
        container.append(html);
    });
}

$('<style>@keyframes fadeUp { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }</style>').appendTo('head');

function addToCart(itemName) {
    let existingItem = cart.find(x => x.name === itemName);
    
    if(existingItem) {
        existingItem.count++;
    } else {
        let itemData = allItems.find(x => x.name === itemName);
        if(itemData) {
            cart.push({
                name: itemName,
                label: itemData.label,
                price: itemData.price,
                count: 1
            });
        }
    }
    
    updateCartBadge();
    
    let btn = $(event.currentTarget);
    let originalHtml = btn.html();
    
    btn.css('background', '#fff').css('color', '#000').html('<i class="fas fa-check"></i>');
    setTimeout(() => {
        btn.attr('style', '').html(originalHtml);
    }, 500);
}

function toggleCart() {
    let panel = $('#cart-panel');
    if(panel.hasClass('open')) {
        panel.removeClass('open');
    } else {
        renderCartItems();
        panel.addClass('open');
    }
}

function updateCartBadge() {
    let count = 0;
    let totalPrice = 0;
    
    cart.forEach(i => {
        count += i.count;
        totalPrice += (i.price * i.count);
    });
    
    $('#cart-count').text(count);
    $('#header-total').text(currentCurrency + totalPrice);
    
    if(count > 0) {
        $('.cart-icon-wrapper').addClass('bounce');
        setTimeout(() => $('.cart-icon-wrapper').removeClass('bounce'), 300);
    }
}
$('<style>@keyframes bounce { 0% { transform: scale(1); } 50% { transform: scale(1.2); } 100% { transform: scale(1); } }</style>').appendTo('head');


function renderCartItems() {
    let list = $('#cart-list');
    list.html('');
    
    let total = 0;

    if(cart.length === 0) {
        list.html('<div style="color:#64748b; text-align:center; margin-top:50px; font-size:13px;">Your cart is empty.</div>');
        $('#cart-total').text(currentCurrency + "0");
        return;
    }

    cart.forEach((item, index) => {
        total += item.price * item.count;
        
        let html = `
            <div class="cart-item-row">
                <div class="c-info">
                    <span class="c-name">${item.label}</span>
                    <span class="c-price">${currentCurrency}${item.price} / pc</span>
                </div>
                
                <div class="c-actions">
                    <button class="btn-qty" onclick="changeQty(${index}, -1)">-</button>
                    <span style="color:#fff; font-weight:600; padding:0 6px; min-width:20px; text-align:center;">${item.count}</span>
                    <button class="btn-qty" onclick="changeQty(${index}, 1)">+</button>
                </div>

                <div style="cursor:pointer; color:#ef4444; margin-left:10px; padding:5px;" onclick="removeFromCart(${index})">
                    <i class="fas fa-trash"></i>
                </div>
            </div>
        `;
        list.append(html);
    });

    $('#cart-total').text(currentCurrency + total);
    $('#header-total').text(currentCurrency + total);
}

function changeQty(index, delta) {
    if(cart[index]) {
        cart[index].count += delta;
        if(cart[index].count <= 0) {
            cart.splice(index, 1);
        }
        updateCartBadge();
        renderCartItems();
    }
}

function removeFromCart(index) {
    cart.splice(index, 1);
    updateCartBadge();
    renderCartItems();
}

function checkout() {
    if(cart.length === 0) return;
    
    $.post('https://vCore_Shops/checkout', JSON.stringify({
        cart: cart
    }));
    
    closeShop();
    cart = [];
    $('#cart-panel').removeClass('open');
    updateCartBadge();
}