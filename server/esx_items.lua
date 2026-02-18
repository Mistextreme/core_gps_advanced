-- ============================================================
--  core_gps_advanced | ESX Items & ox_inventory Hooks
--  • Registers core_gps_a as a usable item via ESX
--  • Hooks ox_inventory add/remove events so the client
--    receives itemAdded / itemRemoved exactly as before
-- ============================================================

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

-- ============================================================
--  Usable item registration
--  When a player "uses" the GPS from their inventory the
--  item's ox_inventory metadata is forwarded to the client
--  wrapped in the same shape QBCore used ({info: {gps_id}}).
-- ============================================================

ESX.RegisterUsableItem(Config.ItemName, function(source, item)
    -- item.metadata is the ox_inventory metadata table
    local metadata = (item and item.metadata) or {}
    TriggerClientEvent('core_gps:client:useItem', source, {
        name  = Config.ItemName,
        info  = metadata   -- metadata.gps_id mirrors QBCore item.info.gps_id
    })
end)

-- ============================================================
--  ox_inventory server-side hooks
--  Fire the same client events the original QBCore code used
--  (core_gps:client:itemAdded / itemRemoved) so cl_gps.lua
--  does not need an equivalent of QBCore:Client:ItemBox.
-- ============================================================

exports.ox_inventory:registerHook('addItem', function(payload)
    if payload.item and payload.item.name == Config.ItemName then
        local metadata = (payload.item.metadata) or {}
        TriggerClientEvent('core_gps:client:itemAdded', payload.source, {
            name = Config.ItemName,
            info = metadata
        })
    end
    return true   -- returning true allows the action to proceed
end)

exports.ox_inventory:registerHook('removeItem', function(payload)
    if payload.item and payload.item.name == Config.ItemName then
        -- After removal check server-side whether the player
        -- still owns at least one GPS device; if not, clear client.
        -- We use a short defer so ox_inventory finishes the removal first.
        local src = payload.source
        SetTimeout(200, function()
            local remaining = exports.ox_inventory:GetItem(src, Config.ItemName, nil, false)
            if not remaining or remaining.count == 0 then
                TriggerClientEvent('core_gps:client:itemRemoved', src)
            end
        end)
    end
    return true
end)
