---
id: 1
title: "Handoff entry reports test pass count without the environment it depends on"
status: open
type: internal
skill: []
proposes_skill: []
target_file: ["docs/handoff/PROMPT-claude-ai.md", "docs/handoff/TEMPLATE.md"]
siblings_checked: "none: target is the handoff journal prompt/template, which belongs to no skill family"
area: "handoff journal, section Hasil nyata"
date: 2026-10-06
session_context: "verifying the Landsat Processor handoff entry against landsat_processor_v34.zip in Claude Code"
parked_until:
resolved:
resolution:
reference:
commands_verified: "pytest tests in extracted zip: run, 197 passed 1 failed; the failure reads a hardcoded /home/claude path absent from the zip"
---

**Issue:** The claude.ai entry states "198 tes pytest lulus". Rerun in a clean extraction, 197 pass and 1 fails (`test_apply_with_target_crs_reprojection`), because five test files read real data from hardcoded `/home/claude/...` paths that exist only in the original workspace. The claim was true where it was made and not reproducible elsewhere, and the entry did not say so.

**Suggested improvement:** Add to the handoff prompt and template: for every reported test result, state which tests need external or machine-local data and where it lives, and require the final run to be from a clean extraction.

**Principle:** A verification result is only portable if the environment it depended on travels with it or is named.
