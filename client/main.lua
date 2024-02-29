local QBCore = exports['qb-core']:GetCoreObject()

local ox_inventory = exports.ox_inventory

local disabledCotrols = {1,2,106}

RegisterCommand('pausa', function()
	menu()
end)

function menu()	
	QBCore.Functions.TriggerCallback('getPlayerInfos', function(dati)
		TriggerEvent('qb-hud:client:hud', false)
        TriggerEvent('horde_logo:show', false)
		TriggerScreenblurFadeIn(300)
		SetNuiFocus(true, true)
		exports['qb-smallresources']:addDisableControls(disabledCotrols)
		SendNUIMessage({
			action = 'show',
			data = {
			nome = dati,
			},
		})	
		
	end)
end

local map_looping = false

local function map_loop()
    Citizen.CreateThread(function()
		ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
		Wait(100)
		PauseMenuceptionGoDeeper(0)
        while map_looping do
            Citizen.Wait(0)
            if IsControlJustPressed(0, 177) then -- Input ID 177 che capta BACKSPACE / ESC / RIGHT MOUSE BUTTON come input da usare per chiudere, in questo caso, il menu
				TriggerEvent('riprendi')
				ExecuteCommand('e c')
                break
            end
        end
    end)
end

Citizen.CreateThread(function()
	while true do
	    Wait(0)
	    if (IsControlJustPressed(0, 322)) then
			if IsPauseMenuActive() then 
				ExecuteCommand('e c')
			elseif not IsPedFalling(PlayerPedId()) and not IsPauseMenuActive() then 
				menu()
			end
		end
	end
end)

RegisterNUICallback('execute', function(data, cb)
    SetNuiFocus(false, false)
	exports['qb-smallresources']:removeDisableControls(disabledCotrols)
	TriggerScreenblurFadeOut(300)
    cb()
	
	if data.actionType == 'client_event' then 
		TriggerEvent(data.action)
	elseif data.actionType == 'server_event' then 
		TriggerServerEvent(data.action)	
	end
	
end)

RegisterNUICallback('closeNUI', function(data, cb)
	ExecuteCommand('e c')
    SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
    cb()
end)

-- NUI EVENTS
RegisterNetEvent('report')
AddEventHandler('report', function()
	TriggerScreenblurFadeOut(300)
	ExecuteCommand('report')
end)

RegisterNetEvent('riprendi')
AddEventHandler('riprendi', function()
	TriggerEvent('qb-hud:client:hud', true)
    TriggerEvent('horde_logo:show', true)
	TriggerScreenblurFadeOut(300)
	SetFrontendActive(0)
	map_looping = false
	ExecuteCommand('e c')
end)

RegisterNetEvent('apriMappa')
AddEventHandler('apriMappa', function()
	TriggerEvent('horde_logo:show', false)
	ExecuteCommand('e map')
	map_looping = true
    map_loop()
end)

RegisterCommand('mappa', function(src)
	TriggerEvent('apriMappa', src)
  end, false)
  
RegisterKeyMapping('mappa', 'Apri la Mappa', 'keyboard', 'm')

RegisterNetEvent('apriImpostazioni')
AddEventHandler('apriImpostazioni', function()
	TriggerEvent('qb-hud:client:hud', true)
    TriggerEvent('horde_logo:show', true)
	TriggerScreenblurFadeOut(300)
	ActivateFrontendMenu('FE_MENU_VERSION_LANDING_MENU',0, 1)	
end)

RegisterNetEvent('cambiapg')
AddEventHandler('cambiapg', function()
	TriggerScreenblurFadeOut(300)
	ExecuteCommand('e c')
    ExecuteCommand('relog')
end)

-- Disable ESC and P Default Action
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisableControlAction(0, 199, true) -- 0 sta per "PLAYER CONTROL", 199 e' l'id del Tasto "P", TRUE conferma il disable del tasto menzionato
		DisableControlAction(0, 200, true) -- 0 sta per "PLAYER CONTROL", 200 e' l'id del Tasto "P", TRUE conferma il disable del tasto menzionato
		DisableControlAction(2, 199, true) -- 2 sta per "FRONT END CONTROL", 199 e' l'id del Tasto "P", TRUE conferma il disable del tasto menzionato
		DisableControlAction(2, 200, true) -- 2 sta per "FRONT END CONTROL", 200 e' l'id del Tasto "P", TRUE conferma il disable del tasto menzionato
	end
end)