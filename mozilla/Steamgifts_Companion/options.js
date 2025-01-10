const sync_store = browser.storage.sync;

sync_store.get('whitelist').then((res) => {
    if (Array.isArray(res.whitelist)) {
        document.querySelector("#test").innerHTML = res.whitelist;
    }
});
