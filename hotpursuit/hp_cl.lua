local runInProgress = false
local score = 0
local inRun = false
local wantedLevel = 3
local ready = false
local spectate = false
local endScreen = false
local fixTires = 2
local players = {}
local plyRun = 0
local plyToSpec = players[plyRun]
local plyPos = GetEntityCoords(GetPlayerPed(-1))
local insideGarage = { --1 x, y, z, vehicleHeading, pedHeading
    {x = -46.56327, y = -1097.382, z = 25.99875, vh = 228.2736, ph = 120.1953}, -- 1 Garage de base
    {x = 228.721, y = -993.374, z = -99.0, vh = 228.2736, ph = 120.1953}, -- 2 Garage Propre
    {x = 480.991, y = -1317.7, z = 29.2027, vh = 131.7264, ph = 120.1953}, -- 3 Garage Crade
    {x = -211.309, y = -1324.41, z = 30.8904, vh = 228.2736, ph = 120.1953}, -- 4 Garage fun
    {x = 436.441, y = -996.352, z = 25.7738, vh = 228.2736, ph = 120.1953}, -- 5 sous sol garage police
    {x = 449.511, y = -981.129, z = 43.6916, vh = 228.2736, ph = 120.1953}, -- 6 Toit police station
    {x = -75.1452, y = -818.625, z = 326.176, vh = 228.2736, ph = 120.1953}, -- 7 Toit du plus grand building de Vice City
    {x = 110.729, y = 6626.407, z = 31.787, vh = 228.2736, ph = 120.1953}, -- 8 Petit garage Custom - REPLACER
    {x = -1156.748, y = -2009.824, z = 13.180, vh = 228.2736, ph = 120.1953}, -- 9 Garage Custom moyen
    {x = 732.951, y = -1086.138, z = 22.168, vh = 228.2736, ph = 120.1953}, -- 10 Garage Pourrit Moyen
    {x = -334.172, y = -137.801, z = 39.009, vh = 228.2736, ph = 120.1953}, -- 11 Garage Custom moyen
    {x = 1175.404, y = 2640.987, z = 37.753, vh = 228.2736, ph = 120.1953}, -- 12 Petit garage Custom :p
    {x = -693.727, y = -757.278, z = 33.684, vh = 228.2736, ph = 120.1953} -- 13 Garage public (pour les flics?)
}

local inGar = insideGarage[13] -- changer ce nombre pour changer de garage

--La liste des voitures qui doit etre declaré avant ce qu'il y a juste en dessous
local CarList = {"adder","banshee2","bullet","cheetah","entityxf","sheava","fmj","infernus","osiris","le7b","reaper","sultanrs","t20","turismor","tyrus","vacca","voltic","prototipo","zentorno"}
local num = 1 --Numero de la table des voitures (1 sur 17)
local carToShow = CarList[num] --carToShow devient la voiture a prendre en compte

--Liste des point d'arrivé
chekPointHP = {
    {658.828,-17.5347,82.9972},
    {-64.8221,1890.36,195.652},
    {771.638,-2962.57,5.30011},
    {225.213,-3327.68,5.33457},
    {-1822.38,-2818.79,13.4447},
    {1574.25,-1842.77,92.4654},
    {631.54,631.127,128.412},
    {-133.175,424.591,112.814}
}

--Liste des points de depart
SpawnPositions = {
    {-3113.44, 1274.56, 20.2978},
    {-3113.29, 1280.34, 20.3221},
    {-3111.37, 1284.66, 20.298},
    {-3111.03, 1288.62, 20.3134},
    {-3110.05, 1295.48, 20.302},
    {-3108.96, 1301.24, 20.2312},
    {-3106.05, 1307.3, 20.088},
    {-3105.69, 13011.34, 20.1776},
    {-3105.30, 1315.94, 20.1891},
    {-3104.31, 1320.83, 20.2043},
    {-3103.61, 1325.82, 20.3397},
    {-3102.86, 1330.61, 20.2128},
    {-3101.52, 1334.14, 20.2497},
    {-3097.66, 1343.49, 20.2117},
    {-3096.21, 1346.64, 20.2259},
    {-3094.84, 1350.37, 20.2345}
}

local scoret =  {ply = {}, points = {} } 


