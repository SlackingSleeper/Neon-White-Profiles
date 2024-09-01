If((Get-Location | Split-Path -Leaf) -eq "Neon White" ){
    Import-Module .\NeonWhiteStartupModule.psm1
    Test-NeonWhiteRunning
        $config= Get-Content ".\UserData\NWStartScriptConfig.json" | ConvertFrom-Json
        cd ".\Mods"
        foreach($cheat in $config.Cheats){
            Remove-Cheat($cheat)
        }
        Add-Cheat("Xenon.dll")
        Start-OBS
        cd ..
        Start-Process -FilePath ".\Neon White.exe"
}
Else{
    Write-Error "Running script from wrong location."
}