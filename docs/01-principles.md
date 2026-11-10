# 01 Principles

These are the rules every app of the performance EFB family follows. Each one exists because
the app is used on a flight deck: one hand, low attention, sometimes turbulence, often in a hurry,
and a wrong number has consequences.

---

## 1. One fixed canvas

Every screen is designed on a **1180 × 820 pt canvas** (iPad landscape) and scaled uniformly to the
device (`min(width / 1180, height / 820)`). Elements are placed at measured coordinates, not laid
out by a flexible stack.

**Why:** pilots build muscle memory. COMPUTE must be in exactly the same spot on an 11" and a 13"
iPad, on every flight, in every module. A layout that reflows is a layout you have to read again.

- Do: place with `.at(x, y, w:, h:)` inside a top-leading `ZStack`; use fixed-size fonts.
- Don't: use Dynamic Type, size classes, portrait layouts or `List`/`Form` defaults.
- Landscape only. System overlays hidden, light colour scheme forced.

## 2. Colour is data state

Colour on a value says **where the value came from**, never how important the designer thought it
was.

| Colour | Means |
| --- | --- |
| **Blue** `#48CBFF` | The pilot entered or changed this |
| **Yellow** `#F5E619` | The system preselected this (from My Flight); confirm it |
| **Green** `#4FF43D` | The system computed this, or it is fixed by the aircraft type |
| **White** | Standard / default value, or a label |
| **Orange pencil** | Required, still empty |
| **Amber text** `#FFA933` | Warning: no solution, unknown version |

**Why:** at a glance the pilot can see which numbers are theirs, which are suggestions, and which
are outputs to read back. It mirrors the convention on the flight deck displays (green = system,
blue = selected, amber = caution).

- Don't: use colour for branding, emphasis or decoration inside the data area.
- Don't: introduce a new colour without giving it a meaning in [02 Colour](02-colour.md).

## 3. Inputs left, answer right

The work screen is a master/detail split: a **260 pt input column** on the left, the **result pane**
on the right, a 2 pt black divider between them. Inputs are grouped into cards by topic
(airport/runway, conditions, aircraft/config). Below the column sit the secondary actions (MEL, CDL)
and the primary pair (CLEAR, COMPUTE).

**Why:** the pilot fills in top to bottom in the order the data arrives (ATIS, loadsheet, briefing),
and reads results without inputs ever being covered.

## 4. One field, one popover

Tapping a row opens **its own popover**, anchored to the row with a left-pointing arrow, the row
turns blue while it is open. Lists show a check mark on the current value. Numbers use the
in-app keypad, never the system keyboard. Tap outside to dismiss.

**Why:** the system keyboard covers half the screen and offers letters you don't need. A popover
next to the row keeps the context visible and makes clear which field is being edited.

- Each popover states its **format and range** in hint lines.
- Keypad popovers have **Next**, which moves to the next field in a fixed order, so a whole form can
  be filled without closing anything.

## 5. Compute is a deliberate act

COMPUTE is dimmed until every required field has a value. Pressing it shows a short modal
("Computation is running … Please wait", spinner, STOP). Then:

- the result appears on the right (swipeable pages with page dots),
- the input column **locks**: rows compact to 36 pt, values turn white, chevrons and pencils
  disappear,
- COMPUTE becomes **MODIFY**, CLEAR is dimmed.

MODIFY unlocks the inputs and throws the result away. A result is never shown next to inputs that
no longer match it.

**Why:** a performance figure is a decision, not a live preview. Locking prevents the classic error
of nudging an input after reading the speeds.

## 6. Defaults are visible

A value that the operator considers standard carries the `(STD)` suffix and is shown in white:
`FLEX (STD) °C`, `OPT CONF (STD)`, `Off (STD)`. Choosing anything else drops the suffix and turns the
value blue.

**Why:** in a briefing, "anything non-standard?" must be answerable by looking for blue.

## 7. Forgiving entry, strict range

Accept what pilots actually type and convert it:

| Field | Accepted | Converted to |
| --- | --- | --- |
| OAT | °C, or °F (value > 55) | °C, 0.1 |
| QNH | hPa, or inHg (value < 40) | hPa, 0.1 |
| TOW | tonnes (< 1000), kg, lb (> max kg), `*` = structural | kg, rounded to 100 |
| Wind | `DDD/SS`, `DDD/SS/GXX`, m/s | kt |

Anything outside the stated range is refused: the popover stays open, nothing is stored.

## 8. Materials have a job

The look is skeuomorphic, but every material has one function:

- **Brushed metal** is the background: it says "nothing to do here".
- **Dark cards** with an etched edge hold data: inputs and results.
- **Glossy keys** (white or grey gradient, 1 pt border, embossed text) are the only things that look
  pressable, and they are the only things that are.
- **Slate popovers** float above with a shadow: they are temporary.

Don't add materials (glass, blur, neon, flat Material You surfaces). Don't make non-interactive
things glossy.

## 9. Two typefaces, two roles

- **Futura Condensed Medium** for labels, captions and hints (what is asked).
- **Helvetica Neue Condensed Bold** for values, titles and buttons (what is answered).
- **Menlo Bold** (or B612 Mono) only on the FMS mirror page.

Condensed faces fit long aviation values (`BRUSSELS NA…`, `Basic CG >= 27%`) into a 260 pt column
at 20 pt size, which is the minimum for reading at arm's length.

## 10. Speak cockpit, in English

Labels use the abbreviations of the flight deck and the FCOM, in uppercase: RWY, OAT, QNH, TOW,
A-ICE, T.O CG, CLB THRUST. Units sit next to the label as a grey caption (`OAT °C`, `TOW T`), not
after the value. All user-facing text is English. No em dash anywhere.

## 11. Mirror the aircraft

Where the result ends up in an aircraft system, show a page that looks like that system: the
takeoff result has an MCDU "PERF TAKE OFF" page in the FMS palette (green / cyan / white on black),
laid out like the real page, so the pilot can copy line by line.

## 12. Graphics are schematic and to scale

Diagrams (runway strip, climb graph) are simple, but proportional and labelled with real numbers:
runway length, ASD, stop margin, scale bar, entry angle. A diagram is a cross-check of the numbers,
never decoration.

## 13. Same shell, many modules

All apps of the family share the **My Flight** home (aircraft type, registration, flight number,
from/to) and the **bottom module bar** (74 pt). The module bar links sibling apps; a module that does
not exist yet answers with "This module is not available in this version.", never with a dead tap.
