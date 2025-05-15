fx_version 'cerulean'
game 'gta5'
author 'Flexiboii'
description 'test'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

dependency '/assetpacks'