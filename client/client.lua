local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

GENESEE = Tunnel.getInterface("GENESEEMDT")

local GUI = {}

function OpenCadSystem()
    SendNUIMessage({
        showCadSystem = true
    })
    Wait(250)
    SetNuiFocus(true, true)
end

function CloseCadSystem()
    local playerPed = GetPlayerPed()
    SendNUIMessage({
        showCadSystem = false
    })
    SetNuiFocus(false, false)
    ClearPedTasks(playerPed)
end

RegisterNUICallback('escape', function()
    CloseCadSystem()
end)

RegisterNUICallback('search-plate', function(data)
    TriggerServerEvent('GENESEEMDT:search-plate', data.plate)
end)

RegisterNUICallback('add-cr', function(data)
    TriggerServerEvent('GENESEEMDT:add-cr', data)
end)

RegisterNUICallback('add-note', function(data)
    TriggerServerEvent('GENESEEMDT:add-note', data)
end)

RegisterNUICallback('add-bolo', function(data)
    TriggerServerEvent('GENESEEMDT:add-bolo', data)
end)

RegisterNUICallback('get-cr', function(playerid)
    TriggerServerEvent('GENESEEMDT:get-cr', playerid.playerid)
end)

RegisterNUICallback('get-bolos', function()
    TriggerServerEvent('GENESEEMDT:get-bolos')
end)

RegisterNUICallback('get-note', function(playerid)
    TriggerServerEvent('GENESEEMDT:get-note', playerid.playerid)
end)

RegisterNUICallback('delete_note', function(noteId)
    TriggerServerEvent('GENESEEMDT:delete_note', noteId)
end)

RegisterNUICallback('delete_cr', function(crId)
    TriggerServerEvent('GENESEEMDT:delete_cr', crId)
end)

RegisterNUICallback('delete-bolo', function(boloId)
    TriggerServerEvent('GENESEEMDT:delete-bolo', boloId)
end)

RegisterNUICallback('get-license', function(playerid)
    TriggerServerEvent('GENESEEMDT:get-license', playerid.playerid)
end)

RegisterNUICallback('search-players', function(data)
    TriggerServerEvent('GENESEEMDT:search-players', data.search)
end)

RegisterNetEvent('GENESEEMDT:showdataplate')
AddEventHandler('GENESEEMDT:showdataplate', function(plate, model, firstname, lastname)
    SendNUIMessage({
        plate = plate,
        model = model,
        firstname = firstname,
        lastname = lastname
    })
end)

RegisterNetEvent('GENESEEMDT:showdateplateNotFound')
AddEventHandler('GENESEEMDT:showdateplateNotFound', function()
    SendNUIMessage({
        plate = 'Não encontrado',
        model = '',
        firstname = '',
        lastname = ''
    })
end)

RegisterNUICallback('GENESEEMDT:search-players', function(data)
    TriggerServerEvent('GENESEEMDT:search-players', data.search)
end)

RegisterNetEvent('GENESEEMDT:returnsearch')
AddEventHandler('GENESEEMDT:returnsearch', function(results)
    SendNUIMessage({
        civilianresults = results
    })
end)

RegisterNetEvent('GENESEEMDT:show-cr')
AddEventHandler('GENESEEMDT:show-cr', function(results)
    SendNUIMessage({
        crresults = results
    })
end)

RegisterNetEvent('GENESEEMDT:show-notes')
AddEventHandler('GENESEEMDT:show-notes', function(results)
    SendNUIMessage({
        noteResults = results
    })
end)

RegisterNetEvent('GENESEEMDT:show-license')
AddEventHandler('GENESEEMDT:show-license', function(results)
    SendNUIMessage({
        licenseResults = results
    })
end)

AddEventHandler('GENESEEMDT:show-notes', function(results)
    SendNUIMessage({
        noteResults = results
    })
end)

RegisterNetEvent('GENESEEMDT:note_deleted')
AddEventHandler('GENESEEMDT:note_deleted', function()
    SendNUIMessage({
        note_deleted = true
    })
end)

RegisterNetEvent('GENESEEMDT:note_not_deleted')
AddEventHandler('GENESEEMDT:note_not_deleted', function()
    SendNUIMessage({
        note_not_deleted = true
    })
end)

RegisterNetEvent('GENESEEMDT:cr_deleted')
AddEventHandler('GENESEEMDT:cr_deleted', function()
    SendNUIMessage({
        cr_deleted = true
    })
end)

RegisterNetEvent('GENESEEMDT:cr_not_deleted')
AddEventHandler('GENESEEMDT:cr_not_deleted', function()
    SendNUIMessage({
        cr_not_deleted = true
    })
end)

RegisterNetEvent('GENESEEMDT:show-bolos')
AddEventHandler('GENESEEMDT:show-bolos', function(results)
    SendNUIMessage({
        showBolos = results
    })
end)

RegisterNetEvent('GENESEEMDT:bolo-deleted')
AddEventHandler('GENESEEMDT:bolo-deleted', function()
    SendNUIMessage({
        bolo_deleted = true
    })
end)

RegisterNetEvent('GENESEEMDT:note_not_deleted')
AddEventHandler('GENESEEMDT:bolo-not-deleted', function()
    SendNUIMessage({
        bolo_not_deleted = true
    })
end)

RegisterCommand('lspd', function()
    OpenCadSystem()
end)