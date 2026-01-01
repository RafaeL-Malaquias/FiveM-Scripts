function Vehicle_MaxMods()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        ESX.Game.SetVehicleProperties(veh, {
            modEngine = 3, modBrakes = 2, modTransmission = 2, modSuspension = 3, modTurbo = true, windowTint = 1
        })
        ESX.ShowNotification("Veículo Tunado!")
    else
        ESX.ShowNotification("Você não está em um veículo!")
    end
end

function Vehicle_SaveCar()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        local props = ESX.Game.GetVehicleProperties(veh)
        print("[ADMIN] Tentando salvar veiculo. Placa: " .. tostring(props.plate))
        TriggerServerEvent('admin:saveCar', props)
    else
        ESX.ShowNotification("Você não está em um veículo!")
    end
end

function Vehicle_Repair()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        SetVehicleFixed(veh)
        SetVehicleDirtLevel(veh, 0.0)
        ESX.ShowNotification("Veículo Reparado!")
    else
        ESX.ShowNotification("Você não está em um veículo!")
    end
end

function Vehicle_Spawn(model)
    CreateThread(function()
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)

        -- Se estiver em um veículo, deleta o anterior antes de spawnar o novo
        local currentVehicle = GetVehiclePedIsIn(ped, false)
        if currentVehicle ~= 0 then
            ESX.Game.DeleteVehicle(currentVehicle)
            Wait(2000) -- Delay de 2 segundos para evitar bugs
        end

        ESX.Game.SpawnVehicle(model, coords, heading, function(vehicle)
            TaskWarpPedIntoVehicle(ped, vehicle, -1)
            ESX.ShowNotification("Veículo spawnado: " .. model)
        end)
    end)
end

RegisterCommand('admincar', function()
    Vehicle_SaveCar()
end)

function Vehicle_ApplyColor(data)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        local colorId = tonumber(data.colorId)
        local part = data.part
        
        local primary, secondary = GetVehicleColours(veh)
        
        if part == 'primary' then
            SetVehicleColours(veh, colorId, secondary)
            ESX.ShowNotification("Cor Primária alterada para ID: " .. colorId)
        elseif part == 'secondary' then
            SetVehicleColours(veh, primary, colorId)
            ESX.ShowNotification("Cor Secundária alterada para ID: " .. colorId)
        end
    else
        ESX.ShowNotification("Você não está em um veículo!")
    end
end

local showVehicleStatus = false

function Vehicle_ShowStatus()
    showVehicleStatus = not showVehicleStatus
    if showVehicleStatus then
        ESX.ShowNotification("Vehicle Dev Mode: ~g~ATIVADO")
    else
        ESX.ShowNotification("Vehicle Dev Mode: ~r~DESATIVADO")
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        if showVehicleStatus then
            sleep = 0
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            
            if veh ~= 0 then
                local entityId = veh
                local engineHealth = GetVehicleEngineHealth(veh)
                local bodyHealth = GetVehicleBodyHealth(veh)
                local fuelLevel = GetVehicleFuelLevel(veh)
                local plate = GetVehicleNumberPlateText(veh)
                local rpm = GetVehicleCurrentRpm(veh)
                local speed = GetEntitySpeed(veh) * 3.6 -- km/h
                local coords = GetEntityCoords(veh)
                local heading = GetEntityHeading(veh)
                
                local text = string.format(
                    "~b~VEHICLE DEV MODE~s~\nID: ~y~%s~s~\nPlaca: ~b~%s~s~\nMotor: ~g~%.1f~s~\nLataria: ~g~%.1f~s~\nGasolina: ~o~%.1f~s~\nRPM: %.2f\nSpeed: %.0f km/h\nHeading: %.2f\nCoords: %.2f, %.2f, %.2f",
                    entityId, plate, engineHealth, bodyHealth, fuelLevel, rpm, speed, heading, coords.x, coords.y, coords.z
                )
                
                SetTextFont(4)
                SetTextProportional(1)
                SetTextScale(0.45, 0.45)
                SetTextColour(255, 255, 255, 255)
                SetTextDropShadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(text)
                DrawText(0.5, 0.5)
            end
        end
        Wait(sleep)
    end
end)
