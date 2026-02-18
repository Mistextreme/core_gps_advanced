-- ============================================================
--  core_gps_advanced | ESX Bridge
--  Initialises the ESX shared object and exposes helper
--  functions used throughout the client scripts.
--  Requires: es_extended (ESX Legacy), ox_inventory
-- ============================================================

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

-- ============================================================
--  Inventory helpers (ox_inventory client-side cache)
-- ============================================================

--- Returns (found:boolean, item:table|nil)
--- item.info mirrors QBCore-style {gps_id = "..."} so the rest
--- of the client code needs zero changes after calling this.
function GetGPSItem()
    local slots = exports.ox_inventory:Search('slots', Config.ItemName)
    if not slots or #slots == 0 then return false, nil end

    for _, slot in ipairs(slots) do
        if slot and slot.metadata and slot.metadata.gps_id then
            return true, {
                name = slot.name,
                info = slot.metadata   -- .info.gps_id == slot.metadata.gps_id
            }
        end
    end
    return false, nil
end

--- Returns the total number of GPS items in the local inventory.
function CountGPSItems()
    local slots = exports.ox_inventory:Search('slots', Config.ItemName)
    return slots and #slots or 0
end

-- ============================================================
--  Notification wrapper
-- ============================================================

--- Thin wrapper so the rest of the file can keep calling
---   QBCore.Functions.Notify(msg, type)
--- without any changes.
QBCompat = {}
QBCompat.Notify = function(message, ntype)
    -- ESX Legacy native notification
    ESX.ShowNotification(message)
end
