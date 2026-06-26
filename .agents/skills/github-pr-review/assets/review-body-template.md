# Review Body Templates

Use these as terse starting points. Edit them to fit the PR. Do not post the headings.

Always include a one-line summary after the opening sentence that groups the findings at a glance, for example: `Summary: security binding bug, permission test gap, and one shared UI boundary issue.` Keep it concise.

## approved

Approved. The change matches the stated intent and I do not see a blocker in the current diff.
Summary: only non-blocking P4 follow-up items remain.

## changes-requested

Requesting changes. The blockers are in the inline comments and they need to be fixed before this should merge.
Summary: [group the top blocker themes in one short line].

## comment

Left comments for follow-up. I do not see a merge blocker, but the issues called out should be addressed or tracked.
Summary: [group the non-blocking concerns in one short line].

## hard-stop changes-requested

Requesting changes. The current direction is not acceptable in this form and needs a different implementation approach, not another cosmetic pass.
Summary: [group the structural reasons this direction is unacceptable in one short line].