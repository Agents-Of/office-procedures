# Office Procedures

Real, hard-won standing doctrine for every agent working shared code across
this fleet. Every rule here exists because skipping it broke something real
today. Read this before touching a shared branch, dispatching work, or
declaring anything done.

## 1. Never trust your local checkout

Before starting ANY new work: `git fetch origin <target-branch>` and confirm
your working branch is actually in sync (`gh api repos/<org>/<repo>/compare/
<target>...<your-branch>` should show `behind_by: 0`, or you just fetched/
merged/rebased to make it so). A stale local clone or scratchpad copy has
caused three separate real incidents in one day: a branch 18 commits behind
devline whose author searched it and wrongly concluded a file didn't exist; a
docker-compose mount pointing at an empty scratchpad directory instead of the
real repo; a PR review that checked the wrong branch entirely. Check first,
every time — don't assume your copy matches origin.

## 2. Commit early, push often — local-only work does not exist

A commit that hasn't been pushed is invisible to everyone else and one
crashed pane away from gone. Push after every meaningful unit of work, not
just when you think you're finished. Real work today sat as three unpushed
local commits, invisible to review, for over half an hour before anyone
noticed.

## 3. Check for existing/concurrent work before building

Before dispatching or starting an implementation, search the actual codebase
(not just related issues) for something that already does this, and check
whether another agent is already working the same area. Two agents built two
separate, competing implementations of the same feature in one day because
neither checked. If a design goal needs more than one agent, the ownership
split is decided and stated by the dispatcher before work starts — not
negotiated between the agents after they collide.

## 4. Full cycle before new dependent work starts

An issue's real lifecycle: push → PR against the real target branch →
independent review, real comments on the real diff → merge → close. Don't
start work that depends on an issue's outcome until that cycle actually
completes. Parallel work is only safe when it's genuinely decoupled — no
shared files, no data contract one side is waiting on. Verify that explicitly
before calling something decoupled.

## 5. When work is coupled: data before UI before integration

Schema/data-layer work (what a value or entity actually is) lands before UI
work (how it's presented) which lands before integration work (wiring
separately-built pieces together). Building integration code before its
data-layer dependency merges just means redoing it once that dependency
changes shape.

## 6. Mandatory independent review, every PR

No PR merges without a real, posted review comment against the actual diff —
same rigor whether the reviewer is on this account or a different one.
Chat approval ("looks good") is not a review.

## 7. Trust but verify — always

A claim of "done," "fixed," "tests passing," or "verified" is not evidence
until checked directly against the real system: the actual file content, the
actual branch state, the actual rendered page in a browser, the actual HTTP
response. This applies to your own work as much as anyone else's — sampling
one item in a claimed series and generalizing to the rest is not verification
of the rest.

## 8. Specificity is not evidence

A cited file path, function name, or command that sounds precise and
plausible is not automatically real. Resolve the actual citation (does the
file exist at that path, on that branch, right now) before accepting the
claim it supports.

## 9. No hardcoded rule values

Anything the governing spec (SNP league spec, or equivalent) declares as a
real, per-league/per-season configurable parameter must be read from a real
config-resolution system, not a bare literal in code. Where the spec is
genuinely silent on a default, say so explicitly rather than inventing a
plausible-sounding number.

## 10. Read the whole spec, don't grep for a term

A relevant value can live in a completely different section than where you
first looked (a parameter named in a data-model section, its actual default
value stated in a separate feature-flag-registry section). Read linearly
before concluding something is unspecified.
