local playerCount = 0
local list = {}
local playerReady = 0
local runFinish = 0
local runner = 0
local endOfRun = 0
local setPosSrv = math.random(1, 8)

RegisterServerEvent('playerActivated')
AddEventHandler('playerActivated', function()
  if not list[source] then
    playerCount = playerCount + 1
    list[source] = true
  end
  if playerReady ~= playerCount and playerCount ~= runner  then
    TriggerClientEvent('inProgress', source)
  end
end)

RegisterServerEvent('plyReady')
AddEventHandler('plyReady', function()
    playerReady = playerReady + 1
    print(playerReady.."/"..playerCount.." prêt(s)")
    TriggerClientEvent("chatMessage", -1, '', { 0, 0, 0 }, "^1* "..playerReady.."/^2"..playerCount.."^1 prêt(s)")
    runner = runner + 1
    if playerReady >= playerCount or playerReady == playerCount then
      TriggerClientEvent("chatMessage", -1, '', { 0, 0, 0 }, "^2* Tout le monde est prêt!")
      TriggerClientEvent('startRun', -1)
      setPosSrv = math.random(1, 8)
      TriggerClientEvent('setCheckPos', -1, setPosSrv)
      print('Nouveau Checkpoint Numero: '..setPosSrv)
      print("Tout le monde est prêt! Go!")
    end
end)

RegisterServerEvent('noPlayerAlive')
AddEventHandler('noPlayerAlive', function()
    if runner == 0 then
      TriggerClientEvent('noOnePlayerAlive')
    end
  end)

RegisterServerEvent('endRun')
AddEventHandler('endRun', function()
  if list[source] then
    runFinish = runFinish + 1
    if runFinish == playerCount then
      playerReady = 0
      runner = runner -1
--      Wait(3000)
      TriggerClientEvent('notInProgress', source)
      if runner <= 1 then
        TriggerClientEvent('noOnePlayerAlive')
      end
--      TriggerClientEvent('restartRun')
    end
  end
end)

AddEventHandler('playerDropped', function()
  if list[source] then
    playerCount = playerCount - 1
    list[source] = nil
  end
end)

AddEventHandler('playerConnecting', function(name, setReason)
  print('Connecting: ' .. name)

  if playerCount >= 24 then
    print('Full. :(')

    setReason('This server is full (past 24 players).')
    CancelEvent()
  end
end)