 

 -- Client Side call back to Server upon Job change
 -- This ensures that when a player changes Jobs Either fired from PD or hired to PD, that the Police count reflects this.
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    TriggerServerEvent('rufish_PoliceCount:PlayerJobChange', source)
end)
