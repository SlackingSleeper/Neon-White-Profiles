function Add-Cheat{
    param($cheatMod)
    If(-Not (Test-Path "$cheatMod.dll")){
	    
        If((Test-Path ".\Paused Mods\$cheatMod.dll")){
            Copy-Item ".\Paused Mods\$cheatMod.dll" -Destination "."
            Copy-Item ".\Paused Mods\AntiCheat.dll" -Destination "."
        }
        Else{
            cd ..
            Throw("You don't have $cheatMod installed, dummy.")
        }
    }
}
function Remove-Cheat{
    param($cheatMod)
    If(Test-Path "$cheatMod.dll"){
	    Move-Item -Path "$cheatMod.dll" -Destination ".\Paused Mods" -Force
        If(Test-Path ".\AntiCheat.dll"){
	        Move-Item -Path ".\AntiCheat.dll" -Destination ".\Paused Mods" -Force
        }
    }
}

function Start-OBS{
    if((Test-Path ".\NeonCapture.dll") -and (-not -not ($config.Paths | Get-Member obsFile,obsDir -ErrorAction SilentlyContinue) -eq $true)){
        $obs=Get-Process "obs*"
        If(-Not $obs){
            Start-Process -FilePath $config.Paths.obsFile -WorkingDirectory $config.Paths.obsPath
        }
    }
}
function Test-NeonWhiteRunning{
    If((Get-Process "Neon White" -ErrorAction SilentlyContinue) -ne $null){
        Write-Error "Neon white already running"
        Exit
    }
}