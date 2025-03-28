fx_version 'cerulean'
game 'gta5'

description 'Randomised Oxy runs involving AI police responses and randomised local reactions'
author 'Vibrant Resources'
version '1.0'

client_scripts {
	'client/*.lua',
	'menus/*.lua',
}

server_scripts  {
	'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
	'shared/*.lua',
}

lua54 'yes'