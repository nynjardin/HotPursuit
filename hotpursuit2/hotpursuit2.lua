local ply = GetPlayerPed(-1)

plyNumber = GetNumberOfPlayers()

function DrawMissionText(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function showLoadingPromt(showText, showTime, showType)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		N_0xaba17d7ce615adbf("STRING") -- set type
		AddTextComponentString(showText) -- sets the text
		N_0xbd12f8228410d9b4(showType) -- show promt (types = 3)
		Citizen.Wait(showTime) -- show time
		N_0x10d373323e5b9c0d() -- remove promt
	end)
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)

--		SetPlayerTeam(GetPlayerPed(-1),  0)
		
		local players = {}

		for i = 0, 31 do
			if NetworkIsPlayerActive( i ) then
				table.insert( players, i )
--				GetPlayerTeam( players )
			end
		end
		
		for k, v in pairs(players) do
--			if not GetBlipFromEntity( GetPlayerPed( v ) ) then
				if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed( v )), GetHashKey("pol718", _r)) or IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed( v )), GetHashKey("polf430", _r)) then
							GetBlipFromEntity( GetPlayerPed( v ) )
							local blip = AddBlipForEntity( GetPlayerPed( v ) )
							SetBlipColour( blip, 2 )
						else
							GetBlipFromEntity( GetPlayerPed( v ) )
							local blip = AddBlipForEntity( GetPlayerPed( v ) )
							SetBlipColour( blip, 1 )
					end
				end
--			end
		end
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey("pol718", _r)) or IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey("polf430", _r)) then
--				SetPlayerTeam(GetPlayerPed(-1),  1)
--				Citizen.Trace("Team 2\n")
				showLoadingPromt("Recherche: Delis en cours", 10000, 3)
			else
--				SetPlayerTeam(GetPlayerPed(-1),  2)
--				Citizen.Trace("Team 2\n")
				showLoadingPromt("Vous êtes recherché: échape aux flics pendant 3 minutes pour t'en sortir", 10000, 3)
			end
		end
	end
end )

--A verifier mais tout ce qui est rope dans la base de donnée des variables peut m'aider pour ce script
--IS_PED_CUFFED 0x74E559B3BC910685
--TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsUsing(GetPlayerPed(-1)), 0)
--Quand le joueur est bloqué pendant + de 5 secondes
if GetEntitySpeed( ) < 1 and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), GetEntityCoords(GetPlayerPed( v ),  true), true) < 3 then
	TaskLeaveVehicle(GetPlayerPed( v ), GetVehiclePedIsUsing(GetPlayerPed( v )), 0)
	Citizen.Wait(1000)
	FreezeEntityPosition(GetPlayerPed ( v ))
	TaskHandsUp(GetPlayerPed( v ), 1000, GetPlayerPed(-1), -1, true)
end-


--Lever les main en l'air
--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(1, 323) then --Start holding X
			TaskHandsUp(GetPlayerPed(-1), 1000, GetPlayerPed(-1), -1, true) -- Perform animation.
		end
	end
end)]]