# 03 Typography

All fonts ship with iOS; nothing has to be bundled. All sizes are **fixed** (`Font.custom(_:fixedSize:)`):
an EFB must not change size with the system text setting.

## Faces and roles

| Role | Font (PostScript name) | Size pt | Colour |
| --- | --- | --- | --- |
| Row label | `Futura-CondensedMedium` | 20 | white |
| Unit caption | `Futura-CondensedMedium` | 20 (home: 18) | `data.caption` |
| Popover hint | `Futura-CondensedMedium` | 20 | white, shadow `black 35 %` y −0.5 |
| Airport code | `Futura-CondensedMedium` | 19.2 | data colour |
| Row value | `HelveticaNeue-CondensedBold` | 20 | data colour |
| Result value | `HelveticaNeue-CondensedBold` | 20 | `data.computed` |
| Top bar title parts | `HelveticaNeue-CondensedBold` | 24 | `text.slate`, white shadow y +1 |
| Popover title | `HelveticaNeue-CondensedBold` | 20 | white, shadow `black 70 %` y −1 |
| Primary button | `HelveticaNeue-CondensedBold` | 21 | `#5E5E5E` on white |
| Secondary button | `HelveticaNeue-CondensedBold` | 16 to 20.5 | white on grey |
| Keypad digit | `HelveticaNeue-CondensedBold` | 30 | `text.slate` |
| Keypad word (Done, Next) | `HelveticaNeue-CondensedBold` | 26 | `text.slate` |
| Entry field | `HelveticaNeue-CondensedBold` | 24 | white, unit in caption grey |
| Back link | `HelveticaNeue` | 18 | `#333333` |
| Section header (home) | `HelveticaNeue-Bold` | 15 | white |
| FMS mirror | `Menlo-Bold` (B612 Mono preferred if bundled) | page specific | FMS palette |
| Graph axis | `HelveticaNeue` | 10.5 to 13 | `#D8D8D8` / `#F0F0F0` |

## Embossing

Text on glossy or metal surfaces is embossed with a 0 blur, 1 pt offset shadow:

- dark text on light surface: white 80 to 90 % shadow, y **+1** (pressed in),
- light text on dark/grey surface: black 50 to 75 % shadow, y **−1** (raised).

Text on dark cards has no shadow.

## Casing

- Labels: UPPERCASE as on the flight deck: `RWY COND`, `T.O. THRUST`, `ENG OUT ACC`.
  Exception: established mixed-case terms (`Green dot`, `Limitation`).
- Values: as the source writes them: `Dry`, `Off (STD)`, `6-Dry`, `FLEX 58`.
- Buttons: primary actions UPPERCASE (`COMPUTE`, `MODIFY`, `CLEAR`, `STOP`), dialog buttons Title case
  (`Close`, `Done`, `Next`, `Restore`).

## Numbers

- Whole numbers where the unit is whole (kt, ft, °C FLEX, m). One decimal for tonnes (`69.8 T`),
  OAT and QNH only when entered with a decimal.
- Units separated by a space and drawn in the same font: `143 kt`, `FLEX 58 °C`.
- Wind as `(DDD/ SS)` with leading zeros on direction: `(020/ 9)`.
- ISA deviation after OAT in white: `12 (ISA -3)`.
- Values and units are right aligned on fixed columns (value column ends at 177.5 pt, unit column at
  209 pt inside a 238 pt result card) so digits line up row to row.

## Truncation

Long names are cut **per character** with an ellipsis to the available width
(`BRUSSELS NA…`), never wrapped, never scaled below 90 %. `fsTruncated(_:fontName:size:width:)` in
the kit does it.