RegisterNetEvent('hp:moreRunner')
AddEventHandler('hp:moreRunner', function(runnerX)
if not players[runnerX] then
        players[runnerX] = true
    end
end)

RegisterNetEvent('hp:lessRunner')
AddEventHandler('hp:lessRunner', function(runnerX)
    --scoret.points = nil
    --scoret.ply = nil
    if not players[runnerX] then
        players[runnerX] = nil
    end
end)

RegisterNetEvent('hp:plyScore')
AddEventHandler('hp:plyScore', function(plyScore, plyName)
    table.insert(scoret.points, plyScore)
    table.insert(scoret.ply, plyName)
end)

--La liste des joueurs, récuperé sur https://github.com/jorjic/misc-fivereborn-scripts/blob/74675d15ed6be35dc03caafd68d53bd5a1e160e2/resources/jscoreboard/scoreboard.lua
--En faire un autre a l'occasion, plus adapté (genre, a droite deja)

--function de l'ecran de fin qui attend le texte qui sera affiché et le type, victoire, defaite, ect...
--la liste des type est trouvable ici: http://pastebin.com/dafBAjs0
local function EndScreen(text, type)
    Citizen.CreateThread(function()
       while true do
           Citizen.Wait(0)      
                if endScreen then 
                    StartScreenEffect(type, 0, 0)
                    PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
                    
                    local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

                    if HasScaleformMovieLoaded(scaleform) then
                        Citizen.Wait(0)

                    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                    BeginTextComponent("STRING")
                    AddTextComponentString(text)
                    EndTextComponent()
                    PopScaleformMovieFunctionVoid()

                    Citizen.Wait(500)

                    PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
                    while endScreen do
                        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                        Citizen.Wait(0)
                    end 
                    Citizen.Wait(1000)
                    StopScreenEffect(type)
                    
                end
            end
        end
    end)
end

--Envoie au serveur que le joueur est arrivé sur le serveur
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            TriggerServerEvent('hp:firstJoin')
            return
        end
    end
end)

--permet d'ecrire du texte en bas au milieu
function DrawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

function FadingOut(time)
    if not IsScreenFadedOut() then
        if not IsScreenFadingOut() then
            DoScreenFadeOut(time)
        end
    end
end

function FadingIn(time)
    if IsScreenFadedOut() or IsScreenFadingOut() then
        DoScreenFadeIn(time)
    end
end


--la fonction qui s'occupe de rendre les joueurs specateurs
local function spectatePlayer()
    endScreen = false
    spectate = true
    FreezeEntityPosition(GetPlayerPed(-1),  true)
    SetPlayerWantedLevel(PlayerId(), 0, false)
    SetPlayerWantedLevelNow(PlayerId(), false)
    RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(plyToSpec), 1))
    NetworkSetInSpectatorMode(1, GetPlayerPed(plyToSpec))
    print("Spectating ~b~"..GetPlayerName(plyToSpec))
    while true do
        Citizen.Wait(0)
        if spectate then
            --[[if IsPedFatallyInjured(GetPlayerPed(plyToSpec)) or NetworkIsPlayerActive( plyToSpec ) then
                Wait(2500)
                TriggerServerEvent('hp:observedDead') --Envoie au serveur que l'observé est mort
            end]]
            if IsControlJustPressed(1,190) and plyRun < #players then --Fleche droite
                FadingOut(500)
                plyRun = plyRun + 1 
                plyToSpec = players[plyRun]
                if IsPedSittingInAnyVehicle(GetPlayerPed(plyToSpec)) then 
                    FreezeEntityPosition(GetPlayerPed(-1),  true)
                    SetPlayerWantedLevel(PlayerId(), 0, false)
                    SetPlayerWantedLevelNow(PlayerId(), false)
                    RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(plyToSpec), 1))
                    NetworkSetInSpectatorMode(1, GetPlayerPed(plyToSpec))
                    DrawMissionText("Spectating ~b~"..GetPlayerName(plyToSpec), 10000)
                end
                FadingIn(500)
            end

            if IsControlJustPressed(1,189) and plyRun > 0 then --Fleche gauche
                FadingOut(500)
                plyRun = plyRun - 1 
                plyToSpec = players[plyRun]
                if IsPedSittingInAnyVehicle(GetPlayerPed(plyToSpec)) then 
                    FreezeEntityPosition(GetPlayerPed(-1),  true)
                    SetPlayerWantedLevel(PlayerId(), 0, false)
                    SetPlayerWantedLevelNow(PlayerId(), false)
                    RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(plyToSpec), 1))
                    NetworkSetInSpectatorMode(1, GetPlayerPed(plyToSpec))
                    DrawMissionText("Spectating ~b~"..GetPlayerName(plyToSpec), 10000)
                end
                FadingIn(500)
            end
            if not runInProgress then
        		FreezeEntityPosition(GetPlayerPed(-1),  false)
    			SetPlayerWantedLevel(PlayerId(), 0, false)
    			SetPlayerWantedLevelNow(PlayerId(), false)
        		RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(-1), 1))
        		NetworkSetInSpectatorMode(0, GetPlayerPed(-1))
                spectate = false
            end
        end
    end
