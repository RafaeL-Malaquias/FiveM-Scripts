function Dev_CopyVector3()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local text = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)
    SendNUIMessage({type = 'copy', text = text})
    ESX.ShowNotification("Vector3 copiado!")
end

function Dev_CopyVector4()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local h = GetEntityHeading(ped)
    local text = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, h)
    SendNUIMessage({type = 'copy', text = text})
    ESX.ShowNotification("Vector4 copiado!")
end

function Dev_CopyHeading()
    local ped = PlayerPedId()
    local h = GetEntityHeading(ped)
    local text = string.format("%.2f", h)
    SendNUIMessage({type = 'copy', text = text})
    ESX.ShowNotification("Heading copiado!")
end
