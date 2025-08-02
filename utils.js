const sgLog = (msg) => console.log(`[Steamgifts Companion] ${msg}`);

const checkWhitelist = (store) => {
    store.get('whitelist').then((res) => {
        if (Object.keys(res).length === 0) {
            sgLog("Local storage is empty, setting up default values.");
            store.set({ whitelist: [] });
        }
    });
};