end

--La fonction qui fait apparaitre la voiture lors de la séléction, dans le garage, elle attend le nom d'une voiture (car) 
function ShowCar(car)
    --insideVeh = {-46.56327,-1097.382,25.99875, 228.2736} --coordonnée de l'interieur du garage, la 4eme est l'oriendtation de la voiture
    modelVeh = GetHashKey(car) --Le hashkey est necessaire pour generer la voiture a partir de son nom
    RequestModel(modelVeh) --Appel du model de la voiture
    while not HasModelLoaded(modelVeh) do -- tant que le model n'est pas chargé, ne pas continuer l'execution du code
        Citizen.Wait(0)
    end
    TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 Client: Model de vehicule Chargée' )
    personalvehicle = CreateVehicle(modelVeh ,inGar.x, inGar.y, inGar.z, inGar.vh, false, false) --Determiné la voiture a afficher, le 1er fasle permet de la rendre visible que pour le joueur qui l'a généré
    Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(personalvehicle)) --Préparer la voiture a etre detruite des qu'elle sera hors de vue du joueur 
    TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 Client: Voiture choisie: '..modelVeh)
    SetVehicleOnGroundProperly(personalvehicle) --S'assure que la voiture soit posé normalement aui sol
    SetVehicleHasBeenOwnedByPlayer(personalvehicle,true) --Permet au joueur de la demarrer de suite, ou d'entrer dedans sans la braquer
    local id = NetworkGetNetworkIdFromEntity(personalvehicle) --Aucune idée, mais necessaire a ce que j'ai comprius
    SetNetworkIdCanMigrate(id, true) --Aucune idée, mais necessaire a ce que j'ai comprius
--    TaskWarpPedIntoVehicle(GetPlayerPed(-1), personalvehicle ,-1)
end 

--fonction pour le choix de la couleur, mais on ne peut pas vraiment le faire...
function ColorToCar(color)
    SetVehicleColours(personalvehicle, color)
end

--pour afficher l'aide lors de selection de la voiture
function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 1, -1)
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1+w, y - 0.02+h)
end

--Affiche un message en bas a droite de l'ecran
function loadingPromp()
    N_0xaba17d7ce615adbf("STRING")
    AddTextComponentString("En attente des autres joueurs")
    N_0xbd12f8228410d9b4("FM_IHELP_WAT2")
end

