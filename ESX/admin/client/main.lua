local menuAberto = false
ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
    print("[ADMIN] ESX Carregado com sucesso!")
end)

print("[ADMIN] Script main.lua iniciado.")

function abrirPainel()
    if ESX == nil then 
        print("[ADMIN] Erro: ESX nao carregado ainda.")
        return 
    end
    
    menuAberto = not menuAberto
    print("[ADMIN] Abrindo painel: " .. tostring(menuAberto))
    SetNuiFocus(menuAberto, menuAberto)
    SendNUIMessage({
        type = "ui",
        status = menuAberto
    })
end

RegisterCommand('admin', function()
    abrirPainel()
end)

RegisterKeyMapping('admin', 'Abrir Painel Admin', 'keyboard', 'INSERT')

RegisterNUICallback('close', function(data, cb)
    menuAberto = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Função Auxiliar para pegar Texto do usuário
function KeyboardInput(entryTitle, textEntry, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", "", "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return nil
    end
end

-- Callback Principal que distribui as ações
RegisterNUICallback('execAction', function(data, cb)
    local action = data.action
    
    -- Admin Geral
    if action == 'godmode' then Admin_ToggleGodmode()
    elseif action == 'noclip' then Admin_ToggleNoclip()
    elseif action == 'revive' then Admin_ReviveSelf()
    elseif action == 'tpm' then Admin_TeleportToWaypoint()
    elseif action == 'blips' then Admin_ToggleBlips()
    elseif action == 'names' then Admin_ToggleNames()
    elseif action == 'announce' then Admin_Announce()
    elseif action == 'kickall' then TriggerServerEvent('admin:kickAll')
    
    -- Armas
    elseif action == 'give_weapon' then Admin_GiveWeapon(data.data)
    elseif action == 'remove_all_weapons' then Admin_RemoveAllWeapons()
    
    -- Jogadores
    elseif action == 'get_players' then
        TriggerServerEvent('admin:getPlayers')
    elseif action == 'player_action' then
        Player_ExecuteAction(data.data)

    -- Veículos
    elseif action == 'max_mods' then Vehicle_MaxMods()
    elseif action == 'admin_car' then ExecuteCommand("admincar")
    elseif action == 'repair_veh' then Vehicle_Repair()
    elseif action == 'set_vehicle_color' then Vehicle_ApplyColor(data.data)
    elseif action == 'spawn_car' then Vehicle_Spawn(data.data.model)
    
    -- Server Management
    elseif action == 'set_weather' then TriggerServerEvent('admin:setWeather', data.data.weather)
    elseif action == 'set_time' then TriggerServerEvent('admin:setTime', data.data.hour)

    -- Dev Tools
    elseif action == 'copy_vector3' then Dev_CopyVector3()
    elseif action == 'copy_vector4' then Dev_CopyVector4()
    elseif action == 'copy_heading' then Dev_CopyHeading()
    elseif action == 'vehicle_dev' then Vehicle_ShowStatus()
    elseif action == 'give_nui_focus' then SetNuiFocus(false, false)
    end

    cb('ok')
end)
