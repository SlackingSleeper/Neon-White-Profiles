#Make a connection to the operating system that will be used to create popups
$wshell = New-Object -ComObject Wscript.Shell
$ScriptsToBeInstalled=$null
#Finds all PowerShell files that start with "NeonWhiteStartup" or give up if none are found
If(($ScriptsToBeInstalled=Get-Item "NeonWhiteStartup*.ps1" -Exclude "*Installer*") -eq $null){
    $wshell.Popup("No scripts to install.",0,"",0)
    Return
}
If((Get-Item "NeonWhiteStartupModule.psm1") -eq $null){
    $wshell.Popup("NeonWhiteStartupModule.psm1 is required for the scripts to work.",0,"",0)
    Return
}

$NWDir=$null
$obsPath=$null
while(($NWDir = (Get-Process "Neon White" -ErrorAction SilentlyContinue).Path) -eq $null){
    $output = $wshell.Popup("Couldn't find Neon White, please start it if it isn't running and retry.",0,"Script Error",5)
    switch($output){
        #4 is "Retry"
        4{}
        #2 is "Cancel"
        2{Return}#If you can't find the neon white directory give up and go home
    }
}

If($wshell.Popup("Config script to OBS?",0,"",4) -eq 6){
    $obsGiveUp=$false
    while(($obsPath = (Get-Process "obs*" -ErrorAction SilentlyContinue).Path) -eq $null -and -not $obsGiveUp){
        $output = $wshell.Popup("Couldn't find OBS, please start it and retry.",0,"Script Error",5)
        switch($output){
            #4 is "Retry"
            4{}
            #2 is "Cancel"
            2{Break}#If you give up on setting up OBS you can still continue the installation
        }
    }
}
#Copies the script files into the neon white directory
$NWDir=$NWDir | Split-Path -Parent
foreach($file in $ScriptsToBeInstalled){
    Copy-Item "$($file)" -Destination $NWDir
}
Copy-Item NeonWhiteStartupModule.psm1 -Destination $NWDir
#Builds the configuration file
$configHashtable = @{Paths = @{};Cheats=@("Xenon.dll","BoofOfMemes.dll","MikeyMode.dll")}
If($obsPath -ne $null){
    $configHashtable["Paths"]["obsFile"] = $obsPath
    $configHashtable["Paths"]["obsPath"] = $obsPath | Split-Path -Parent
}
#Writes the configuration file
New-Item -Path "$NWDir/UserData/NWStartScriptConfig.json" -Value "$($configHashtable | ConvertTo-Json)" -Force

If(-Not (Test-Path "$NWDir/Mods/Paused Mods" -PathType Container)){
    New-Item New-Item -Path "$NWDir/Mods/Paused Mods" -ItemType "Directory"
}
Switch($wshell.Popup("Do you want shortcuts?",0,"",4)){
    6{
        #Creates shortcuts for each script file
        foreach($file in $ScriptsToBeInstalled){
            $shortcut=$wshell.CreateShortcut("$HOME/Desktop/$($file.BaseName)Shortcut.lnk")
            $shortcut.TargetPath="$PSHOME/powershell.exe"
            $shortcut.Arguments="-command `"& `'$NWDir/$($file.BaseName).ps1`'`""
            $shortcut.WorkingDirectory="$NWDir"
            $shortcut.Save()
        }
    }
}