# 09 New app checklist

Use this before a new module of the family goes to TestFlight.

## Shell
- [ ] Runs on the 1180 × 820 pt canvas via `EFBCanvas`, landscape only, light scheme forced
- [ ] Fonts fixed-size, no Dynamic Type
- [ ] Same My Flight home (aircraft type, registration, weight variant, flight number, from, to)
- [ ] Top bar: back link, `MODULE ┊ REG ┊ TYPE`, refresh / dim / export at the standard positions
- [ ] Module bar with the current module selected; unbuilt modules show the info alert

## Inputs
- [ ] Input column 260 pt, cards grouped by topic, 44 pt rows
- [ ] Every field has its own anchored popover; no system keyboard anywhere
- [ ] Every row uses `FieldState` (missing / standard / preselected / entered / fixed / locked)
- [ ] Numeric popovers state format and range, convert alternate units, refuse out-of-range
- [ ] Next walks the documented field order
- [ ] Type-dependent options are hidden or fixed, never disabled

## Compute
- [ ] COMPUTE dimmed until complete, computing overlay with STOP
- [ ] Inputs lock after compute, MODIFY unlocks and clears the result
- [ ] "No solution" path shown in amber with a reason
- [ ] Page 1 answers the question; other pages are cross-checks
- [ ] Graphics are to scale and labelled

## Visual
- [ ] Only palette colours from `tokens.json`; data colours only on values
- [ ] Brand colours only in icon, logo tab, login
- [ ] Buttons: white = primary, grey = secondary, dimmed instead of hidden
- [ ] Screens compared side by side with the reference TakeOff app (same launch-argument states)

## Content
- [ ] English only, no em dash, flight deck abbreviations, `(STD)` on defaults
- [ ] App name `<Operator> <Module>`, icon from the shared generator

## Legal
- [ ] No third-party marks, names, screenshots or data files in the repo or the bundle
- [ ] "Not for real-world operations" notice in the About / login screen
