fx_version 'cerulean'
game 'gta5'

author 'Venzy12'
description 'Standalone Evidence Locker with UI, logging, and ACE permissions'
version '2.0.0'

shared_script 'config.lua'

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/utils.lua',
    'server/server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/logo.png'
}
