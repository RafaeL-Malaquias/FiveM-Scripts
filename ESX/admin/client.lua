local menuAberto = false

function abrirPainel()
    menuAberto = not menuAberto
    
    -- Se estiver abrindo, libera o mouse. Se fechando, trava.
    SetNuiFocus(menuAberto, menuAberto)
    
    SendNUIMessage({
        type = "ui",
        status = menuAberto
    })
    
    print("Comando de abertura enviado. Status: " .. tostring(menuAberto))
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



local ESX = exports["es_extended"]:getSharedObject()
local godmode = false
local showNames = false
local showBlips = false

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

RegisterNUICallback('execAction', function(data, cb)
    local action = data.action
    local ped = PlayerPedId()

    -- === DEV TOOLS ===
    if action == 'copy_vector3' then
        local coords = GetEntityCoords(ped)
        local text = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
        SendNUIMessage({type = 'copy', text = text})
        ESX.ShowNotification("Vector3 copiado!")

    elseif action == 'copy_vector4' then
        local coords = GetEntityCoords(ped)
        local h = GetEntityHeading(ped)
        local text = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, h)
        SendNUIMessage({type = 'copy', text = text})
        ESX.ShowNotification("Vector4 copiado!")

    -- === ADMIN GERAL ===
    elseif action == 'godmode' then
        godmode = not godmode
        SetEntityInvincible(ped, godmode)
        ESX.ShowNotification("Godmode: " .. tostring(godmode))

    elseif action == 'revive' then
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
        SetPlayerInvincible(ped, false)
        ClearPedBloodDamage(ped)
        ESX.ShowNotification("Você foi revivido!")
        TriggerEvent('esx_ambulancejob:revive')

    elseif action == 'tpm' then
        local waypointBlip = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypointBlip) then
            local coords = GetBlipInfoIdCoord(waypointBlip)
            for height = 1, 1000 do
                SetEntityCoords(ped, coords.x, coords.y, height + 0.0)
                local foundGround, zPos = GetGroundZFor_3dCoord(coords.x, coords.y, height + 0.0)
                if foundGround then
                    SetEntityCoords(ped, coords.x, coords.y, zPos)
                    break
                end
                Wait(5)
            end
            ESX.ShowNotification("Teleportado para o Waypoint!")
        else
            ESX.ShowNotification("Nenhum Waypoint marcado.")
        end

    elseif action == 'blips' then
        showBlips = not showBlips
        TriggerServerEvent('admin:toggleBlips', showBlips) -- Servidor gerencia blips para todos ou sync

    elseif action == 'names' then
        showNames = not showNames
        ESX.ShowNotification("Nomes: " .. tostring(showNames))
        -- A thread de nomes deve verificar essa variavel 'showNames'

    -- === AÇÕES COM INPUT ===
    elseif action == 'announce' then
        local msg = KeyboardInput("ANUNCIO", "Digite a mensagem do anuncio:", 100)
        if msg then
            TriggerServerEvent('admin:announce', msg)
        end
    
    -- === VEÍCULOS ===
    elseif action == 'max_mods' then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh then
            ESX.Game.SetVehicleProperties(veh, {
                modEngine = 3, modBrakes = 2, modTransmission = 2, modSuspension = 3, modTurbo = true, windowTint = 1
            })
            ESX.ShowNotification("Veículo Tunado!")
        end
        
    elseif action == 'admin_car' then
        local veh = GetVehiclePedIsIn(ped, false)
        local props = ESX.Game.GetVehicleProperties(veh)
        TriggerServerEvent('admin:saveCar', props)

    -- === SERVIDOR ===
    elseif action == 'kickall' then
        TriggerServerEvent('admin:kickAll')
    end

    cb('ok')
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Loop para Nomes e IDs
CreateThread(function()
    while true do
        local sleep = 1000
        if showNames then
            sleep = 0
            local myCoords = GetEntityCoords(PlayerPedId())
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                -- Verifica distancia para otimizar e não poluir
                local targetCoords = GetEntityCoords(ped)
                local distance = #(myCoords - targetCoords)

                if distance < 50.0 then
                    local playerIdx = GetPlayerServerId(player)
                    local playerName = GetPlayerName(player)
                    
                    -- Desenha ID e Nome
                    DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.2, string.format("[%d] %s", playerIdx, playerName))
                end
            end
        end
        Wait(sleep)
    end
end)