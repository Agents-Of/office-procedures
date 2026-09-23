param()

$ErrorActionPreference = 'Stop'

function Invoke-WslKpfm {
    & wsl.exe -d KPFM @args
    if ($LASTEXITCODE -ne 0) {
        throw "KPFM command failed with exit code ${LASTEXITCODE}: wsl -d KPFM $($args -join ' ')"
    }
}

try {
    # WSL may emit UTF-16-style NUL bytes through PowerShell on Windows.
    $distros = ((& wsl.exe -l -q 2>&1 | Out-String) -replace "`0", '')
    if ($LASTEXITCODE -ne 0 -or $distros -notmatch '(?m)^KPFM\s*$') {
        throw 'The required KPFM WSL distro is not installed or is not visible to WSL.'
    }

    # Starting the distro and service is safe; this does not touch Docker Desktop state.
    Invoke-WslKpfm -u root -- systemctl start docker
    Invoke-WslKpfm -- docker info --format '{{.ServerVersion}}'
    Invoke-WslKpfm -- docker compose version

    Write-Output 'KPFM native WSL Docker is ready.'
    exit 0
}
catch {
    Write-Error $_
    Write-Error 'Stop. Do not retry Docker Desktop or delete/reset Docker state.'
    exit 2
}
