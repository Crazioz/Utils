print("^2[BCRP] ^3Utils Core Ready")
print("^2[BCRP] ^3ChangeSeat Ready")

-- DESACTIVER LE CHANGEMENT DE PLACE AUTO

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)

-- MONTER A L'ARRIERE DU VEHICULE

local doors = {
	{"seat_dside_f", -1},
	{"seat_pside_f", 0},
	{"seat_dside_r", 1},
	{"seat_pside_r", 2}
}

function VehicleInFront(ped)
    local pos = GetEntityCoords(ped)
    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
	
    return result
end

Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(0)
			
		local ped = PlayerPedId()
			
   		if IsControlJustReleased(0, 23) and running ~= true and GetVehiclePedIsIn(ped, false) == 0 then
      		local vehicle = VehicleInFront(ped)
				
      		running = true
				
      		if vehicle ~= nil then
				local plyCoords = GetEntityCoords(ped, false)
        		local doorDistances = {}
					
        		for k, door in pairs(doors) do
          			local doorBone = GetEntityBoneIndexByName(vehicle, door[1])
          			local doorPos = GetWorldPositionOfEntityBone(vehicle, doorBone)
          			local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, doorPos.x, doorPos.y, doorPos.z)
						
          			table.insert(doorDistances, distance)
        		end
					
        		local key, min = 1, doorDistances[1]
					
        		for k, v in ipairs(doorDistances) do
          			if doorDistances[k] < min then
           				key, min = k, v
          			end
        		end
					
        		TaskEnterVehicle(ped, vehicle, -1, doors[key][2], 1.5, 1, 0)
     		end
				
      		running = false
    	end
  	end
end)

-- KEYBIND CHANGEMENT PLACE VEHICLE
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
			if CarSpeed <= 40.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 60 km/h
				if IsControlJustReleased(0, 157) then -- conducteur
					SetPedIntoVehicle(plyPed, plyVehicle, -1)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 158) then -- avant droit
					SetPedIntoVehicle(plyPed, plyVehicle, 0)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 160) then -- arriere gauche
					SetPedIntoVehicle(plyPed, plyVehicle, 1)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 164) then -- arriere gauche
					SetPedIntoVehicle(plyPed, plyVehicle, 2)
					Citizen.Wait(10)
				end
			end
		end
		Citizen.Wait(10) -- Fix Crash Client
	end
end)

print("^2[BCRP] ^3NoCops Ready")

-- REMOVE COPS PEDS

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
	local playerPed = GetPlayerPed(-1)
	local playerLocalisation = GetEntityCoords(playerPed)
	ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)
	end
	end)

print("^2[BCRP] ^3NoDropWeapon Ready")
-- NO DROP PNJ 

function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false

    repeat
        if not IsEntityDead(ped) then
            SetPedDropsWeaponsWhenDead(ped, false)
        end
        finished, ped = FindNextPed(handle)
    until not finished

    EndFindPed(handle)
end

Citizen.CreateThread(function()
    while true do
        SetWeaponDrops()
        Citizen.Wait(500)
    end
end)

print("^2[BCRP] ^3NoReticuleWeapon Ready")

----- Plus de point pour les armes
Citizen.CreateThread(function()
    local isSniper = false
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        local currentWeaponHash = GetSelectedPedWeapon(ped)

        if currentWeaponHash == 100416529 then
            isSniper = true
        elseif currentWeaponHash == 205991906 then
            isSniper = true
        elseif currentWeaponHash == -952879014 then
            isSniper = true
        elseif currentWeaponHash == GetHashKey('WEAPON_HEAVYSNIPER_MK2') then
            isSniper = true
        else
            isSniper = false
        end

        if not isSniper then
            HideHudComponentThisFrame(14)
        end
    end
end)

print("^2[BCRP] ^3PauseMenu Ready")

-- Pause Menu

function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
  AddTextEntry('FE_THDR_GTAO', '~r~Blaine County ~w~- ~g~ID : ' .. GetPlayerServerId(PlayerId()) .. '~w~ - ~o~https://discord.gg/82VJ8mh')
  AddTextEntry('PM_PANE_LEAVE', '~o~Retourner sur la liste des serveurs.')
  AddTextEntry('PM_PANE_QUIT', '~r~Quitter Blaine County')
  AddTextEntry('PM_SCR_MAP', 'Carte de Blaine County')
  AddTextEntry('PM_SCR_GAM', '~r~Prendre l\'avion')
  AddTextEntry('PM_SCR_INF', '~g~Logs')
  AddTextEntry('PM_SCR_SET', '~p~Configuration')
  AddTextEntry('PM_SCR_STA', '~f~Statistiques')
  AddTextEntry('PM_SCR_RPL', '~y~Éditeur ∑')
end)

print("^2[BCRP] ^3PVP Ready")
-- ADD PVP

AddEventHandler("playerSpawned", function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
end)

print("^2[BCRP] ^3NoDropWeaponCar Ready")

-- Disable dispatch & Weapon POLICE

Citizen.CreateThread(function()
	for i = 1, 12 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
       
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local myCoords = GetEntityCoords(GetPlayerPed(-1))
        ClearAreaOfCops(myCoords.x, myCoords.y, myCoords.z, 100.0, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)

Citizen.CreateThread(function()
    while true
        do
            -- 1.
        SetVehicleDensityMultiplierThisFrame(0.2)
        --SetPedDensityMultiplierThisFrame(0.2)
        --SetRandomVehicleDensityMultiplierThisFrame(1.0)
        --SetParkedVehicleDensityMultiplierThisFrame(1.0)
        --SetScenarioPedDensityMultiplierThisFrame(2.0, 2.0)
       
        --local playerPed = GetPlayerPed(-1)
        --local pos = GetEntityCoords(playerPed)
        --RemoveVehiclesFromGeneratorsInArea(pos['x'] - 900.0, pos['y'] - 900.0, pos['z'] - 900.0, pos['x'] + 900.0, pos['y'] + 900.0, pos['z'] + 900.0);
       
       
        -- 2.
        --SetGarbageTrucks(0)
        --SetRandomBoats(0)
        --SetRandomBus(0)
        Citizen.Wait(1)
    end
 
end)

print("^2[BCRP] ^3DiscordNotify Ready")

ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand("discord",function()
	discordapp()
end)

function discordapp()
	ESX.ShowNotification("~g~Bienvenue~s~ \nVoici le lien Discord du serveur : ~o~https://discord.gg/82VJ8mh")
end