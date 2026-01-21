fx_version 'cerulean'
game 'gta5'

description 'vCore Shops System'
author 'vCore Development'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.png'
}

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'