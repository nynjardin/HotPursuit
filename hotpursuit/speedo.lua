local function DrawSpeedo()
		local speed = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(GetPlayerPed(-1))))
		print(speed * 3.6)
		DrawRect( 0.5, 0.9, 0.2, 0.1, 0, 0, 0, 100 )
		SetTextFont( 4 )
    	SetTextProportional( 0 )
    	SetTextScale( 0.9, 0.9)
    	SetTextColour( 255, 255, 255, 255 )
    	SetTextDropShadow( 0, 0, 0, 0, 255 )
    	SetTextEdge( 1, 0, 0, 0, 255 )
    	SetTextEntry( "STRING" )
    	SetTextCentre(true)
    	AddTextComponentString( "Speed:km/h " .. speed * 3.6)
    	DrawText( 0.5, 0.9 )
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			DrawSpeedo()
		end
	end
end)