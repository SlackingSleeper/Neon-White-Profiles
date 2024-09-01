function Add-Cheat{
    param($cheatMod)
    If(-Not (Test-Path "$($cheatMod)")){
	    
        If((Test-Path ".\Paused Mods\$cheatMod")){
            Copy-Item ".\Paused Mods\$cheatMod" -Destination "."
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
    If(Test-Path "$($cheatMod)"){
	    Move-Item -Path "$($cheatMod)" -Destination ".\Paused Mods" -Force
        If(Test-Path ".\AntiCheat.dll"){
	        Move-Item -Path ".\AntiCheat.dll" -Destination ".\Paused Mods" -Force
        }
    }
}

function Initialize-PausedMods{
    If(-Not (Test-Path ".\Paused Mods" -PathType "Container"))
    {
	    New-Item -Path ".\Paused Mods" -ItemType "Directory"
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