--Le serveur envoie ça au client quand il a validé sa connection
RegisterNetEvent('hp:selectCar')
AddEventHandler('hp:selectCar', function()
    
    endScreen = false

    ShowCar(carToShow) --la 1ere voiture qui va apparaitre, defini tout en haut de cette page de code
    FadingIn(1000)

    SetEntityHealth(GetPlayerPed(-1), 200)
    while true do
        Citizen.Wait(0)

        if not ready then

            --Choix de la voiture
            if IsControlJustPressed(1,190) and num < #CarList then --Fleche droite
                SetModelAsNoLongerNeeded(personalvehicle) --Préparer la voiture a etre detruite
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(personalvehicle)) -- fais disparaitre la voiture
                num = num + 1 
                carToShow = CarList[num]
                ShowCar(carToShow)
            end

            if IsControlJustPressed(1,189) and num > 1 then --Fleche gauche
                SetModelAsNoLongerNeeded(personalvehicle)
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(personalvehicle))
                num = num - 1
                carToShow = CarList[num]
                ShowCar(carToShow)
            end

            --Affichage de la couleur de la voiture
            if IsControlJustPressed(1,188) then --Fleche haut
                SetModelAsNoLongerNeeded(personalvehicle) --Préparer la voiture a etre detruite
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(personalvehicle)) -- fais disparaitre la voiture
                ShowCar(carToShow)
            end

            if IsControlJustPressed(1,187) then --Fleche bas
                SetModelAsNoLongerNeeded(personalvehicle)
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(personalvehicle))
                ShowCar(carToShow)
            end

            --Choix de la difficulté
            if IsControlJustPressed(1,206) and wantedLevel < 5 then --Gachette haute droite
                wantedLevel = wantedLevel + 1
                TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 Client: Wanted Level: '..wantedLevel)
            end
            if IsControlJustPressed(1,205) and wantedLevel > 1 then --Gachette haute gauche
                wantedLevel = wantedLevel - 1
                TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 Client: Wanted Level: '..wantedLevel)
            end
            --Tant que rien n'est validé, afficher la voiture
            if IsControlJustPressed(1,201) then -- 201 correspond a "Valider" soit "Enter" ou "A" sur une manette
                modelVeh = GetHashKey(carToShow)
                FadingOut(500)
                Wait(500)
                ready = true --passe le joueur en pret
                TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 Client: Entrer Validé')
                SetModelAsNoLongerNeeded(personalvehicle) --Préparer la voiture a etre detruite
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(personalvehicle)) --detruit la voiture dans le magasin
                Wait(500)
                TriggerServerEvent('hp:carSelected') --Envoie au serveur que la voiture a ete choisie

            else
                FreezeEntityPosition(GetPlayerPed(-1),true) --paralyse le joueur
                SetEntityVisible(GetPlayerPed(-1),false) --le rend invisible
                SetEntityCoords(personalvehicle, inGar.x, inGar.y, inGar.z,1,0,0,1)-- TP la voiture a cet entroit
                SetEntityHeading(GetPlayerPed(-1),inGar.ph) -- L'endroit ou le joueur regarde a ce momet la
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), personalvehicle ,-1)
                plyVeh = GetVehiclePedIsUsing(GetPlayerPed(-1))
                colors = table.pack(GetVehicleColours(plyVeh))
                extra_colors = table.pack(GetVehicleExtraColours(plyVeh))
            end
        else return end
    end
end)



--Le serveur envoie qu'il placer la voiture sur le depart, attend "spwNum" qui sera son emplacement (generé en fonction des joueurs deja present sur le depart)
RegisterNetEvent('hp:startingBlock')
AddEventHandler('hp:startingBlock', function(spwNum)
    Wait(500)
        local spawnPos = SpawnPositions[spwNum]

        ---------------------------------- fait apparaitre la voiture choisie en visible pour tout le monde et TP le joueur a l'interieur

        TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^2 Client: Position d arrivée: '..spwNum )
        RequestModel(modelVeh)
        while not HasModelLoaded(modelVeh) do
            Citizen.Wait(0)
        end
        TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 Client: Model de vehicule Chargée' )
        personalvehicle2 = CreateVehicle(modelVeh ,spawnPos[1], spawnPos[2], spawnPos[3], 228.2736, true, false)

        TriggerEvent('chatMessage', '', { 0, 0, 0 }, '^1 Client: Voiture choisie: '..modelVeh)
        SetVehicleOnGroundProperly(personalvehicle2)
        SetVehicleHasBeenOwnedByPlayer(personalvehicle2,true)
        local id = NetworkGetNetworkIdFromEntity(personalvehicle2)
        SetNetworkIdCanMigrate(id, true)
        SetEntityCoords(GetPlayerPed(-1),spawnPos[1],spawnPos[2],spawnPos[3] + 1, 1, 0, 0, 1)
        FreezeEntityPosition(GetPlayerPed(-1),false)
        SetEntityVisible(GetPlayerPed(-1),true)
        SetVehicleColours(personalvehicle2, colors[1], colors[2])
        SetVehicleExtraColours(personalvehicle2, extra_colors[1], extra_colors[2])
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), personalvehicle2 ,-1)

