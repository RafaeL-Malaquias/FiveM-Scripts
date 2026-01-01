local ESX = exports["es_extended"]:getSharedObject()
local MySQL = exports.oxmysql -- Força a importação do MySQL

-- O servidor apenas ESCUTA os pedidos vindos do client
RegisterNetEvent('painel_admin:executar')
AddEventHandler('painel_admin:executar', function(action, data)
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Verifica se o jogador é admin antes de fazer qualquer coisa
    if xPlayer.getGroup() ~= 'user' then
        if action == 'revive_all' then
            TriggerClientEvent('esx_ambulancejob:revive', -1)
            xPlayer.showNotification("Você reviveu todos os jogadores!")
        elseif action == 'tp_marker' then
            -- Aqui você chamaria o evento de teleporte
            print("Admin solicitou teleporte para o marcador")
        end
    else
        print("AVISO: Jogador " .. xPlayer.name .. " tentou burlar o menu admin!")
    end
end)




local ESX = exports["es_extended"]:getSharedObject()

-- Anuncio
RegisterNetEvent('admin:announce')
AddEventHandler('admin:announce', function(msg)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(200, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-bullhorn"></i> ANÚNCIO: {0}</div>',
            args = { msg }
        })
    else
        print(('O jogador %s tentou fazer um anuncio sem permissao'):format(xPlayer.getName()))
    end
end)

-- Kick All
RegisterNetEvent('admin:kickAll')
AddEventHandler('admin:kickAll', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'god' then
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            if tonumber(playerId) ~= source then
                DropPlayer(playerId, "Servidor reiniciando ou manutenção (KickAll).")
            end
        end
    else
        xPlayer.showNotification("Sem permissão para KickAll.")
    end
end)

-- Admin Car (Salvar veículo)
RegisterNetEvent('admin:saveCar')
AddEventHandler('admin:saveCar', function(vehicleProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    print("[ADMIN] Recebido pedido de salvar carro. Placa: " .. tostring(vehicleProps.plate))
    if xPlayer.getGroup() ~= 'user' then
        -- Verifica se o veículo já existe
        exports.oxmysql:scalar('SELECT plate FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = vehicleProps.plate
        }, function(existingPlate)
            if existingPlate then
                xPlayer.showNotification("Este veículo já pertence a alguém!")
            else
                -- Salva na garagem (stored=1, parking=VespucciBoulevard)
                exports.oxmysql:insert('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, parking) VALUES (@owner, @plate, @vehicle, @stored, @parking)', {
                    ['@owner']   = xPlayer.identifier,
                    ['@plate']   = vehicleProps.plate,
                    ['@vehicle'] = json.encode(vehicleProps),
                    ['@stored']  = 1,
                    ['@parking'] = "VespucciBoulevard"
                }, function(id)
                    xPlayer.showNotification("Veículo salvo na garagem Central!")
                end)
            end
        end)
    end
end)

-- Dar Arma
RegisterNetEvent('admin:giveWeapon')
AddEventHandler('admin:giveWeapon', function(weaponName, ammo)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        xPlayer.addWeapon(weaponName, ammo)
        xPlayer.showNotification("Você recebeu: " .. weaponName)
    else
        print(('O jogador %s tentou pegar arma sem permissao'):format(xPlayer.getName()))
    end
end)

-- Remover Armas
RegisterNetEvent('admin:removeWeapons')
AddEventHandler('admin:removeWeapons', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        for i=#xPlayer.loadout, 1, -1 do
            xPlayer.removeWeapon(xPlayer.loadout[i].name)
        end
        xPlayer.showNotification("Todas as armas removidas.")
    end
end)

-- Obter Lista de Jogadores
RegisterNetEvent('admin:getPlayers')
AddEventHandler('admin:getPlayers', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        local players = GetPlayers()
        local data = {}
        
        for _, playerId in ipairs(players) do
            local xTarget = ESX.GetPlayerFromId(playerId)
            if xTarget then
                table.insert(data, {
                    id = playerId,
                    name = xTarget.getName(),
                    job = xTarget.job.label
                })
            end
        end
        
        TriggerClientEvent('admin:receivePlayers', source, data)
    end
end)

-- === AÇÕES DE JOGADOR ===

-- Goto
RegisterNetEvent('admin:goto')
AddEventHandler('admin:goto', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        local xTarget = ESX.GetPlayerFromId(targetId)
        if xTarget then
            local coords = xTarget.getCoords(true)
            xPlayer.setCoords(coords)
            xPlayer.showNotification("Teleportado para " .. xTarget.getName())
        else
            xPlayer.showNotification("Jogador offline.")
        end
    end
end)

