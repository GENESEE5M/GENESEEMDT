fx_version 'adamant'
game 'gta5'

author 'convert JnnDougg#7481'
description 'MDT'

ui_page 'html/index.html'

files {
	'html/*',
	'html/**/*',
	'html/**/**/*',
	'html/**/**/**/*',
}

client_scripts {
	'@vrp/lib/utils.lua',
	'config.lua',
	'client/client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@vrp/lib/utils.lua',
    'config.lua',
    'server/server.lua',
}