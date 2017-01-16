local ply = GetPlayerPed(-1)
local ready = 0
local runInProgress = 0


plyNumber = GetNumberOfPlayers()

function DrawMissionText(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

local function spectatePlayer()
	local players = {}
	for i = 0, 31 do
        if NetworkIsPlayerActive( i ) then
            table.insert( players, i )
        end
    end
    for k, v in pairs( players ) do
    	local aPlayer = GetRandomIntInRange(v, plyNumber)
    	if IsPedSittingInAnyVehicle(GetPlayerPed(aPlayer)) then
    		FreezeEntityPosition(GetPlayerPed(-1),  true)
			SetPlayerWantedLevel(PlayerId(), 0, false)
			SetPlayerWantedLevelNow(PlayerId(), false)
    		RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(aPlayer), 1))
    		NetworkSetInSpectatorMode(1, GetPlayerPed(aPlayer))
    		print("Spectating ~b~"..GetPlayerName(aPlayer))
    	end
	end
end

function SetCheckpointPosition(rdmNumber)
		ChekPointHP = {
			{658.828,-17.5347,82.9972},
			{-64.8221,1890.36,195.652},
			{771.638,-2962.57,5.30011},
			{225.213,-3327.68,5.33457},
			{-1822.38,-2818.79,13.4447},
			{1574.25,-1842.77,92.4654},
			{631.54,631.127,128.412},
			{-133.175,424.591,112.814}
		}
		checkPos = ChekPointHP[rdmNumber]
		checkPos = ChekPointHP[1]
		arrBlip = AddBlipForCoord(checkPos[1], checkPos[2], checkPos[3])
		SetBlipSprite(arrBlip, 38)
		SetBlipRoute(arrBlip, 1)
		DrawMarker(1, checkPos[1], checkPos[2], checkPos[3], 0, 0, 0, 0, 0, 0, 8.0, 8.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		print(rdmChk)
		TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1Checkpoint Initialized but not working')
end

function LockedInCar()
	FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)),  true)
	SetVehicleDoorsLocked(GetVehiclePedIsUsing(GetPlayerPed(-1)), 4)
	SetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetPlayerName(PlayerId()))
	TriggerServerEvent('plyReady')
	DrawMissionText("Waiting for ~h~~y~ other players~w~", 10000)
	ready = 1
end

RegisterNetEvent('setCheckPos')
AddEventHandler('setCheckPos', function(posNumber)
		Citizen.Wait(0)
		SetCheckpointPosition(posNumber)
	end)

Citizen.CreateThread(function ()
	while true do
	Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent('playerActivated')
			return
		end
	end
end)


Citizen.CreateThread(function ()
	while true do
	Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and ready == 0 then
			LockedInCar()
		end
		if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			if runInProgress == 1 then		
				spectatePlayer()
				if IsControlJustPressed(1, 214) or IsDisabledControlJustPressed(1, 214) then -- DEL
					spectatePlayer()
				end
			else
    			RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(aPlayer), 1))
    			NetworkSetInSpectatorMode(0, GetPlayerPed(aPlayer))
    		end
		end
		if IsPedFatallyInjured(GetPlayerPed(-1)) and runInProgress == 0 then
			FreezeEntityPosition(GetPlayerPed(-1),  false)
			NetworkSetInSpectatorMode(0, GetPlayerPed(aPlayer))
			TriggerServerEvent('endRun')
		end
		if runInProgress == 1 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), checkPos[1], checkPos[2], checkPos[3], true) < 4.0001 then
				TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsUsing(GetPlayerPed(-1)), 0)
				Wait(2000)
				DrawMissionText("Vous êtes ~h~~y~arrivé~w~!!!", 10000)
				ready = 0
				TriggerServerEvent('endRun')
				spectatePlayer()
				if IsControlJustPressed(1, 214) or IsDisabledControlJustPressed(1, 214) then -- DEL
					spectatePlayer()
				end
			else
				TriggerServerEvent('endRun')
				ready = 0			
			end
		end
	end
end)

SpawnPositions = {
	{-3111.05, 1294.3, 20.3495},
	{-3111.05, 1294.3, 20.3495},
	{-3111.05, 1294.3, 20.3495},
	{-3111.05, 1294.3, 20.3495}
}

RegisterNetEvent('noOnePlayerAlive')
AddEventHandler('noOnePlayerAlive', function()
Citizen.CreateThread(function()
		Citizen.Wait(1500)
		ready = 0
		local playerPed = GetPlayerPed(-1)
		local spawnPos = SpawnPositions[math.random(1, 4)]
		SetEntityCoords(playerPed, spawnPos[1], spawnPos[2], spawnPos[3])
		FreezeEntityPosition(playerPed,  false)
		if not IsPedSittingInAnyVehicle(playerPed) then
    		RequestCollisionAtCoord(GetEntityCoords(playerPed, 1))
    		NetworkSetInSpectatorMode(0, GetPlayerPed(aPlayer))
		end
	end)
end)

RegisterNetEvent('notInProgress')
AddEventHandler('notInProgres', function()
	runInProgress = 0
end)

RegisterNetEvent('inProgress')
AddEventHandler('inProgres', function()
	runInProgress = 1
end)

RegisterNetEvent('startRun')
AddEventHandler('startRun', function()
	Citizen.Wait(0)
	runInProgress = 1
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 3')
			Wait(1000)
			TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 2')
			Wait(1000)
			TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 1')
			Wait(1000)
			TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^2 GO! GO! GO!')
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)),  false)
			SetPlayerWantedLevel(PlayerId(), 5, false)
			SetPlayerWantedLevelNow(PlayerId(), false)
			DrawMissionText("You are ~h~~y~wanted~w~!!!", 10000)

		end

end)