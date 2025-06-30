fx_version 'cerulean'
game 'gta5'

author 'Venzy Solutions'
description 'Advanced Bodycam System with IA Mode and Battery Management'
version '1.0.0'

client_scripts {
    'client/overlay.lua',
    'client/battery.lua',
    'client/camera.lua',
    'client/ia.lua',
    'client/controls.lua',
    'client/voice.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/storage.lua',
    'server/permissions.lua'
}

shared_script 'config.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'sounds/on.wav',
    'sounds/off.wav',
    'sounds/lowbattery.wav',
    'sounds/enteria.wav',
    'sounds/exitia.wav'
}
