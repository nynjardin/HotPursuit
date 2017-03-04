local plyPed = GetPlayerPed(-1)
local plyVeh = GetVehiclePedIsUsing(GetPlayerPed(-1))
local shortR = true

-----------------------------------------------------------------------
----------------------------GARAGE-LOCATION----------------------------
-----------------------------------------------------------------------

vehicleRepairStation = {
	{49.41872,  2778.793,  58.04395},
	{263.8949,  2606.463,  44.98339},
	{1039.958,  2671.134,  39.55091},
	{1207.26,   2660.175,  37.89996},
	{2539.685,  2594.192,  37.94488},
	{2679.858,  3263.946,  55.24057},
	{2692.521,  3269.72,   55.24056},
	{2692.521,  3269.72,   55.24056},
	{2005.055,  3773.887,  32.40393},
	{1687.156,  4929.392,  42.07809},
	{1701.314,  6416.028,  32.76395},
	{154.8158,  6629.454,  31.83573},
	{179.8573,  6602.839,  31.86817},
	{-94.46199, 6419.594,  31.48952},
	{-2554.996, 2334.402,  33.07803},
	{-1800.375, 803.6619,  138.6512},
	{-1437.622, -276.7476, 46.20771},
	{-2096.243, -320.2867, 13.16857},
	{-724.6192, -935.1631, 19.21386},
	{-526.0198, -1211.003, 18.18483},
	{-70.21484, -1761.792, 29.53402},
	{265.6484,  -1261.309, 29.29294},
	{819.6538,  -1028.846, 26.40342},
	{1208.951,  -1402.567, 35.22419},
	{1181.381,  -330.8471, 69.31651},
	{620.8434,  269.1009,  103.0895},
	{2581.321,  362.0393,  108.4688}
}

	
Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #vehicleRepairStation do
		garageCoords = vehicleRepairStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 446) --446 = Tools
		SetBlipAsShortRange(stationBlip, true)
	end
end)

function DrawSpecialText(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
			for i = 1, #vehicleRepairStation do
				garageCoords2 = vehicleRepairStation[i]
				DrawMarker(1, garageCoords2[1], garageCoords2[2], garageCoords2[3] -1, 0, 0, 0, 0, 0, 0, 20.0, 20.0, 3.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 20 then 
					SetVehicleFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					SetVehicleDeformationFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)))
					SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
					DrawSpecialText("Vehicle ~h~~y~fixed~w~!!! Go! Go! Go!", 5000)
				end
			end
		end
	end
end)