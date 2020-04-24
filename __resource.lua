resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description ' Police Count Script'

version '0.0.1'

server_scripts {
	'server/main.lua', 
	'config.lua'
}

client_scripts {
	'client/main.lua', 
	'config.lua'
}

server_exports {
	'GetPoliceForce' 
}

dependencies {
	'es_extended'
}
