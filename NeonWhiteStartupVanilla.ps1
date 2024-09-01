#Check that you at least are in a directory with the correct name
If((Get-Location | Split-Path -Leaf) -eq "Neon White" ){
    Import-Module .\NeonWhiteStartupModule.psm1

    #Exit if Neon White is already running
    Test-NeonWhiteRunning

    #Read config file
    $config= Get-Content ".\UserData\NWStartScriptConfig.json" | ConvertFrom-Json

    cd ".\Mods"
    foreach($cheat in $config.Cheats){
        Remove-Cheat($cheat)
    }
    #If OBS is configured and you have NeonCapture installed make sure OBS is running
    Start-OBS
    cd ..
    Start-Process -FilePath ".\Neon White.exe"
}
Else{
    Write-Error "Running script from wrong location."
}