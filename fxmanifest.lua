fx_version 'cerulean'
game 'gta5'

description 'core_gps - Location Marker Management System (ESX-Legacy Edition)'
author 'ChrisNewmanDev'
version '1.0.4'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/esx_bridge.lua',   -- ESX init, GetGPSItem(), CountGPSItems(), QBCompat
    'client/cl_gps.lua'
}

server_scripts {
    'server/esx_items.lua',    -- ESX.RegisterUsableItem + ox_inventory hooks
    'server/sv_gps.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'version.json'
}

lua54 'yes'