-------------------------------  

        FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)),  true) -- Bloque la voiture du joueur
        SetVehicleDoorsLocked(GetVehiclePedIsUsing(GetPlayerPed(-1)), 4) -- Verouille les portes pour que le joueur ne puisse plus sortir de la voiture
        SetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetPlayerName(PlayerId())) -- Met le pseudo du joueur comme plaque d'immatriculation
        TriggerServerEvent('hp:plyReady') -- Envoie au serveur que le joueur est pret
        ready = true --Pret
        loadingPromp()
        FadingIn(500)
        DrawMissionText("Waiting for ~h~~y~ other players~w~", 10000)
    end)

--Fonction d'affichahe du compte a rebours... je vais le verifier car il a l'air de deconner :/
local function DrawCountDown(n)
        SetTextFont( 7 )
        SetTextProportional(0)
        SetTextScale( 3.0989999999999, 3.0989999999999 )
        N_0x4e096588b13ffeca(0)
        SetTextColour( 255, 255, 255, 255 )
        SetTextDropShadow(0, 0, 0, 0,255)
        SetTextEdge(5, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry( "STRING" )
        AddTextComponentString( n )
        DrawText( 0.5, 0.5 )
end


local function CountDown3()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if GetGameTimer() < LastPress3 + 1000 then
                DrawCountDown("3")
            end
        end
    end)
end

local function CountDown2()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if GetGameTimer() < LastPress2 + 1000 then
                DrawCountDown("2")
            end
        end
    end)
end

local function CountDown1()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if GetGameTimer() < LastPress1 + 1000 then
                DrawCountDown("1")
            end
        end
    end)
end

local function CountDownGo()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if GetGameTimer() < LastPressGo + 1000 then
                DrawCountDown("Go")
            end
        end
    end)
end

--Le serveur envoie le top depart quand tous les joueurs sont pret
RegisterNetEvent('hp:startRun')
AddEventHandler('hp:startRun', function(blipNumber)
    Citizen.Wait(500)
    --enlever l'image du chargement
    N_0x10d373323e5b9c0d()
        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
            FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)),  true) -- Bloque la voiture du joueur
--Affichage du Blip sur la map
            posNumber = blipNumber
            arrPos = chekPointHP[blipNumber]
        --        Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(arrBlip))
            arrBlip = AddBlipForCoord(arrPos[1], arrPos[2], arrPos[3])
            SetBlipSprite(arrBlip, 38)
            SetBlipRoute(arrBlip, true)
            SetBlipAsShortRange(arrBlip, false)
--Affichage du Blip sur la map

--Compte a rebours
            LastPress3 = GetGameTimer()
            CountDown3()
            Wait(1000)
            LastPress2 = GetGameTimer()
            CountDown2()
            Wait(1000)
            LastPress1 = GetGameTimer()
            CountDown1()
            Wait(1000)
            LastPressGo = GetGameTimer()
            CountDownGo()
            --LastPress1 = 0
            --LastPress2 = 0
            --LastPress3 = 0
            --LastPressGo = 0
--Compte a rebours

            FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)),  false) -- Débloque la voiture du joueur
            SetPlayerWantedLevel(PlayerId(), wantedLevel, false) -- Met le niveau de recherche à 5
            SetPlayerWantedLevelNow(PlayerId(), false) -- Applique le niveau de recherche maintenant
            SetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetPlayerName(PlayerId())) -- Met le pseudo du joueur comme plaque d'immatriculation
            SetVehicleDoorsLocked(GetVehiclePedIsUsing(GetPlayerPed(-1)), 4) -- Verouille les portes pour que le joueur ne puisse plus sortir de la voiture
            
            DrawMissionText("You are ~h~~y~wanted~w~!!!", 10000)

            runInProgress = true
            inRun = true
        else
            TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^2 Client: t'es pas dans une voiture")
        end

end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        --Des que le joueur appuie sur la commande pour sauter "Space" ou "X" sur une manette, les pneus sont reparé. Ne fonctionne que si le joueur est dans un vehicule
        if IsControlJustPressed(1,203) then
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                if fixTires > 0 then
                    SetVehicleTyreFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)),  0)
                    SetVehicleTyreFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)),  1)
                    SetVehicleTyreFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)),  2)
                    SetVehicleTyreFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)),  3)
                    SetVehicleTyreFixed(GetVehiclePedIsUsing(GetPlayerPed(-1)),  4)
                    fixTires = fixTires - 1
                    TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^2 Il te reste "..fixTires.." réparation possible")
                else
                    TriggerEvent('chatMessage', '', { 0, 0, 0 }, "^2 Tu n'as plus de réparation!")
                end
            end
        end


        --Des que le joueur est mort
        if IsPedFatallyInjured(PlayerPedId()) then
