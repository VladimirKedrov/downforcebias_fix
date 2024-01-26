local debug = Config.server_debug
--
RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(currentVehicle, currentSeat, displayName, netId)
    local playerId = source
    TriggerClientEvent('downforcefix:enabled', playerId, 1)
    if debug then
    print('downforcefix_server_enabled')
    end
end)
--
RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(currentVehicle, currentSeat, displayName, netId)
    local playerId = source
    TriggerClientEvent('downforcefix:disabled', playerId, 1)
    if debug then
    print('downforcefix_server_disabled')
    end
end)