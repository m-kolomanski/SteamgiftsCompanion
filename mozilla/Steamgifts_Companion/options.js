const store = browser.storage.local;
checkWhitelist(store);

store.get('whitelist').then((res) => {
    createGameList(res.whitelist);
});

const createGameList = (whitelist) => {
    const list_container = document.getElementById("whitelisted-packages");
    list_container.innerHTML = "";
    const list_element = document.createElement("ul");

    whitelist
        .sort()
        .forEach((game) => {
            const li = document.createElement("li");
            li.textContent = game;
            li.onclick = () => removeGame(game);
            list_element.appendChild(li);
        });

    list_container.appendChild(list_element);
}

const removeGame = (game) => {
    sgLog(`Removing game: ${game}`);

    store.get('whitelist').then((res) => {
        const updated_whitelist = res.whitelist.filter((item) => item !== game);
        store.set({ whitelist: updated_whitelist });
        createGameList(updated_whitelist);
    });
};