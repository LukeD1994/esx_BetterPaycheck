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

# Credits
- OfficialLukeD - For these script changes
- The folks behind PlumeESX and ESX

# Dependancies
PlumeESX (ESX v1 final, aka 1.2.0)
esx_duty

# Code changes
This script changes the paycheck inside es_extended, the esx_duty scripts and other files in order to make paychecks more advanced.
