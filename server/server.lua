local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

GENESEE = {}
Tunnel.bindInterface('GENESEEMDT', GENESEE)
Proxy.addInterface('GENESEEMDT', GENESEE)

RegisterServerEvent('GENESEEMDT:search-plate')
AddEventHandler('GENESEEMDT:search-plate', function(plate)
    MySQL.Async.fetchAll("SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id", {
        ['@user_id'] = plate
    }, function(result)
        if (result[1] ~= nil) then
            MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE user_id = @user_id", {
                ['@user_id'] = result[1].user_id
            }, function(result2)
                if (result2[1] ~= nil) then
                    TriggerClientEvent('GENESEEMDT:showdataplate', -1, result2[1].registration, result[1].vehicle,
                        result2[1].name, result2[1].firstname)
                else
                    TriggerClientEvent('GENESEEMDT:showdateplateNotFound', -1)
                end
            end)
        else
            TriggerClientEvent('GENESEEMDT:showdateplateNotFound', -1)
        end
    end)
end)

RegisterServerEvent('GENESEEMDT:search-players')
AddEventHandler('GENESEEMDT:search-players', function(search)
    MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE CONCAT(name, ' ', firstname) LIKE @search", {
        ['@search'] = '%' .. search .. '%'
    }, function(result)
        if (result ~= nil) then
            TriggerClientEvent('GENESEEMDT:returnsearch', -1, result)
        else
            TriggerClientEvent('GENESEEMDT:noresults', -1)
        end
    end)
end)

RegisterServerEvent('GENESEEMDT:add-cr')
AddEventHandler('GENESEEMDT:add-cr', function(data)
    local source = source
    local user_id = vRP.getUserId(source)
    MySQL.Async.execute(
        "INSERT INTO GENESEE_criminal_records SET reason = @reason, fine = @fine, time = @time, user_id = @user_id, officer_id = @officer_id",
        {
            ['@reason'] = data.reason,
            ['@fine'] = data.fine,
            ['@time'] = data.time,
            ['@user_id'] = data.playerid,
            ['@officer_id'] = user_id
        }, function(result)
            if (result ~= nil) then

            end
        end)
end)

RegisterServerEvent('GENESEEMDT:add-note')
AddEventHandler('GENESEEMDT:add-note', function(data)
    MySQL.Async.execute("INSERT INTO GENESEE_epc_notes SET title = @title, content = @content, user_id = @user_id", {
        ['@title'] = data.title,
        ['@content'] = data.content,
        ['@user_id'] = data.playerid
    }, function(result)
        if (result ~= nil) then

        end
    end)
end)

RegisterServerEvent('GENESEEMDT:delete_note')
AddEventHandler('GENESEEMDT:delete_note', function(note)
    noteId = note.id
    MySQL.Async.fetchAll("SELECT id FROM GENESEE_epc_notes WHERE id = @id", {
        ['@id'] = noteId
    }, function(result2)
        if result2[1] == nil then
            TriggerClientEvent('GENESEEMDT:note_deleted', -1)
        else
            TriggerClientEvent('GENESEEMDT:note_not_deleted', -1)
        end
    end)
end)

RegisterServerEvent('GENESEEMDT:delete_cr')
AddEventHandler('GENESEEMDT:delete_cr', function(cr)
    crid = cr
    MySQL.Async.fetchAll("SELECT id FROM GENESEE_criminal_records WHERE id = @id", {
        ['@id'] = crid.id
    }, function(result2)
        if result2[1] == nil then
            TriggerClientEvent('GENESEEMDT:cr_deleted', -1)
        else
            TriggerClientEvent('GENESEEMDT:cr_not_deleted', -1)
        end
    end)
end)

RegisterServerEvent('GENESEEMDT:get-note')
AddEventHandler('GENESEEMDT:get-note', function(playerid)
    MySQL.Async.fetchAll("SELECT * FROM GENESEE_epc_notes WHERE user_id = @user_id", {
        ['@user_id'] = playerid
    }, function(result)
        TriggerClientEvent('GENESEEMDT:show-notes', -1, result)
    end)
end)

RegisterServerEvent('GENESEEMDT:get-cr')
AddEventHandler('GENESEEMDT:get-cr', function(playerid)
    MySQL.Async.fetchAll("SELECT * FROM GENESEE_criminal_records WHERE user_id = @user_id", {
        ['@user_id'] = playerid
    }, function(result)
        if (result[1] ~= nil) then
            for key, value in pairs(result) do
                result[key] = value
                MySQL.Async.fetchAll("SELECT * FROM criminal_records WHERE user_id = @user_id", {
                    ['@user_id'] = playerid
                }, function(result)
                    --                                result['officer'] = result[1].firstname .. ' ' .. result[1].lastname
                end)
            end
            TriggerClientEvent('GENESEEMDT:show-cr', -1, result)
        end
    end)
end)

RegisterServerEvent('GENESEEMDT:get-license')
AddEventHandler('GENESEEMDT:get-license', function(playerid)
    MySQL.Async.fetchAll("SELECT driverlicense FROM vrp_user_identities WHERE user_id = @user_id", {
        ['@user_id'] = playerid
    }, function(result)
        if (result[1] ~= nil) then
            TriggerClientEvent('GENESEEMDT:show-license', -1, result)
        end
    end)
end)

RegisterServerEvent('GENESEEMDT:get-bolos')
AddEventHandler('GENESEEMDT:get-bolos', function()

    MySQL.Async.fetchAll("SELECT * FROM GENESEE_epc_bolos order by id", {}, function(result)
        if (result[1] ~= nil) then
            TriggerClientEvent('GENESEEMDT:show-bolos', -1, result)
        end
    end)
end)

RegisterServerEvent('GENESEEMDT:add-bolo')
AddEventHandler('GENESEEMDT:add-bolo', function(data)
    MySQL.Async.execute(
        "INSERT into GENESEE_epc_bolos SET name = @name, lastname = @lastname, apperance = @apperance, type_of_crime = @type_of_crime, fine = @fine ",
        {
            ['@name'] = data.name,
            ['@lastname'] = data.lastname,
            ['@apperance'] = data.apperance,
            ['@type_of_crime'] = data.type_of_crime,
            ['@fine'] = data.fine
        }, function(result)
            MySQL.Async.fetchAll("SELECT * FROM epc_bolos order by id desc", {}, function(result)
                if (result[1] ~= nil) then
                    TriggerClientEvent('GENESEEMDT:show-bolos', -1, result)
                end
            end)
        end)
end)

RegisterServerEvent('GENESEEMDT:delete-bolo')
AddEventHandler('GENESEEMDT:delete-bolo', function(data)
    id = data.id
    MySQL.Async.execute("DELETE FROM GENESEE_epc_bolos WHERE id = @id", {
        ['@id'] = id
    }, function(result)
        MySQL.Async.fetchAll("SELECT id FROM epc_bolos WHERE id = @id", {
            ['@id'] = id
        }, function(result2)
            if result2[1] == nil then
                TriggerClientEvent('GENESEEMDT:bolo-deleted', -1)
            else
                TriggerClientEvent('GENESEEMDT:bolo-not-deleted', -1)
            end
        end)
    end)
end)
