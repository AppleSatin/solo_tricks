local isTricking = false
local vehicle = nil
local soloTrickCooldown = false
local lastTickTime = 0

RegisterCommand(Config.trickCommand, function(source, args, raw)
    startTrick()
end)

startTrick = function()
    local currentTime = GetGameTimer()
    if vehicle == nil then
        vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    end
    if Config.suitableVehicle[GetEntityModel(vehicle)] then
        if not isTricking then
            if not soloTrickCooldown or (currentTime - lastTickTime) >= Config.trickcooldowntimerMS then
                FreezeEntityPosition(vehicle, true)
                Wait(100)
                local boneIndex = GetEntityBoneIndexByName(vehicle, "bonnet")
                local boneCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)
                SetEntityCoords(PlayerPedId(), boneCoords.x - 0.5, boneCoords.y + 0.5, boneCoords.z + 0.7, true, true, true)
                isTricking = true
            else
                print('Cool Down Active')
            end
        else
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            FreezeEntityPosition(vehicle, false)
            vehicle = nil
            isTricking = false
        end

        lastTickTime = currentTime

        soloTrickCooldown = true

        CreateThread(function()
            Wait(Config.trickcooldowntimerMS)
            soloTrickCooldown = false
        end)
    end
end

RegisterKeyMapping(Config.trickCommand, 'Solo Trick', 'keyboard', Config.trickKeybind)
