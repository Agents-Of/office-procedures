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

### PFM Codex ↔ Claude same-account review record

Within PlayFieldMultiplier, red-team Codex and blue-team Claude agents may use
a permanent same-account, comment-based PR review. The comment is a valid
review gate only if it identifies the author and reviewer card identities,
their distinct harness/team roles, the exact reviewed head SHA, an explicit
`APPROVE` or `REQUEST_CHANGES` outcome, and concrete diff/test evidence.
Native GitHub approval is not implied or claimed. This record never waives
independent reviewer cognition, actual diff review, checks, merge authorization,
or any human/product gate.

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

## 11. Fail loudly when a real dependency is missing

If a real external dependency (an API, a service, a required data source)
isn't actually available, say so plainly and stop — don't silently
substitute fabricated data and continue as if nothing happened. A fallback
that isn't clearly labeled as a fallback is worse than no fallback at all;
whoever reads the result downstream needs to know it isn't real.

## 12. Comments are transient triage — durable findings get their own issue

An issue or PR comment is a place to triage, ask, and confirm — it is not
where an actionable unit of work permanently lives. If a comment describes
something independently schedulable (a bug, a scope gap, a missing coverage
axis, a follow-up task) that would still matter after the comment's parent
issue or PR closes, open a real issue for it before moving on — cross-linked
back to the source (e.g. "found while reviewing #N"), with a real type and
priority label. Once that's done, the comment can be treated as read and
historical; the issue, not the comment, is the durable, groomable unit that
gets prioritized, scheduled into a sprint, and closed on its own merits.

The test: if closing the parent issue or merging the parent PR would make
this finding invisible or unfindable, it needs its own issue number. A
comment that is purely conversational — an ack, a status ping, a short
clarifying question — needs no rollup.

Real example this rule is written from: a reviewer's comment on
`PlayFieldMultiplier/LeagueOS#133` flagged a non-idempotent test fixture and
three uncovered acceptance-criteria axes on the parent story (`#126`). The
fixture defect became its own real issue, `#137`. The three acceptance axes
were already independently decomposed into live child tasks (`#134`, `#135`,
`#136`) — check for that decomposition before opening a new issue for a
finding; a rolled-up finding that duplicates an existing tracked item is the
same failure mode this rule exists to prevent, just one level up.

## 13. An A2A notification is not the message — poll for the real content

A one-line "new task from X" banner pasted into a live agent's terminal is a
wake signal, not the message itself. Receiving that banner and responding
with a generic acknowledgment ("standing by," "ready to receive") without
actually querying for the real task content leaves the real work
unprocessed and invisible to the dispatcher, who cannot tell "received and
ignored" apart from "never delivered" from their side alone.

On receiving such a banner: query for the real content immediately and act
on it in the same turn, not just acknowledge the banner exists. On
dispatching: a send call reporting success confirms delivery to the task
store, not that the receiving agent has read or acted on the real content —
check the receiving agent's actual subsequent output for evidence of that
before assuming the work is moving.

Real example: two separate live agents each received a real, actionable task
notification, each replied with a generic "standing by" without querying for
the actual content, and each sat idle with the real work undone for many
minutes until the dispatcher noticed and re-prompted them explicitly to poll
for it. This is the same underlying failure mode as replying into an existing
task ID silently dropping delivery — an apparently-successful dispatch call
is not proof the receiving agent has actually processed the real content.

## 14. Never force-push a shared integration branch

Never commit or push directly to a shared integration branch (`devline`,
`main`, or equivalent) — always a real feature branch, a real PR against it,
review, then merge. Never force-push a shared branch under any circumstance.
A force-push discards whatever the remote had that your local history
doesn't contain — on your own private feature branch that's a normal rebase;
on a branch every other agent's PR targets, it silently deletes their merged
work with no warning to anyone.

Real incident this rule is written from: an agent committed a feature
directly to `devline` from a stale local checkout and force-pushed it,
discarding the four most recent commits — an entire merged PR, including two
real bug fixes landed hours earlier. The lost commits were still reachable by
SHA (not yet garbage-collected) and were recovered by resetting the branch
ref back to the pre-force-push commit via the GitHub API, then giving the
agent's real work its own proper branch and PR against the restored branch.
Recovery was possible only because the old SHA was still reachable — that is
luck, not a plan. Treat a discovered force-push to a shared branch as a live
incident: verify via `compare` whether the new tip is `behind` the old one,
and if so, recover the old SHA onto the branch before anything else proceeds.