--           bigBoom = GetPlayersLastVehicle()
            Wait(500)
            AddExplosion(GetEntityCoords(GetPlayerPed(-1)), 6, 0.5, true, false, 0.5)
            --ExplodeVehicle(bigBoom, true, true)
--           NetworkExplodeVehicle(bigBoom,  true,  true,  false)
            EndScreen("Tu t'es fait eu!!", "DeathFailOut") --Determine l'ecran de fin
            SetBlipSprite(arrBlip, 39) --Efface le point d'arrivé
            endScreen = true --Fait afficher l'ecran de fin
            inRun = false --met le joueur en mode "plus dans la course"
            ready = false --il n'est plus pret non plus
            fixTires = 2 --remet ses reparation de pneus a 2
            Wait(2500)
            TriggerServerEvent('hp:plyDead') --envoie au serveur que le joueur est mort
            Wait(1000)
            endScreen = false --arrete d'afficher l'ecran de fin
        end
--        if ( runInProgress and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and not spectate ) then
--            SetEntityHealth(GetPlayerPed(-1),  0) --Le joueur est tué s'il n'est pas dans une voiture alors qu'une course est en cours
--        end
        if inRun then 
            local plyPos = GetEntityCoords(GetPlayerPed(-1))
            SetPlayerWantedLevel(PlayerId(), wantedLevel, false) -- Met le niveau de recherche à 5
            SetPlayerWantedLevelNow(PlayerId(), false) -- Applique le niveau de recherche maintenant
            SetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetPlayerName(PlayerId())) -- Met le pseudo du joueur comme plaque d'immatriculation
            SetVehicleDoorsLocked(GetVehiclePedIsUsing(GetPlayerPed(-1)), 4) -- Verouille les portes pour que le joueur ne puisse plus sortir de la voiture
            if GetDistanceBetweenCoords(plyPos.x, plyPos.y ,plyPos.z, arrPos[1], arrPos[2], arrPos[3], true) < 4.0001 then --des que le joueur arrive a moins de 4m de ces cooredonnées
                EndScreen("Tu as fini! Bravo!", "SuccessNeutral") --Determine l'ecran de fin
                TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsUsing(GetPlayerPed(-1)), 0) --Le joueur sors de la voiture
                DrawMissionText("Vous êtes ~h~~y~arrivé~w~!!!", 10000) 
                FreezeEntityPosition(GetPlayerPed(-1),  true) -- Paralyse le joueur
                SetPlayerWantedLevel(PlayerId(), 0, false) -- Met le niveau de recherche à 0
                SetPlayerWantedLevelNow(PlayerId(), false) -- Applique le niveau de recherche maintenant-
                SetBlipSprite(arrBlip, 39)
                score = score + wantedLevel
                inRun = false
                ready = false
                endScreen = true
                fixTires = 2
                Wait(2000)
                
                TriggerServerEvent('hp:plyArrived', score) --envoie au serveur que le joueur est arrivé
                endScreen = false
--                local lastVeh = GetVehiclePedIsIn(GetPlayerPed(-1),  true)
--                DeleteVehicle(lastVeh)
            end
            if not inRun then
                FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)),  true) -- Bloque la voiture du joueur
            end
            if runInProgress then
                DrawMarker(1, arrPos[1], arrPos[2], arrPos[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0, 8.0, 100.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0) --tant que le joueur n'est pas arivé, affiché ça dans le jeux
            end
        end
    end
end)

--le serveur envoie au client qu'il n'y a plus de course en cours
RegisterNetEvent('hp:endRun')
AddEventHandler('hp:endRun', function()
    runInProgress = false
end)

--Le serveur envoie au joueur qu'il doit etre specateur car une course est en cours a son arrivé
RegisterNetEvent('hp:joinSpectate')
AddEventHandler('hp:joinSpectate', function()
    runInProgress = true
    inRun = false
    spectatePlayer()
end)