param(
    [ValidateSet('LeagueOS', 'LeagueOS_Red')]
    [string]$Distro = 'LeagueOS'
)

$ErrorActionPreference = 'Stop'

function Invoke-ApprovedWsl {
    & wsl.exe -d $Distro @args
    if ($LASTEXITCODE -ne 0) {
        throw "${Distro} command failed with exit code ${LASTEXITCODE}: wsl -d ${Distro} $($args -join ' ')"
    }
}

function Test-DockerReady {
    & wsl.exe -d $Distro -- docker info --format '{{.ServerVersion}}' *> $null
    return ($LASTEXITCODE -eq 0)
}

try {
    $distros = ((& wsl.exe -l -q 2>&1 | Out-String) -replace "`0", '')
    if ($LASTEXITCODE -ne 0 -or $distros -notmatch "(?m)^$([regex]::Escape($Distro))\s*$") {
        throw "The approved ${Distro} WSL distro is not installed or is not visible to WSL."
    }

    Invoke-ApprovedWsl -u root -- systemctl start docker
    $ready = $false
    for ($attempt = 1; $attempt -le 6; $attempt++) {
        if (Test-DockerReady) {
            $ready = $true
            break
        }
        Start-Sleep -Seconds 5
    }
    if (-not $ready) {
        Invoke-ApprovedWsl -- docker info
        throw "${Distro} Docker daemon did not become ready after bounded retries."
    }
    Invoke-ApprovedWsl -- docker compose version

    Write-Output "${Distro} native WSL Docker is ready."
    exit 0
}
catch {
    Write-Error $_
    Write-Error 'Stop. Do not retry Docker Desktop or use the deprecated KPFM runtime.'
    exit 2
}
