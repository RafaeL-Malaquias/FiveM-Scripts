-- Funtions to handle player list and actions


RegisterNetEvent('admin:receivePlayers')
AddEventHandler('admin:receivePlayers', function(players)
    SendNUIMessage({
        type = 'updatePlayerList',
        players = players
    })
end)

function Player_ExecuteAction(data)
    local targetId = data.targetId
    local type = data.type

    if type == 'goto' then
        TriggerServerEvent('admin:goto', targetId)
    elseif type == 'bring' then
        TriggerServerEvent('admin:bring', targetId)
    elseif type == 'revive' then
        TriggerServerEvent('admin:revivePlayer', targetId)
    elseif type == 'slay' then
        TriggerServerEvent('admin:slayPlayer', targetId)
    elseif type == 'kick' then
        -- Fecha o NUI antes de abrir o teclado para evitar conflito de foco (Igual ao Anuncio)
        SendNUIMessage({
            type = "ui",
            status = false
        })
        SetNuiFocus(false, false)
        Wait(100)

        local reason = KeyboardInput("KICK", "Motivo do Kick:", 100)
        if reason then
            TriggerServerEvent('admin:kickPlayer', targetId, reason)
        end

    -- NOVAS FUNÇÕES
    elseif type == 'freeze' then
        TriggerServerEvent('admin:freeze', targetId)
    
    elseif type == 'spectate' then
        TriggerServerEvent('admin:spectate', targetId)

    elseif type == 'sit_vehicle' then
        TriggerServerEvent('admin:sitVehicle', targetId)

    elseif type == 'give_skin' then
        TriggerServerEvent('admin:giveSkin', targetId)

    elseif type == 'open_inventory' then
        ESX.ShowNotification("Em breve...")

    elseif type == 'ban' then
        SendNUIMessage({ type = "ui", status = false })
        SetNuiFocus(false, false)
        Wait(100)

        local reason = KeyboardInput("BAN", "Motivo do Ban:", 100)
        if reason then
            Wait(500)
            local duration = KeyboardInput("BAN", "Duracao (Horas) ou 0 para Perm:", 20)
            if duration then
                TriggerServerEvent('admin:ban', targetId, reason, duration)
            end
        end
    end
end

-- Evento para congelar o jogador local (alvo)
RegisterNetEvent('admin:freezePlayer')
AddEventHandler('admin:freezePlayer', function(freeze)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, freeze)
    if freeze then
        ESX.ShowNotification("Você foi congelado por um admin.")
    else
        ESX.ShowNotification("Você foi descongelado.")
    end
end)

-- Evento simples de Spectate (Teleporta invisivel para perto)
local savedCoords = nil
local isSpectating = false

RegisterNetEvent('admin:spectatePlayer')
AddEventHandler('admin:spectatePlayer', function(targetCoords)
    local ped = PlayerPedId()
    
    if not isSpectating then
        savedCoords = GetEntityCoords(ped) -- Salva onde estava
        isSpectating = true
    end

    SetEntityCoords(ped, targetCoords.x, targetCoords.y, targetCoords.z)
    SetEntityVisible(ped, false, 0)
    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, true)
    
    ESX.ShowNotification("Modo Spectate ATIVO. Pressione [ESC] para sair.")

    CreateThread(function()
        while isSpectating do
            Wait(0)
            
            -- Bloqueia Pause Menu no ESC e Backspace
            DisableControlAction(0, 200, true) 
            DisableControlAction(0, 177, true)

            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 177) then
                isSpectating = false
                
                SetEntityCoords(ped, savedCoords.x, savedCoords.y, savedCoords.z)
                SetEntityVisible(ped, true, 0)
                SetEntityCollision(ped, true, true)
                FreezeEntityPosition(ped, false)
                
                ESX.ShowNotification("Spectate finalizado. Retornando...")
            end
        end
    end)
end)
