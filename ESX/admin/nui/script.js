// Variável para salvar o HTML do menu principal
var mainMenuHTML = "";

var selectedIndex = 0;

// 1. Assim que o painel carrega, salvamos o menu principal para o botão "Voltar" funcionar
window.addEventListener('load', function() {
    const menuElement = document.getElementById("main-menu");
    if (menuElement) {
        mainMenuHTML = menuElement.innerHTML;
        updateSelection();
    } else {
        console.error("ERRO: Elemento 'main-menu' não encontrado no HTML.");
    }
});

// 2. Ouve as mensagens vindas do Lua (Client)
window.addEventListener('message', function(event) {
    const item = event.data;

    // Abrir ou fechar o menu
    if (item.type === "ui") {
        const container = document.getElementById("container");
        if (item.status) {
            container.style.display = "flex";
            resetMenu(); // Sempre volta para o menu inicial ao abrir
        } else {
            container.style.display = "none";
        }
    }

    // Copiar coordenadas (Dev Tools)
    if (item.type === 'copy') {
        const el = document.createElement('textarea');
        el.value = item.text;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
    }

    // Atualizar Lista de Jogadores
    if (item.type === 'updatePlayerList') {
        renderPlayerList(item.players);
    }
});

// 3. Função para enviar ações de volta para o Lua
function action(name, data = {}) {
    // GetParentResourceName() pega o nome da pasta automaticamente
    fetch(`https://${GetParentResourceName()}/execAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: name, data: data })
    });
}

// 4. Função que desenha os Submenus (Listas)
function openSubMenu(category, extraData) {
    const menuList = document.getElementById("main-menu");
    let htmlContent = "";

    // --- Categoria: ADMIN GERAL ---
    if (category === 'admin') {
        htmlContent = `
            <button class="menu-button" onclick="action('godmode')">👑| Godmode</button>
            <button class="menu-button" onclick="action('revive')">🩹| Revive</button>
            <button class="menu-button" onclick="action('tpm')">🚀| TP Waypoint</button>
            <button class="menu-button" onclick="action('names')">🗒️| Nomes / IDs (Head)</button>
            <button class="menu-button" onclick="action('blips')">📍| Blips Jogadores (Map)</button>
            <button class="menu-button" onclick="action('announce')"> 📢| Fazer Anúncio</button>
            <button class="menu-button" onclick="openSubMenu('weapons')">🔫| Armas <i class="arrow">→</i></button>
        `;
    } 

    // --- Categoria: JOGADORES (Solicita lista) ---
    else if (category === 'player') {
        // Mostra carregando e pede ao Lua
        menuList.innerHTML = '<p style="padding:20px; text-align:center;">Carregando jogadores...</p>';
        action('get_players');
        return; // Para a execução aqui, o updatePlayerList vai desenhar depois
    }

    // --- Categoria: SERVER MANAGEMENT ---
    else if (category === 'server') {
        htmlContent = `
            <button class="menu-button" onclick="openSubMenu('weather_options')">🌦️| Weather Options <i class="arrow">→</i></button>
            <button class="menu-button" onclick="openSubMenu('time_options')">⏰| Server Time <i class="arrow">→</i></button>
        `
    }

    // --- Categoria: WEATHER OPTIONS ---
    else if (category === 'weather_options') {
        const weathers = [
            { label: "Extra Sunny", value: "EXTRASUNNY" },
            { label: "Clear", value: "CLEAR" },
            { label: "Neutral", value: "NEUTRAL" },
            { label: "Smog", value: "SMOG" },
            { label: "Foggy", value: "FOGGY" },
            { label: "Overcast", value: "OVERCAST" },
            { label: "Clouds", value: "CLOUDS" },
            { label: "Clearing", value: "CLEARING" },
            { label: "Rain", value: "RAIN" },
            { label: "Thunder", value: "THUNDER" },
            { label: "Snow", value: "SNOW" },
            { label: "Blizzard", value: "BLIZZARD" },
            { label: "Snowlight", value: "SNOWLIGHT" },
            { label: "Xmas", value: "XMAS" },
            { label: "Halloween", value: "HALLOWEEN" }
        ];

        weathers.forEach(w => {
            htmlContent += `
                <button class="menu-button" onclick="action('set_weather', { weather: '${w.value}' })">${w.label}</button>
            `;
        });

        htmlContent += `
            <button class="menu-button" onclick="openSubMenu('server')" style="margin-top: 10px; background: rgba(245, 58, 58, 1);">
                <i class="arrow">←</i> Voltar
            </button>
        `;
        
        menuList.innerHTML = htmlContent;
        selectedIndex = 0;
        updateSelection();
        return;
    }

    // --- Categoria: TIME OPTIONS ---
    else if (category === 'time_options') {
        htmlContent = `
            <div style="display: flex;padding: 10px;/* text-align: center; */color: white;flex-direction: column;align-items: center;">
                <p>Definir Hora do Servidor (0-23)</p>
                <input type="range" id="timeSlider" min="0" max="23" value="12" style="width: 100%; margin: 10px 0;" oninput="document.getElementById('timeValue').innerText = this.value + ':00'">
                <p id="timeValue" style="font-weight: bold; font-size: 1.2em;">12:00</p>
                <button class="menu-button" onclick="action('set_time', { hour: document.getElementById('timeSlider').value })" style="margin-top: 15px;">Aplicar Hora</button>
            </div>
            <button class="menu-button" onclick="openSubMenu('server')" style="margin-top: 10px; background: rgba(245, 58, 58, 1);">
                <i class="arrow">←</i> Voltar
            </button>
        `;
        
        menuList.innerHTML = htmlContent;
        selectedIndex = 0;
        updateSelection();
        return;
    }

    // --- Categoria: ARMAS ---
    else if (category === 'weapons') {
        htmlContent = `
                
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_PISTOL', ammo: 100 })">Pistola</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_COMBATPISTOL', ammo: 100 })">Combat Pistol</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_ASSAULTRIFLE', ammo: 200 })">AK-47</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_CARBINERIFLE', ammo: 200 })">M4</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_PUMPSHOTGUN', ammo: 50 })">Shotgun</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_SNIPERRIFLE', ammo: 20 })">Sniper</button>

            <!-- Armas Brancas -->
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_KNIFE', ammo: 1 })">Faca</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_BAT', ammo: 1 })">Taco de Beisebol</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_SWITCHBLADE', ammo: 1 })">Canivete</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_MACHETE', ammo: 1 })">Machete</button>
            <button class="menu-button" onclick="action('give_weapon', { weapon: 'WEAPON_FLASHLIGHT', ammo: 1 })">Lanterna</button>

            <button class="menu-button" onclick="action('remove_all_weapons')" style="margin-top: 10px; background: rgba(255, 0, 0, 0.88);">Remover Todas Armas</button>
        `;
    }
    
    // --- Categoria: DEV TOOLS ---
    else if (category === 'dev') {
        htmlContent = `
            <button class="menu-button" onclick="action('copy_vector3')">📋| Vector3</button>
            <button class="menu-button" onclick="action('copy_vector4')">📋| Vector4</button>
            <button class="menu-button" onclick="action('copy_heading')">📋| Heading</button>
           <button class="menu-button" onclick="action('vehicle_dev')">🚘| Vehicle Dev</button>
        `;
    }

    // --- Categoria: VEÍCULOS ---
    else if (category === 'vehicle') {
        htmlContent = `
            <button class="menu-button" onclick="openSubMenu('spawn_vehicle_categories')">🚘| Spawn Vehicle <i class="arrow">→</i></button>
            <button class="menu-button" onclick="action('max_mods')">🏁|  Full Tunning</button>
            <button class="menu-button" onclick="action('admin_car')">💵| Save Garage</button>
            <button class="menu-button" onclick="action('repair_veh')">🧰| Fix</button>
            <button class="menu-button" onclick="openSubMenu('paint_part_selection')">🎨| Colors <i class="arrow">→</i></button>
        `;
    }

    // --- Categoria: SELEÇÃO DE PARTE (Pintura) ---
    else if (category === 'paint_part_selection') {
        htmlContent = `
            <button class="menu-button" onclick="openSubMenu('paint_categories', 'primary')">Cor Primária <i class="arrow">→</i></button>
            <button class="menu-button" onclick="openSubMenu('paint_categories', 'secondary')">Cor Secundária <i class="arrow">→</i></button>
            <button class="menu-button" onclick="openSubMenu('vehicle')" style="margin-top: 10px; background: rgba(255, 80, 80, 1);">
                <i class="arrow">←</i> Voltar
            </button>
        `;
        menuList.innerHTML = htmlContent;
        selectedIndex = 0;
        updateSelection();
        return;
    }

    // --- Categoria: CATEGORIAS DE PINTURA ---
    else if (category === 'paint_categories') {
        const part = extraData; // 'primary' or 'secondary'
        for (const catName in vehicleColors) {
            htmlContent += `
                <button class="menu-button" onclick="openSubMenu('paint_list', '${part}|${catName}')">${catName} <i class="arrow">→</i></button>
            `;
        }
        
        htmlContent += `
            <button class="menu-button" onclick="openSubMenu('paint_part_selection')" style="margin-top: 10px; background: rgba(245, 58, 58, 1);">
                <i class="arrow">←</i> Voltar
            </button>
        `;
        
        menuList.innerHTML = htmlContent;
        selectedIndex = 0;
        updateSelection();
        return;
    }

    // --- Categoria: LISTA DE CORES ---
    else if (category === 'paint_list') {
        const [part, catName] = extraData.split('|');
        const colors = vehicleColors[catName];

        if (colors) {
            colors.forEach(color => {
                htmlContent += `
                    <button class="menu-button" onclick="action('set_vehicle_color', { part: '${part}', colorId: ${color.id} })">${color.name}</button>
                `;
            });
        }
        
        htmlContent += `
            <button class="menu-button" onclick="openSubMenu('paint_categories', '${part}')" style="margin-top: 10px; background: rgba(245, 58, 58, 1);">
                <i class="arrow">←</i> Voltar
            </button>
        `;
        
        menuList.innerHTML = htmlContent;
        selectedIndex = 0;
        updateSelection();
        return;
    }

    // --- Categoria: SPAWN VEÍCULOS (Categorias) ---
    else if (category === 'spawn_vehicle_categories') {
        // Gera botões para cada categoria definida no objeto vehicleCategories
        for (const catName in vehicleCategories) {
            htmlContent += `
                <button class="menu-button" onclick="openSubMenu('spawn_vehicle_list', '${catName}')">${catName} <i class="arrow">→</i></button>
            `;
        }
    }

    // --- Categoria: LISTA DE VEÍCULOS (Por Categoria) ---
    // Note que aqui usamos um segundo argumento 'data' que passamos na chamada acima
    else if (category === 'spawn_vehicle_list') {
        // O segundo argumento da função openSubMenu é passado como extraData
        const catName = extraData; 
        const vehicles = vehicleCategories[catName];

        if (vehicles) {
            vehicles.forEach(model => {
                htmlContent += `
                    <button class="menu-button" onclick="action('spawn_car', { model: '${model}' })">${model.toUpperCase()}</button>
                `;
            });
        } else {
            htmlContent = '<p>Categoria não encontrada.</p>';
        }
        
        // Botão voltar específico para voltar para as categorias
        htmlContent += `
            <button class="menu-button" onclick="openSubMenu('spawn_vehicle_categories')" style="margin-top: 10px; background: rgba(245, 58, 58, 1);">
                <i class="arrow">←</i> Voltar
            </button>
        `;
        
        menuList.innerHTML = htmlContent;
        selectedIndex = 0;
        updateSelection();
        return; // Retorna para não adicionar o botão de voltar padrão duplicado
    }

    // --- Botão de Voltar (Comum a todos) ---
    // Importante: Note que o estilo inline ajuda a destacar o botão de voltar
    htmlContent += `
        <button class="menu-button" onclick="resetMenu()" style="margin-top: 10px; background: rgba(245, 58, 58, 1);">
            <i class="arrow">←</i> Voltar
        </button>
    `;

    // Aplica o novo HTML na lista
    menuList.innerHTML = htmlContent;
    selectedIndex = 0;
    updateSelection();
}

function renderPlayerList(players) {
    const menuList = document.getElementById("main-menu");
    let htmlContent = "";

    if (players.length === 0) {
        htmlContent = '<p style="padding:20px;">Nenhum jogador encontrado.</p>';
    } else {
        players.forEach(p => {
            // Escapar aspas no nome para evitar erros de JS
            const safeName = p.name.replace(/'/g, "\\'");
            htmlContent += `
                <button class="menu-button" onclick="openPlayerOptions(${p.id}, '${safeName}')">
                    <span>[${p.id}] ${p.name}</span>
                    <span style="font-size:0.8em; color:#aaa;">${p.job}</span>
                </button>
            `;
        });
    }

    htmlContent += `
        <button class="menu-button" onclick="resetMenu()" style="margin-top: 10px; background: rgba(255, 0, 0, 1);">
            <i class="arrow">←</i> Voltar
        </button>
    `;

    menuList.innerHTML = htmlContent;
    selectedIndex = 0;
    updateSelection();
}

function openPlayerOptions(id, name) {
    const menuList = document.getElementById("main-menu");
    
    let htmlContent = `
        <div style="padding:10px; text-align:center; border-bottom:1px solid #444; margin-bottom:10px;">
            <strong>${name} (ID: ${id})</strong>
        </div>

        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'slay'})">⚰️| Kill</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'revive'})">🩹| Revive</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'freeze'})">❄️| Freeze</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'spectate'})">👁️| Spectate (Olhar)</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'goto'})">➡️|Go to</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'bring'})">⬅️| Bring</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'sit_vehicle'})">🚗| Sit in Vehicle</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'give_skin'})">👕| Give Skin Menu</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'open_inventory'})" style="opacity:0.5;">Open Inventory (WIP)</button>
        
        <div style="border-top:1px solid #444; margin:5px 0;"></div>
        


        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'kick'})" style="color:#ff6b6b">👢| Kick</button>
        <button class="menu-button" onclick="action('player_action', {targetId: ${id}, type: 'ban'})" style="color:#ff0000; font-weight:bold;">🚫| Ban</button>
        
        <button class="menu-button" onclick="action('get_players')" style="margin-top: 10px; background: rgba(255, 0, 0, 1);">
            <i class="arrow">←</i> Voltar
        </button>
    `;

    menuList.innerHTML = htmlContent;
    selectedIndex = 0;
    updateSelection();
}

// 5. Função para restaurar o menu principal
function resetMenu() {
    const menuList = document.getElementById("main-menu");
    if (mainMenuHTML) {
        menuList.innerHTML = mainMenuHTML;
    }
    selectedIndex = 0;
    updateSelection();
}

// 6. Função para fechar o painel
function closeUI() {
    document.getElementById("container").style.display = "none";
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// Função para atualizar a seleção visual
function updateSelection() {
    const buttons = document.querySelectorAll('.menu-button');
    buttons.forEach((btn, index) => {
        if (index === selectedIndex) {
            btn.classList.add('selected');
            btn.scrollIntoView({ block: 'nearest' });
        } else {
            btn.classList.remove('selected');
        }
    });
}

// 7. Detecta teclas para navegação
document.addEventListener('keydown', function(event) {
    const buttons = document.querySelectorAll('.menu-button');
    
    if (event.key === "ArrowUp") {
        selectedIndex--;
        if (selectedIndex < 0) selectedIndex = buttons.length - 1;
        updateSelection();
    } else if (event.key === "ArrowDown") {
        selectedIndex++;
        if (selectedIndex >= buttons.length) selectedIndex = 0;
        updateSelection();
    } else if (event.key === "ArrowRight" || event.key === "Enter") {
        if (buttons[selectedIndex]) {
            buttons[selectedIndex].click();
        }
    } else if (event.key === "ArrowLeft" || event.key === "Backspace") {
        // Procura o botão de voltar (pelo texto ou função) e clica nele
        const backButton = Array.from(buttons).find(btn => 
            btn.innerText.includes("Voltar") || 
            btn.getAttribute('onclick') === "resetMenu()"
        );
        
        if (backButton) {
            backButton.click();
        } else {
            closeUI();
        }
    } else if (event.key === "Escape") {
        closeUI();
    }
});