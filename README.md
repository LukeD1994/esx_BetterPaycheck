# esx_BetterPaycheck
 
This is NOT a script! You can not use this on it's own. This is a basic easy package to cover numerous changes for PlumeESX based servers and the scripts contained within ESX so that you can achieve a better paycheck system.

BetterPaycheck alters your PlumeESX based server scripts so that, instead of getting paychecks based on a simple interval, you will get a paycheck at the end of your work shift based on the hours you worked!

# Features
- Advanced paycheck system for end of shift payments based on actual hours worked
  - Unemployment benefits paid by means of normal salary interval
  - Fully compatible with societies and accounting
- Fully integrated clocking in and out system, easily incorporated into any job script with two simple events
- Sneaky player protection methods to stop players disconnecting and getting paid while offline
- Prevents players disconnecting and triggering a paycheck if they haven't actually worked

# Installation
1. Drag and drop the [esx] folder into your server/resources/ folder. This will ask if you want to overwrite existing files. Accept.
2. The folders are set out so that it will only replace the files it needs to in order to make the better paycheck system work
3. Import the SQL file into your database, this will create three columns in the "users" table. "clockin", "clockoff" and "working".

IMPORTANT!
You will NEED to change any other jobs which do not use the esx_duty script. You have two options:
1) Alter the job's script to make use of esx_duty
2) Manually add the code snippets required to make use of the better paycheck system.

# Examples
```lua
JobClient.Lua
-- This event will automatically call the clock out event, log their end time and calculate their paycheck
TriggerServerEvent('esx_paycheck:ClockOut')
-- This event will automatically call the clock in event and log their start time, and set them as working
TriggerServerEvent('esx_paycheck:ClockIn')
```
## For esx_duty based roles, you will need to do the following
1) Client/Main.lua
```lua

-- Take the below example and place a copy of it in the client/main.lua file. Then change the names for the new job you're adding
-- All you need to change is the references to "fire", i.e "fire_duty" becomes "newJob_duty", etc
if CurrentAction == 'fire_duty' then
                    if PlayerData.job.name == 'fire' or PlayerData.job.name == 'offfire' then
                        TriggerServerEvent('duty:fire')
                        if PlayerData.job.name == 'fire' then
                            sendNotification(_U('offduty'), 'success', 2500)
                            TriggerServerEvent('esx_paycheck:ClockOut')
                            Wait(1000)
                        else
                            sendNotification(_U('onduty'), 'success', 2500)
                            TriggerServerEvent('esx_paycheck:ClockIn')
                            Wait(1000)
                        end
                    else
                        sendNotification(_U('notfire'), 'error', 5000) 
                        -- "notfire" here is a translated entry, look inside "translations/en.lua" and add a new one for "notMyNewJob"
                        Wait(1000)
                    end
                end
```
2) Server/main.lua
```lua
-- Same as before, replace anything refering it "fire" with "yourjobhere"
RegisterServerEvent('duty:fire')
AddEventHandler('duty:fire', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

    -- IMPORTANT: If your job has more than 3 grades to it in your database, you'll need to add extra entries for those too!
    if xPlayer.job.name == 'fire' and xPlayer.job.grade == 1 then
        xPlayer.setJob('offfire', 1)
    elseif xPlayer.job.name == 'fire' and xPlayer.job.grade == 2 then
        xPlayer.setJob('offfire', 2)
    elseif xPlayer.job.name == 'fire' and xPlayer.job.grade == 3 then
        xPlayer.setJob('offfire', 3)
    end

    if xPlayer.job.name == 'offfire' and xPlayer.job.grade == 1 then
        xPlayer.setJob('fire', 1)
    elseif xPlayer.job.name == 'offfire' and xPlayer.job.grade == 2 then
        xPlayer.setJob('fire', 2)
    elseif xPlayer.job.name == 'offfire' and xPlayer.job.grade == 3 then
        xPlayer.setJob('fire', 3)
    end
end)
```

# Credits
- OfficialLukeD - For these script changes
- The folks behind PlumeESX and ESX

# Dependancies
PlumeESX (ESX v1 final, aka 1.2.0)
esx_duty

# Code changes
This script changes the paycheck inside es_extended, the esx_duty scripts and other files in order to make paychecks more advanced.
