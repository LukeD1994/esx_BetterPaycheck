# esx_BetterPaycheck
 
This is NOT a script! You can not use this on it's own. This is a basic easy package to cover numerous changes for PlumeESX based servers and the scripts contained within ESX so that you can achieve a better paycheck system.

BetterPaycheck alters your PlumeESX based server scripts so that, instead of getting paychecks based on a simple interval, you will get a paycheck at the end of your work shift based on the hours you worked!

# Installation
1. Drag and drop the [esx] folder into your server/resources/ folder. This will ask if you want to overwrite existing files. Accept.
2. The folders are set out so that it will only replace the files it needs to in order to make the better paycheck system work
3. Import the SQL file into your database, this will create two columns in the "users" table. "clockin" and "clockoff".

IMPORTANT!
You will NEED to change any other jobs which do not use the esx_duty script. You have two options:
1) Alter the job's script to make use of esx_duty
2) Manually add the code snippets required to make use of the better paycheck system.

# Credits
OfficialLukeD - For these script changes
The folks behind PlumeESX and ESX

# Dependancies
PlumeESX (ESX v1 final, aka 1.2.0)
esx_duty

# Code changes
This script changes the paycheck inside es_extended, the esx_duty scripts and other files in order to make paychecks more advanced.
