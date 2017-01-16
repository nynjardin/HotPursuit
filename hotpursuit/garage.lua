local ply = GetPlayerPed(-1)

--vehicleRepairStation = {}

-- Setting
-----------------------------------------------------------------------
----------------------------MAP-LOCATION-------------------------------
-----------------------------------------------------------------------

location1_x = 1183.89
location1_y = -334.16
location1_z = 68.41

location2_x = -2100.31
location2_y = -312.37
location2_z = 12.26

location3_x = 176.20
location3_y = 6605.06
location3_z = 31.08

location4_x = 2584.26
location4_y = 358.81
location4_z = 107.69

location5_x = 2007.83
location5_y = 3776
location5_z = 32.40

location6_x = -728.12
location6_y = -934.32
location6_z = 18.25



function DrawMissionText(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function ()
	while true do
	Citizen.Wait(0)
	stationBlip1 = AddBlipForCoord(location1_x, location1_y, location1_z)
	DrawMarker(1, location1_x, location1_y, location1_z -1.0001, 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
	stationBlip2 = AddBlipForCoord(location2_x, location2_y, location2_z)
	DrawMarker(1, location2_x, location2_y, location2_z -1.0001, 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
	stationBlip3 = AddBlipForCoord(location3_x, location3_y, location3_z)
	DrawMarker(1, location3_x, location3_y, location3_z -1.0001, 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
	stationBlip4 = AddBlipForCoord(location4_x, location4_y, location4_z)
	DrawMarker(1, location4_x, location4_y, location4_z -1.0001, 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
	stationBlip5 = AddBlipForCoord(location5_x, location5_y, location5_z)
	DrawMarker(1, location5_x, location5_y, location5_z -1.0001, 0, 0, 0, 0, 0, 0, 20.0, 20.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
	stationBlip6 = AddBlipForCoord(location6_x, location6_y, location6_z)
	DrawMarker(1, location6_x, location6_y, location6_z -1.0001, 0, 0, 0, 0, 0, 0, 20, 20.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)

	SetBlipSprite(stationBlip1, 446) --100 = CarWash
	SetBlipSprite(stationBlip2, 446) --100 = CarWash
	SetBlipSprite(stationBlip3, 446) --100 = CarWash
	SetBlipSprite(stationBlip4, 446) --100 = CarWash
	SetBlipSprite(stationBlip5, 446) --100 = CarWash
	SetBlipSprite(stationBlip6, 446) --100 = CarWash

	--if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
	--	return true 
	--end
--		arrBlip = AddBlipForCoord(1031.5,-235.052,69.9436)
--		SetBlipSprite(arrBlip, 446)
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), location1_x, location1_y, location1_z, true ) < 20 or 
			GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), location2_x, location2_y, location2_z, true ) < 20 or 
			GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), location3_x, location3_y, location3_z, true ) < 20 or 
			GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), location4_x, location4_y, location4_z, true ) < 20 or 
			GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), location5_x, location5_y, location5_z, true ) < 20 or 
			GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), location6_x, location6_y, location6_z, true ) < 20 then 
--		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1031.5,-235.052,69.9436, true) < 10.0001 then
			SetVehicleFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)))
			SetVehicleDeformationFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)))
			SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
			DrawMissionText("Voiture ~h~~y~réparée~w~!!! Go! Go! Go!", 10000)
		end
	
	end
	

end)