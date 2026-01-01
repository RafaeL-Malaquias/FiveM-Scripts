local godmode = false
local noclip = false
local showNames = false
local showBlips = false

print("[ADMIN] Modulo admin.lua carregado.")

function Admin_ToggleGodmode()
    godmode = not godmode
    SetEntityInvincible(PlayerPedId(), godmode)
    ESX.ShowNotification("Godmode: " .. tostring(godmode))
end

function Admin_ToggleNoclip()
    noclip = not noclip
    local ped = PlayerPedId()
    SetEntityVisible(ped, not noclip, 0)
    SetEntityCollision(ped, not noclip, not noclip)
    ESX.ShowNotification("Noclip: " .. tostring(noclip))
end

function Admin_ReviveSelf()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
    ESX.ShowNotification("Você foi revivido!")
    TriggerEvent('esx_ambulancejob:revive')
end

function Admin_TeleportToWaypoint()
    local ped = PlayerPedId()
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
end

function Admin_ToggleBlips()
    showBlips = not showBlips
    TriggerServerEvent('admin:toggleBlips', showBlips)
end

function Admin_ToggleNames()
    showNames = not showNames
    ESX.ShowNotification("Nomes: " .. tostring(showNames))
end

function Admin_Announce()
    -- Fecha o NUI antes de abrir o teclado para evitar conflito de foco
    SendNUIMessage({
        type = "ui",
        status = false
    })
    SetNuiFocus(false, false)
    
    -- Pequeno delay para garantir que o foco voltou ao jogo
    Wait(100)

    local msg = KeyboardInput("ANUNCIO", "Digite a mensagem do anuncio:", 100)
    if msg then
        TriggerServerEvent('admin:announce', msg)
    end
end

function Admin_GiveWeapon(data)
    local weaponName = data.weapon
    local ammo = data.ammo or 100
    TriggerServerEvent('admin:giveWeapon', weaponName, ammo)
end

function Admin_RemoveAllWeapons()
    TriggerServerEvent('admin:removeWeapons')
end

-- === FUNÇÕES AUXILIARES DE DESENHO ===
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

-- === EVENTOS DE CLIMA E TEMPO (FALLBACK) ===
RegisterNetEvent('admin:setClientWeather')
AddEventHandler('admin:setClientWeather', function(weatherType)
    SetWeatherTypeOverTime(weatherType, 15.0)
    Wait(15000)
    SetWeatherTypeNow(weatherType)
    SetWeatherTypePersist(weatherType)
    SetWeatherTypeNowPersist(weatherType)
    SetOverrideWeather(weatherType)
end)

RegisterNetEvent('admin:setClientTime')
AddEventHandler('admin:setClientTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end)

-- Loop para Nomes e IDs
CreateThread(function()
    while true do
        local sleep = 1000
        if showNames then
            sleep = 0
            local myCoords = GetEntityCoords(PlayerPedId())
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                local targetCoords = GetEntityCoords(ped)
                local distance = #(myCoords - targetCoords)

                if distance < 50.0 then
                    local playerIdx = GetPlayerServerId(player)
                    local playerName = GetPlayerName(player)
                    DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.2, string.format("[%d] %s", playerIdx, playerName))
                end
            end
        end
        Wait(sleep)
    end
end)
