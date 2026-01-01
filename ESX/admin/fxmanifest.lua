fx_version 'cerulean'
game 'gta5'

author 'FaeL Dev'
description 'Painel Admin Estilo QB para ESX'
version '1.0.0'

-- Define os scripts que agora estão na raiz
client_scripts {
    'client/main.lua',
    'client/admin.lua',
    'client/vehicle.lua',
    'client/dev.lua',
    'client/players.lua'
}
server_script 'server.lua'

-- Define a interface que está na pasta nui
ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/style.css',
    'nui/vehicles.js',
    'nui/script.js'
}

-- Importante para o ESX reconhecer o script
dependencies {
    'es_extended',
    'oxmysql'
}