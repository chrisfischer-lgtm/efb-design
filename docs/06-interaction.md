# 06 Interaction

## Field lifecycle

Every input field is in exactly one state. The kit models it as `FieldState`.

```
          ┌─────────────── tap ───────────────┐
          ▼                                    │
 missing (pencil) ──enter──► entered (blue) ───┤
          │                                    │
 standard "(STD)" (white) ──change──► entered (blue)
 preselected (yellow) ──confirm/change──► entered (blue)
 fixed (green, not tappable)

 any state ──COMPUTE──► locked (white, compact, no affordance) ──MODIFY──► previous state
```

| State | Colour | Trailing | Tappable |
| --- | --- | --- | --- |
| `missing` | none | pencil badge | yes |
| `standard(value)` | white | chevron if list | yes |
| `preselected(value)` | yellow | chevron | yes |
| `entered(value)` | blue | chevron if list | yes |
| `fixed(value)` | green | none | no |
| `locked(value)` | white | none | no |

## Compute flow

1. All fields filled → COMPUTE turns from `whiteDimmed` to `white`. Until then the result pane says
   what is missing: "All fields must be completed to compute your take-off performance data".
2. COMPUTE → popovers close, computing overlay for about 3 s. STOP cancels and nothing changes.
3. Result appears on page 1. Inputs lock (36 pt rows, no scrolling, values white).
4. COMPUTE becomes MODIFY, CLEAR is dimmed, MEL / CDL dimmed.
5. MODIFY → result discarded, inputs back to their states, page reset to 1.

No solution: the result pane shows `NO TAKEOFF SOLUTION` in amber with the limiting reason. Inputs
stay unlocked.

## Field order

Next walks a fixed order that matches the paper flow:

`WIND → OAT → QNH → RWY COND → RWY CC → A-ICE → TOW → T.O CG → T.O. THRUST → CLB THRUST → CONF → AIR COND`

After the last field Next closes the popover.

## Validation

- Validate on commit (Done / Next), not per key.
- Invalid entry: keep the popover open with the entered text; don't store anything; no shake, no
  red. The hint lines already state the range.
- Convert silently when the value is clearly in another unit (see principle 7), round to the field's
  resolution, then validate.
- Dependent fields reset when their parent changes: a new airport clears the runway, a new aircraft
  type resets type-specific options (e.g. CLB THRUST back to CL).

## Type-dependent fields

Options that don't exist on a type are not offered:
- shown as a **fixed** green row (narrowbody CLB THRUST = `CL`),
- or as a single-entry list (`On (STD)` where packs-off takeoff is not allowed).

Never show a disabled option the pilot can't choose.

## Dismissal

- Tap outside a popover: close without committing.
- Close button: same.
- Done: commit + close. Next: commit + open next.
- Only one popover at a time.

## Navigation

- Home (My Flight) → module via module buttons or the module bar.
- Module → home via the back link "‹ My Flight" in the top bar.
- Sibling apps open by URL scheme. A module not built yet shows the info alert.
- No tab state is hidden: the module bar always shows where you are.

## Debug and screenshot launch arguments

Each app supports launch arguments that open a state directly, for screenshots and visual checks:
`-demo home|empty|filled|computed`, `-pop <field index>`, `-page <n>`, `-graph 1`, `-computing 1`.
New modules must offer the same so their screens can be compared side by side.
