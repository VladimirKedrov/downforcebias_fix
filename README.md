## What the script does
Fixes the suspension issue while using the CF_USE_DOWNFORCE_BIAS advanced handling flag.
This is so the vehicle can benefit from the flags kerb boosting fixes inherent to the flag, without suffering from the suspension height increasing when driving at high speed.

CF_USE_DOWNFORCE_BIAS flag is also known as:

* Openwheeler flag
* Kerbfix Flag
* UseDownforceBias
* Advancedflag: 8000000

## How the script works
It gathers the vehicle relative coordinates of the suspension bounds when first entering the vehicle. Then compares them to the current raised suspension bounds while creating a offset to apply to the suspension.
This height offset is applied to the suspension compensate for the raise from CF_USE_DOWNFORCE_BIAS leaving the car level as it was when it was stopped.

### Requirements:

baseevents resource to be started, included with CFX default resources.

### Incompatabilities:

Any script that uses the "SetVehicleSuspensionHeight" native.

### How to use:

Enable the CF_USE_DOWNFORCE_BIAS flag by setting strAdvancedFlags to 08000000 in handling.meta.

strAdvancedFlags is under the section SubHandlingData if you don't have that line in your handling.meta you can add it by copying the template below.

Make sure that you leave any other lines in the "CCarHandlingData" section alone if you don't know what they do.

    <SubHandlingData>
        <Item type="CCarHandlingData">
            <strAdvancedFlags>08000000</strAdvancedFlags>
        </Item>
    </SubHandlingData>
    
If you want to add other advanced flags together with the CF_USE_DOWNFORCE_BIAS flag replace "08000000" with a number from this tool.

https://adam10603.github.io/GTA5VehicleFlagTool/

Make sure to use the correct flag category in the flag tool.

After flag is enabled the script will activate after you enter a vehicle.

### Notes

The code is commented and not very complicated should be easy to figure out how it works. If you are having issues contact me at this post or make a github issue.

Licensed GNU GPL v3.0

If this was useful for you and you wish to donate.

https://ko-fi.com/vladimirkedrov

