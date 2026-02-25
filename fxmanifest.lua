fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

client_scripts {
  'client.lua'
}

files {
  'images/*.png',
  'images/*.webp',
  'images/*.jpg'
}

dependencies {
  'ox_lib'
}
