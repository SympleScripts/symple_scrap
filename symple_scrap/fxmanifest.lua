fx_version 'cerulean'
game 'gta5'
author 'Symple Scripts'
description 'Symple Scrap - Scrapyard Material Collection System'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared.lua',
    'config.lua'
}

client_script 'client.lua'
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'ox_target',
    'oxmysql'
}