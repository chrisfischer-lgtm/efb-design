# 07 Content

## Language

- All user-facing text is **English**. Code comments may be in any language.
- **No em dash** ("—") anywhere: UI, hints, alerts, docs, App Store text. Use a comma, colon,
  full stop or parentheses. A hyphen with spaces is allowed where the aviation source uses it
  (`TOW - TOW`, `*T/O FROM RWY HEAD* -`).

## Labels

Use the flight deck term, uppercase, shortest established form:

| Write | Not |
| --- | --- |
| `RWY` | Runway |
| `OAT` | Temperature |
| `RWY COND` | Surface condition |
| `RWY CC` | Runway condition code |
| `A-ICE` | Anti-ice |
| `TOW` | Takeoff weight |
| `T.O CG` | CG category |
| `T.O. THRUST` | Thrust mode |
| `ENG OUT ACC` | Engine-out acceleration altitude |

Units are captions next to the label (`QNH hPa`), not repeated after the value. Exception: results,
where unit and value form one reading (`V1 143 kt`).

## Popover hints

Pattern, one statement per line, no full stop where the source has none:

```
<FIELD> format: <pattern>
<FIELD> Range: from <min> to <max> <unit>
value entered in <alt unit> is converted into <unit>
```

Lists: `Select <FIELD> setting from the list.` If a choice needs a word of explanation, add one line:
`Select OPT CONF to let the software determine the best configuration.`

## Values

- Defaults carry `(STD)`.
- Combined values keep the source notation: `Ext Forw  CG < 27%`, `Basic CG >= 27%`,
  `T WV12 77.0/66.0/62.5`.
- `NONE` (uppercase) for an explicitly empty choice.

## Messages

| Situation | Text |
| --- | --- |
| Inputs incomplete | All fields must be completed to compute your take-off performance data |
| Computing | Computation is running … / Please wait |
| No solution | NO TAKEOFF SOLUTION (+ limiting reason) |
| Not built yet | This module is not available in this version. |
| No data for type | Performance data for <TYPE> is not available yet. |

Short, factual, no exclamation marks, no apologies, no emoji.

## Identity in text

- App names: `<Operator> TakeOff`, `<Operator> Landing`, … (operator + module, module in Title case,
  no space inside "TakeOff").
- Never name a third-party product in the UI.
