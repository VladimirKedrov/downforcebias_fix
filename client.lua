debug = Config.client_debug
local invehicle = 0
local handling_meta_sus_raise = 0
local enabled = 0
local sus_mod_distance = 0

-- Listens to event trigger then runs
RegisterNetEvent('downforcefix:enabled')
AddEventHandler('downforcefix:enabled', function()
	-- Static Section: runs once per event trigger
	invehicle = 1
	--print('downforcefix_client_enabled')
	if invehicle == 1 then
		if debug then
		print('downforcefix entered vehicle')
		end
		-- Gets the entity that the play is in.
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
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
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		while (enabled == 1) do
			Citizen.Wait(1)
			-- Gets current suspension coordinates
			local new_sus_coord = GetVehicleSuspensionBounds(vehicle)
			-- Separated current suspension vertical vector
			local new_sus_coord_z = new_sus_coord.z
			-- Finds the difference between the original suspension coordinates and the current suspension coordinates
			local sus_dif = origin_sus_coord_z - new_sus_coord_z
			-- Find the modkit index of the suspension upgrade.
			local sus_mod_index = GetVehicleMod(vehicle, 15)
			-- Find the statmod of the current suspension upgrade
			local sus_mod_value = GetVehicleModModifierValue(vehicle, 15, sus_mod_index)
			-- Zeros the distance if the vehicle doesn't have a suspension upgraded equiped.
			-- If equipped mutlplies the statmod to find the correct corresponding suspesnion offset.
			if sus_mod_index == -1 then
				sus_mod_distance = 0
			else
				sus_mod_distance = sus_mod_value * 0.001
			end
			-- Baseline suspension height detrmined from combining the suspension offset from the handling.meta and carcols upgrade
			-- Handling.meta is inverted as handling.meta is backwards to what the set native expects.
			local stationary_sus_offset = -handling_meta_sus_raise + sus_mod_value
			-- Takes the baseline suspension height and adds a counteracting descrease determined by the suspension raise increase due to downforcebias flag.
			-- Positive values reduce the suspension height
			local required_suspension_height_offset = stationary_sus_offset + sus_dif
			-- Sets the current suspension height to the required ammount to keep the suspension at the same level as it was when it was stationary.
			SetVehicleSuspensionHeight(vehicle, required_suspension_height_offset)
			-- Stores the current suspension height for debugging.
			local current_suspension_height = GetVehicleSuspensionHeight(vehicle)
			if debug then
			DrawTxt(0.85, 0.42, 0.4, 0.4, 0.50, "required_suspension_height_offset: " .. round(required_suspension_height_offset, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.44, 0.4, 0.4, 0.50, "origin_sus_coord_z: " .. round(origin_sus_coord_z, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.48, 0.4, 0.4, 0.50, "new_sus_coord_z: " .. round(new_sus_coord_z, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.46, 0.4, 0.4, 0.50, "original and current suspension difference: " .. round(sus_dif, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.50, 0.4, 0.4, 0.50, "handling_meta_sus_raise: " .. round(handling_meta_sus_raise, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.52, 0.4, 0.4, 0.50, "stationary_sus_offset: " .. round(stationary_sus_offset, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.54, 0.4, 0.4, 0.50, "sus_mod_index: " .. round(sus_mod_index, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.56, 0.4, 0.4, 0.50, "sus_mod_value: " .. round(sus_mod_value, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.58, 0.4, 0.4, 0.50, "current_suspension_height_offset_from_0: " .. round(current_suspension_height, 4), 255, 255, 0, 255)
			DrawTxt(0.85, 0.60, 0.4, 0.4, 0.50, "sus_mod_distance: " .. round(sus_mod_distance, 4), 255, 255, 0, 255)
			end
			-- Makes sure that when leaving the vehicle that the original suspension height is set
			if
			  invehicle == 0 then
				SetVehicleSuspensionHeight(vehicle, stationary_sus_offset)
			end
		end
	end)
end)

-- Responds to baseevents server event: Ends the loop
RegisterNetEvent('downforcefix:disabled')
AddEventHandler('downforcefix:disabled', function()
	invehicle = 0
	Citizen.Wait(100) -- Maybe adjust this if vehicles are not returning to original handling.meta values.
	enabled = 0
	if debug then
	print('downforcefix left vehicle')
	end
end)

-- UI Toggle command
RegisterCommand("downforcefix_debug", function()
	if debug == false then
		debug = true
		if enabled ~= 1 then
			print('in_vehicle_trigger_not_active')
		end
	else
		debug = false
	end
end)

-- Rounding function
function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- Ui display function
function
	DrawTxt(x, y, width, height, scale, text, r, g, b, a)
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

-- bitwise operation function
OR, XOR, AND = 1, 3, 4

function bitoper(a, b, oper)
   local r, m, s = 0, 2^31
   repeat
	  s,a,b = a+b+m, a%m, b%m
	  r,m = r + m*oper%(s-a-b), m/2
   until m < 1
   return r
end