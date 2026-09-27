# PFM and PPL boundary

## Ownership

- **PFM (PlayFieldMultiplier)** is the development organization. It owns
  LeagueOS source, reusable packages, schemas, import tooling, tests, and
  deployment automation.
- **PPL (Portland Pinball League)** is an external client/instance used during
  bootstrap and dogfooding. PPL data, rules, rosters, scores, and instance
  configuration are client concerns, not LeagueOS source-of-truth concerns.

## Runtime and release boundary

Local LeagueOS validation uses only the approved `LeagueOS` or `LeagueOS_Red`
WSL runtimes. A PPL instance may be mounted or seeded for acceptance testing,
but it must not redefine the PFM development runtime or become a second copy of
the LeagueOS project.

During bootstrap, PFM agents may use authorized PPL staging access to validate
the product against client data. Keep that access scoped and temporary. Do not
put PPL credentials or raw client data into the PFM repositories.

All real PPL domain, credential, data-import, and deployment operations must be
routed through `PortlandPinballLeague/PPL_001_bootstrap`. Do not implement
client-specific access directly in generic PFM repositories or in reusable
LeagueOS packages.

When bootstrap is complete, detach the PPL-specific connections, credentials,
and deployment hooks from the development workflow. Publish LeagueOS through
its npm distribution and let PPL consume the released package as an external
client. PPL-specific adapters or import fixtures must remain clearly marked as
client integration material and must not be presented as general LeagueOS
infrastructure.
