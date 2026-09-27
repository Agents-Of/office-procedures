# Agents-Of/office-procedures

Standing office procedures for the PFM agent fleet. See OFFICE-PROCEDURES.md.

## Local container quick start

On Victor's Windows workstation, use the native `LeagueOS` or `LeagueOS_Red`
WSL Docker engine for LeagueOS work. The former `KPFM` runtime is deprecated.
Docker Desktop is not the recovery path
when it fails after reboot with a `dockerInference` lock or startup error.

From PowerShell, run this before any Docker command:

```powershell
& "$PWD\scripts\ensure-leagueos-docker.ps1" -Distro LeagueOS
if ($LASTEXITCODE -ne 0) { throw 'LeagueOS WSL Docker is unavailable; stop and report the exact output.' }
```

Do not run Compose automatically after the helper. First choose the runtime
mode in `OFFICE-PROCEDURES.md`, section 16: managed-grid mode inspects the
existing LeagueOS grid and never runs `compose up`; isolated-lab mode requires
a native checkout plus an explicit non-overlapping matrix for ports, volumes,
networks, container names, and project name. Do not reset Docker Desktop,
delete Docker state, prune shared volumes, or mount a scratchpad checkout.
