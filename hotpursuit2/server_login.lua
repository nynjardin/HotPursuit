
-- Custom event gets called when a client joins
RegisterServerEvent('foundation:onPlayerConnect')
AddEventHandler('foundation:onPlayerConnect', function()
	TriggerClientEvent('foundation:playerLog', source, true)
end)
