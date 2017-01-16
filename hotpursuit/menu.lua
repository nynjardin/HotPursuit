

function drawMenuButton(font,prop,sc,r,g,b,a,texte,x,y,mw,mh)
	SetTextFont(font)
	SetTextProportional(prop)
	SetTextScale(sc, sc)
	SetTextColour(r, g, b, a)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(texte)
	DrawRect(x,y,mw,mh,0,0,0,255)
	DrawText(x - mw/2 + 0.005, y - mh/2 + 0.0028)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(1, 214) then -- DEL
			drawMenuButton(0,1,0.4,255,255,255,128,"Test",0.5,0.5,0.1,0.05)
--			DrawSprite(CommonMenu, medal_gold, 0.5, 0.5, 1, 1, 0.0,  0,  0,  0,  255)
		end
	end
end)