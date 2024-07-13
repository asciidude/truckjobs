fx_version 'cerulean'
game 'gta5'

author 'asciidude'
description 'Truck Jobs'
version '1.0.0'

client_scripts {
    'client.lua',
    'trucklist.lua'
}

server_script 'server.lua'

shared_scripts {
    'config.lua',
    'functions/**.*'
}

-- NUI
ui_page 'nui/index.html'

files {
    'nui/**.*',
    'keylist.json'
}

lua54 'yes'