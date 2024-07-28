document.addEventListener("turbolinks:load", function() {
    document.getElementById('shop-dropdown').addEventListener('change', function() {
        var shopId = this.value;
        var url = new URL(window.location.href);

        if (shopId) {
            url.searchParams.set('shop_id', shopId);
        } else {
            url.searchParams.delete('shop_id');
        }

        window.location.href = url.toString();
    });
});
