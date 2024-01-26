-- Copyright (C) 2024 VladimirKedrov
-- This file is part of downforcebias_fix.
--
-- downforcebias_fix is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- downforcebias_fix is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along with downforcebias_fix.
-- If not, see <https://www.gnu.org/licenses/>.

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