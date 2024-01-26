local debug = Config.client_debug
local invehicle = 0
local handling_meta_sus_raise = 0
local enabled = 0
local origin_sus_coord_z
local vehicle = nil
--
-- bitwise operation function
local OR, XOR, AND = 1, 3, 4
local function bitoper(a, b, oper)
   local r, m, s = 0, 2^31
   repeat
	  s,a,b = a+b+m, a%m, b%m
	  r,m = r + m*oper%(s-a-b), m/2
   until m < 1
   return r
end
--
-- Rounding function
local function Round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end
--
-- Ui display function
local function
	drawTxt(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.30, 0.30)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end
--
-- UI Toggle command
RegisterCommand("downforcefix_debug", function()
	if debug == false then
		debug = true
		if enabled ~= 1 then
			print('in_vehicle_trigger_not_active, check if in vehicle and baseevents working')
		end
	else
		debug = false
	end
end)
--
-- Listens to event trigger then runs
RegisterNetEvent('downforcefix:enabled')
AddEventHandler('downforcefix:enabled', function()
	-- Static Section: runs once per event trigger
	invehicle = 1
	if invehicle == 1 then
		if debug then
		print('downforcefix entered vehicle')
		end
		-- Gets the entity that the play is in.
		vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		-- Checks the current advanced flags, Returns integer not hex.
		local adv_flag = GetVehicleHandlingInt(vehicle, 'CCarHandlingData', 'strAdvancedFlags')
		-- Checks if current advanced flag integer contains downforcebias flag integer.
		local flag_check = bitoper(adv_flag, 134217728, AND)
		-- Determines if check was successful
		if flag_check == 134217728 then
			-- Stores the handling.meta suspension raise
			handling_meta_sus_raise = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionRaise')
			-- Stores the original suspension coordinates
			local origin_sus_coord = GetVehicleSuspensionBounds(vehicle)
			-- Separated original suspension vertical vector
			origin_sus_coord_z = origin_sus_coord.z
			-- Enables the loop function
			enabled = 1
			if debug then
			print('UseDownforceBias advanced flag enabled')
			end
		else
			enabled = 0
			if debug then
			print('UseDownforceBias advanced flag not enabled')
			end
		end
	else
		enabled = 0
		if debug then
			print('in vehicle check failed')
		end
	end
	-- Loop Section: runs every frame
	Citizen.CreateThread(function()
		while (enabled == 1) do
			Citizen.Wait(0)
			-- Gets the current suspension bounds.
			local new_sus_coord = GetVehicleSuspensionBounds(vehicle)
			-- Separated relevant coordinates of suspension bounds.
			local new_sus_coord_z = new_sus_coord.z
			-- Stores the current difference between the original bounds and the current ones.
			local sus_dif = origin_sus_coord_z - new_sus_coord_z
			-- Gets the current suspension state.
			local cur_set = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionRaise')
			-- Creates new suspension height target.
			-- Target takes current suspension height + current difference between current and original suspenssion height.
			local new_set = cur_set + -sus_dif
			-- Safety checks to make sure the value is in the required ranges.
			if new_set < (handling_meta_sus_raise -0.08) then
				new_set = (handling_meta_sus_raise - 0.08)
			elseif new_set > (handling_meta_sus_raise) then
				new_set = handling_meta_sus_raise
			end
			-- Sets the suspension height, new_set reset by the current suspension raise before a new target offset is applied so it will get closer every itteration.
			SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionRaise', new_set)
			if debug then
			drawTxt(0.85, 0.22, 0.4, 0.4, 0.50, "origin_sus_coord_z: " .. Round(origin_sus_coord_z, 4), 255, 255, 0, 255)
			drawTxt(0.85, 0.24, 0.4, 0.4, 0.50, "new_sus_coord_z: " .. Round(new_sus_coord_z, 4), 255, 255, 0, 255)
			drawTxt(0.85, 0.26, 0.4, 0.4, 0.50, "original and current suspension difference: " .. Round(sus_dif, 4), 255, 255, 0, 255)
			drawTxt(0.85, 0.28, 0.4, 0.4, 0.50, "handling_meta_sus_raise: " .. Round(handling_meta_sus_raise, 4), 255, 255, 0, 255)
			drawTxt(0.85, 0.30, 0.4, 0.4, 0.50, "cur_set: " .. Round(cur_set, 4), 255, 255, 0, 255)
			end
			-- Ensures the vehicle is set to the original values when the car is exited.
			if
			  invehicle == 0 then
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fSuspensionRaise', handling_meta_sus_raise)
			end
		end
	end)
end)
--
-- Responds to baseevents server event: Ends the loop
RegisterNetEvent('downforcefix:disabled')
AddEventHandler('downforcefix:disabled', function()
	invehicle = 0
	-- Maybe adjust this if vehicles are not returning to original handling.meta values.
	Citizen.Wait(100)
	enabled = 0
	if debug then
	print('downforcefix left vehicle')
	end
end)