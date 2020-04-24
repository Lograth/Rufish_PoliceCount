local PoliceForce = {}  -- Main table for Holding the Police on the Server
ESX = nil


-- Basic Check for ESX 
function checkESX()
    if ESX == nil then 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
    end 
end

-- Makes sure to Load Police count when either the Server Reboots, or the Resource is restarted
-- Resourse Name is the Resource being started

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return -- Exit out of Function if the Resource Started is not the current Resource
    end 
   -- printpolicecount() -- Debug Print
    rebuildPolice() 
   -- printpolicecount() -- Debug Print
  end)

  -- Public Call function for other Resources.
  -- Returns the Table full of the Police on the Server
AddEventHandler('rufish_PoliceCount:GetPoliceForce', function(cb) 
	cb(PoliceForce)
end)

-- Function for Returning the Police Force Table
function GetPoliceForce() 
    return PoliceForce
end 


-- Removes a Player from the Police table when they drop from the Server, if they were a  Police officer
-- Reason is default variable for this event, is not used in the Event Below
AddEventHandler('playerDropped', function(reason)
    local _source = source  
	local _player = ESX.GetPlayerFromId(_source)
    if _player and _player.job then 
        if (_player.job.name == 'police') then
            removePolice(_source)
        end 
    else
        rebuildPolice()
    end 
end)

-- When Player Logs onto the Server, if they are Police, then this function will add them to the PoliceForce Table
-- source is the PlayerID that just loaded into the game
AddEventHandler('esx:playerLoaded', function(source)
    local _source = source 
    checkESX()  
	local _player = ESX.GetPlayerFromId(_source)
    if _player and _player.job then 
        if (_player.job.name == 'police') then
            addPolice(_source)
        end 
    else
        rebuildPolice()
    end  
end)

-- Test Function for Printing the Count of the Number of Police in the PoliceForce Table
function printpolicecount() 
    count = 0
    for k,v in pairs(PoliceForce) do
        count = count + 1
    end
    print("Police Count: " .. count)
end
 
-- Function Called From Client Side after a Person's Job Changes
-- If they Are now a Police, then we add them to the PoliceForce Table
-- If they are not Police then we remove them from the PoliceForce Table.  If they were in it
RegisterServerEvent('rufish_PoliceCount:PlayerJobChange')
AddEventHandler('rufish_PoliceCount:PlayerJobChange', function() 
    local _source = source  
    local _player = ESX.GetPlayerFromId(_source)
    if _player and _player.job then 
        if _player.job.name == 'police' then
            addPolice(_source)
        else
            removePolice(_source)
        end 
    else
        rebuildPolice()
    end
end)

--Function for Adding a Player to the PoliceForce Table
-- If the Player is not already in the PoliceForce table, then we add them to it
-- sourceval is the PlayerID to add to the Table
function addPolice(sourceval)
    local _source = sourceval 
    local NotInList = true 

    for k, police in pairs(PoliceForce) do
        if police.PoliceSource == _source then
            NotInList = true 
            break
        end
    end 
    if NotInList then  
        table.insert(PoliceForce, {PoliceSource = _source} )
    end 
end


-- Function for Removing a Player from the PoliceForce Table
-- Creates a Temp Table from PoliceForce, if the sourceVal (PlayerID to remove from Table) Is in the PoliceForce Table
-- then it does not add that person to the Temp Table
-- End of the Function sets PoliceForce = to the temp table
function removePolice(sourceval)
    local _source = sourceval
    local temppolice = {}

    for k, police in pairs(PoliceForce) do
        if police.PoliceSource ~= _source then
            table.insert(temppolice, police )
        end
    end 
    PoliceForce = temppolice 
end


-- Catch All Function if something went wrong.
-- This function will loop through all the players on the server 
-- If they are police we add them to the PoliceForce Table
function rebuildPolice()
    checkESX()
    local temppolice = {} 
    local xPlayers = ESX.GetPlayers() 
    for i=1, #xPlayers, 1 do 
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])  
        if xPlayer.job.name == 'police' then
            table.insert(temppolice,  {PoliceSource = xPlayers[i]} )
        end  
    end 
    PoliceForce = temppolice 
end