-- Bring
RegisterNetEvent('admin:bring')
AddEventHandler('admin:bring', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        local xTarget = ESX.GetPlayerFromId(targetId)
        if xTarget then
            local coords = xPlayer.getCoords(true)
            xTarget.setCoords(coords)
            xPlayer.showNotification("Você trouxe " .. xTarget.getName())
            xTarget.showNotification("Você foi puxado por um admin.")
        else
            xPlayer.showNotification("Jogador offline.")
        end
    end
end)

-- Revive Player
RegisterNetEvent('admin:revivePlayer')
AddEventHandler('admin:revivePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        TriggerClientEvent('esx_ambulancejob:revive', targetId)
        xPlayer.showNotification("Jogador revivido.")
    end
end)

-- Slay (Matar)
RegisterNetEvent('admin:slayPlayer')
AddEventHandler('admin:slayPlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        TriggerClientEvent('esx:killPlayer', targetId)
        xPlayer.showNotification("Jogador morto.")
    end
end)

-- Kick Player
RegisterNetEvent('admin:kickPlayer')
AddEventHandler('admin:kickPlayer', function(targetId, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        DropPlayer(targetId, "Kicked by Admin: " .. reason)
    end
end)

-- Freeze
RegisterNetEvent('admin:freeze')
AddEventHandler('admin:freeze', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        -- Precisamos saber se está congelado ou não. Vamos assumir toggle simples.
        -- O ideal seria guardar estado, mas vamos enviar true/false baseado em uma variavel local no client do alvo?
        -- Simplificação: Vamos enviar um evento para o alvo fazer o toggle dele mesmo.
        TriggerClientEvent('admin:freezePlayer', targetId, true) -- Por enquanto congela sempre. Para toggle precisa de logica extra.
        xPlayer.showNotification("Comando Freeze enviado.")
    end
end)

-- Spectate
RegisterNetEvent('admin:spectate')
AddEventHandler('admin:spectate', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        local xTarget = ESX.GetPlayerFromId(targetId)
        if xTarget then
            local coords = xTarget.getCoords(true)
            TriggerClientEvent('admin:spectatePlayer', source, coords)
        end
    end
end)

-- Sit in Vehicle
RegisterNetEvent('admin:sitVehicle')
AddEventHandler('admin:sitVehicle', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        local targetPed = GetPlayerPed(targetId)
        local vehicle = GetVehiclePedIsIn(targetPed, false)
        if vehicle > 0 then
            local myPed = GetPlayerPed(source)
            for i=0, 2 do
                if IsVehicleSeatFree(vehicle, i) then
                    TaskWarpPedIntoVehicle(myPed, vehicle, i)
                    break
                end
            end
        else
            xPlayer.showNotification("Jogador não está em um veículo.")
        end
    end
end)

-- Give Skin
RegisterNetEvent('admin:giveSkin')
AddEventHandler('admin:giveSkin', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        TriggerClientEvent('esx_skin:openSaveableMenu', targetId)
        xPlayer.showNotification("Menu Skin enviado.")
    end
end)

-- Ban (Simples Drop por enquanto)
RegisterNetEvent('admin:ban')
AddEventHandler('admin:ban', function(targetId, reason, duration)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        -- AQUI ENTRARIA O SQL INSERT PARA BANIR REALMENTE
        -- Exemplo: MySQL.Async.execute('INSERT INTO bans ...')
        
        print("BAN: " .. targetId .. " Motivo: " .. reason .. " Tempo: " .. duration)
        DropPlayer(targetId, "BANNED: " .. reason .. " (Duration: " .. duration .. "h)")
    end
end)

-- Weather
RegisterNetEvent('admin:setWeather')
AddEventHandler('admin:setWeather', function(weatherType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        -- Tenta usar comandos de scripts comuns de clima (vSync, cd_easytime, etc)
        ExecuteCommand("weather " .. weatherType)
        ExecuteCommand("setweather " .. weatherType)
        
        -- Fallback: Envia para todos os clientes (se não houver script de sync)
        TriggerClientEvent('admin:setClientWeather', -1, weatherType)
        
        xPlayer.showNotification("Clima alterado para: " .. weatherType)
    else
        xPlayer.showNotification("Sem permissão.")
    end
end)

-- Time
RegisterNetEvent('admin:setTime')
AddEventHandler('admin:setTime', function(hour)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        -- Tenta usar comandos de scripts comuns de tempo
        ExecuteCommand("time " .. hour .. " 00")
        ExecuteCommand("settime " .. hour .. " 00")
        
        -- Fallback: Envia para todos os clientes
        TriggerClientEvent('admin:setClientTime', -1, tonumber(hour), 0)
        
        xPlayer.showNotification("Tempo alterado para: " .. hour .. ":00")
    else
        xPlayer.showNotification("Sem permissão.")
    end
end)