
local g_isSpectating = GetPlayerPed(g_online_selectedPlayer)
local players = {}
--local x, y, z = GetEntityCoords(g_online_selectedPlayer, 1) 

function ()
	for i = 0, 31 do
        if NetworkIsPlayerActive( i ) then
            table.insert( players, i )
            local g_online_selectedPlayer = NetworkIsPlayerActive( i )
        end
	end
	if not NetworkIsPlayerConnected(g_online_selectedPlayer) then
		print("Player isn't connected.")
		g_isSpectating = false;
	end
	if (g_isSpectating) then
		if not (IsScreenFadedOut()) then
			if not (IsScreenFadingOut()) then
				DoScreenFadeOut(1000);
				while not (IsScreenFadedOut()) then 
					Wait(0)
					RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(g_online_selectedPlayer), 1))
					NetworkSetInSpectatorMode(1,  g_online_selectedPlayer)
					print("Spectating ~b~"..GetPlayerName(g_online_selectedPlayer))
					if (IsScreenFadedOut())
						DoScreenFadeIn(1000)
					end
				end
			end
		end			
	else
		if not (IsScreenFadedOut()) then
			if not (IsScreenFadingOut()) then
			DoScreenFadeOut()(1000)
				while not (IsScreenFadedOut()) then
					Wait(0);
					RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(g_online_selectedPlayer), 1))
					NetworkSetInSpectatorMode(0,  g_online_selectedPlayer)
					if (IsScreenFadedOut()) then
						DoScreenFadeIn(1000);
					end
				end
			end
		end
	end
end