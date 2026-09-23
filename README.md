# Agents-Of/office-procedures

Standing office procedures for the PFM agent fleet. See OFFICE-PROCEDURES.md.

## Local container quick start

On Victor's Windows workstation, use the native `KPFM` WSL Docker engine for
all local WordPress and Compose work. Docker Desktop is not the recovery path
when it fails after reboot with a `dockerInference` lock or startup error.

From PowerShell, run this before any Docker command:

```powershell
& "$PWD\scripts\ensure-kpfm-docker.ps1"
if ($LASTEXITCODE -ne 0) { throw 'Native WSL Docker is unavailable; stop and report the exact output.' }
```

Then run Compose through WSL from the actual feature worktree, using a unique
Compose project name. Do not reset Docker Desktop, delete Docker state, prune
shared volumes, or mount a scratchpad checkout. The full recovery sequence,
worktree checks, isolation rules, and responsibility boundary are in
`OFFICE-PROCEDURES.md`, section 16.
