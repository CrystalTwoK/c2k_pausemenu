game 'gta5'
fx_version 'cerulean'
lua54 'yes'

author 'Crystal2K'
description 'Pausemenu by Crystal2K'
version "1.0.0"

ui_page 'ui/ui.html'

client_scripts {
	"client/main.lua"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server/main.lua"
}

files {
	'ui/ui.html',
	'ui/css/*.css',
	'ui/app.js',
	'ui/images/*.png',
}