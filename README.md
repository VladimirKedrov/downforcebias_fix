# downforcebias_fix for GTA5

Features:

Fixes the suspension raise from CF_USE_DOWNFORCE_BIAS advanced flag.
Maintains the kerboosting fixes from the flag, stopping the vehicle from rapidly speeding due to bumpy terrain.
Counteracts the suspension height increase from CF_USE_DOWNFORCE_BIAS.


CF_USE_DOWNFORCE_BIAS flag is also known as:
Openwheeler flag,
Kerbfix Flag,
UseDownforceBias,
Advancedflag: 8000000


Requirements:

baseevents resource to be started. Included with CFX default resources.


Incompatabilities:

Any script that uses the "SetVehicleSuspensionHeight" native.


How to use:

Enable the CF_USE_DOWNFORCE_BIAS flag by setting strAdvancedFlags to 08000000 in handling.meta.

strAdvancedFlags is under the section "<SubHandlingData>" if you don't have that line in your handling.meta you can add it by copying the template below.

Make sure that you leave any other lines in the "CCarHandlingData" section alone if you don't know what they do.

    <SubHandlingData>
        <Item type="CCarHandlingData">
            <strAdvancedFlags>08000000</strAdvancedFlags>
        </Item>
    </SubHandlingData>
    
If you want to add other advanced flags together with the CF_USE_DOWNFORCE_BIAS flag replace "08000000" with a number from this tool.

https://adam10603.github.io/GTA5VehicleFlagTool/

Make sure to use the correct flag category in the flag tool.



File is commented should be easy to figure out how it works.

If this was useful for you and you wish to donate.

https://ko-fi.com/vladimirkedrov
