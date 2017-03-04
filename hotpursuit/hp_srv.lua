local playerCount = 0
local list = {}
local playerDead = 0
local playerFinish = 0
local playerReady = 0
local runningInProgress = false
local placing = 0
local runner = {}
local scoret = {ply = {}, points = {} } 


--Quand le jeux est chargé, le serveur verifie s'il y a une course en cours: si oui, il passe le joueur en spectateur, sinon, il le fait choisir une voiture
RegisterServerEvent('hp:firstJoin')
AddEventHandler('hp:firstJoin', function()
  	if not list[source] then
    	playerCount = playerCount + 1
    	list[source] = true
    	print("nombre de joueur: "..playerCount)
  	end
  	if runningInProgress then
    	TriggerClientEvent('hp:joinSpectate', source)
	else
		TriggerClientEvent('hp:selectCar', source)
  	end
end)

--quand le joueur a choisi un vehicule le faire se TP avec son vehicule sur la ligne de depart
RegisterServerEvent('hp:carSelected')
AddEventHandler('hp:carSelected', function()
--	Wait(500)
	placing = playerReady + 1
	TriggerClientEvent('hp:startingBlock', source, placing)
end)

--Ajouter un joueur pret des qu'un joueur a choisis un vehicule et verifie s'il y a autant de joueurs pret que de joueur present
--S'il y a autant de joueurn pret que de joueur present, alors le jeux lance la course
RegisterServerEvent('hp:plyReady')
AddEventHandler('hp:plyReady', function()
  	if not runner[source] then
		runner[source] = true
  	end
  	TriggerClientEvent('hp:moreRunner', -1, source)
	playerReady = playerReady + 1
	print(playerReady)
	TriggerClientEvent("chatMessage", -1, '', { 0, 0, 0 }, "^1* "..playerReady.."/^2"..playerCount.."^1 prêt(s)")
	if playerReady == playerCount then
		print("Go Go Go")
		setPosSrv = math.random(1, 8)
		TriggerClientEvent('hp:startRun', -1, setPosSrv)
		runningInProgress = true
	end
end)

--Des qu'un joueur est arrivé, le serveur ajoute + 1 au nombre de joueurs arrivé
--s'il n'y a plus personne en course, alors envoyer que la course est fini aux joueurs
RegisterServerEvent('hp:plyArrived')
AddEventHandler('hp:plyArrived', function(score)
	playerFinish = playerFinish + 1
	TriggerClientEvent("chatMessage", -1, '', { 0, 0, 0 }, "^1* "..GetPlayerName(source).." est arrivé!!!!")
	if runner[source] then
		runner[source] = nil
  	end
  	table.insert(scoret.ply, 1, GetPlayerName(source))
  	table.insert(scoret.points, 1, score)
  	TriggerClientEvent('hp:lessRunner', -1, source)
  	for i = 1, #scoret do
  		TriggerClientEvent('hp:plyScore', -1, scoret.points[i], scoret.ply[i])
  	end
	if #runner == 0 then
		TriggerClientEvent('hp:endRun', -1)
		playerDead = 0
		playerReady = 0
		playerFinish = 0
		runningInProgress = false
--		Wait(100)
		TriggerClientEvent('hp:selectCar', -1)
	else
		TriggerClientEvent('hp:joinSpectate', source)
	end
end)

--Des qu'un joueur est mort, le serveur ajoute + 1 au nombre de joueurs mort
--s'il n'y a plus personne en course, alors envoyer que la course est fini aux joueurs
RegisterServerEvent('hp:plyDead')
AddEventHandler('hp:plyDead', function()
	playerDead = playerDead + 1
	TriggerClientEvent("chatMessage", -1, '', { 0, 0, 0 }, "^1* "..GetPlayerName(source).." s'est fait tuer!!!")
	print(source.." est mort")
	if runner[source] then
		runner[source] = nil
  	end
  	TriggerClientEvent('hp:lessRunner', -1, source)
	if #runner == 0 then
		TriggerClientEvent('hp:endRun', -1)
		TriggerClientEvent("chatMessage", -1, '', { 0, 0, 0 }, "^1* Nombre de joueur mort: "..playerDead)
		playerDead = 0
		playerReady = 0
		playerFinish = 0
		runningInProgress = false
		TriggerClientEvent("chatMessage", -1, '', { 0, 0, 0 }, "^1* Nombre de joueur mort: "..playerDead)
		TriggerClientEvent('hp:selectCar', -1)
	else
		TriggerClientEvent('hp:joinSpectate', source)
	end
end)

RegisterServerEvent('hp:observedDead')
AddEventHandler('hp:observedDead', function()
	TriggerClientEvent('hp:joinSpectate', source)
end)

------------------------------------------------------------------------------------------

--Quand un joueur quitte le jeux, enlever 1 au nombre de joueur present sur le serveur
AddEventHandler('playerDropped', function()
	if list[source] then
		playerCount = playerCount - 1
		list[source] = nil
		print("nombre de joueur: "..playerCount)
		
	end
	if runner[source] then
		runner[source] = nil
		print("nombre de runner: "..#runner)
  	end
	if #runner == 0 then
		runningInProgress = false
		TriggerClientEvent('hp:endRun', -1)
		TriggerClientEvent('hp:selectCar', -1)
	end
end)

--Empeche simplement que trop de joueurs de connectent
AddEventHandler('playerConnecting', function(name, setReason)
	print('Connecting: ' .. name)

	if playerCount >= 24 then
		print('Full. :(')
		setReason('This server is full (past 24 players).')
		CancelEvent()
	end
end)