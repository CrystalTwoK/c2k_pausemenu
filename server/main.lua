local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('getPlayerInfos', function(source, cb)
  local xPlayer = QBCore.Functions.GetPlayer(source)
  local name = xPlayer.PlayerData.charinfo.firstname.." "..xPlayer.PlayerData.charinfo.lastname
  cb(name)
end)


-- NUI EVENTS
RegisterNetEvent('quitPlayer')
AddEventHandler('quitPlayer', function()
	DropPlayer(source, 'SEI USCITO DA HORDE')
end)

