# 02 Colour

All values are sRGB hex, measured from the reference TakeOff app. Token names match `tokens/tokens.json`
and `EFB.*` in `EFBKit`.

## Semantic data colours

These carry meaning (see principle 2). Use them only for values, never for chrome.

| Token | Hex | Role |
| --- | --- | --- |
| `data.entered` | `#48CBFF` | Value entered or changed by the pilot |
| `data.preselected` | `#F5E619` | Value preselected by the system (e.g. departure airport from My Flight) |
| `data.computed` | `#4FF43D` | Computed result, or value fixed by type (static `CL` row) |
| `data.default` | `#FFFFFF` | Standard `(STD)` value, locked inputs after compute, labels |
| `data.caption` | `#B5B9BF` | Unit captions next to labels (`°C`, `hPa`, `T`) |
| `data.warning` | `#FFA933` | `NO TAKEOFF SOLUTION`, unknown EFB version |
| `data.version` | `#FFB01F` | Version number in the My Flight header |

### FMS mirror and graphs

| Token | Hex | Role |
| --- | --- | --- |
| `fms.green` | `#1FF21F` | MCDU page title |
| `fms.value` | `#4FF43D` | MCDU computed values |
| `fms.cyan` | `#2FD6E8` | MCDU labels / brackets |
| `fms.grey` | `#7F7F7F` | MCDU inactive |
| `graph.path` | `#1EF0F0` | Climb path line |
| `table.green` | `#29FF42` | Tabular results (climb gradient table) |

## Surfaces

| Token | Hex | Role |
| --- | --- | --- |
| `surface.chrome` | `#C8C8C8` | Top bar (86 pt) |
| `surface.metalLight` | `#8A8A89` | Screen background (with brushed texture) |
| `surface.metalDark` | `#737372` | Result pane body |
| `surface.metalHome` | `#A7A7A7` | My Flight inner panel |
| `surface.card` | `#434343` | Data card / row body |
| `surface.cardEdge` | `#292C32` | Card outline, dark half of separators |
| `surface.separatorLight` | `#A1A1A1` | Light half of the etched separator |
| `surface.cardBevel` | `#B6B9BF` | 1 pt highlight under each card |
| `surface.popover` | `#757A81` | Popover body (gradient, see below) |
| `surface.popoverEdge` | `#282C32` | Popover outline and arrow stroke |
| `text.slate` | `#53626B` | Titles in the top bar, keypad legends, icons |

## Gradients

| Name | Stops (top → bottom) | Used for |
| --- | --- | --- |
| Row selected | `#6F879F` → `#527694` | Row whose popover is open |
| Entry field selected | `#6A8198` → `#456783` | Active keypad entry field |
| Popover | `#B9BDC2` 0, `#8D9095` 19.5 pt, `#7E8289` 20 pt, `#757A81` to 80 pt, `#696D73` bottom | Popover panel with a 20 pt lit title band |
| Button white | `#FFFFFF`, `#FBFBFB`, `#D5D7D8` | Primary actions (COMPUTE, MODIFY, Done) |
| Button white dimmed | `#BCBFC2`, `#ADB0B4`, `#95999E` | Disabled primary |
| Button grey | `#A1A5A9`, `#8A8F95`, `#6C7379` | Secondary (MEL, CDL, Close, Update) |
| Button grey dimmed | `#C6C9CD`, `#B7BABF`, `#A3A7AC` | Disabled secondary |
| Keypad key | `#FFFFFF`, `#F2F3F3`, `#DDDEDF` | Keypad keys |
| MEL/CDL strip | `#ECECEC` → `#BEC0C5` | Strip under the input column |
| Action strip | `#A9ACB1` → `#696F76` | CLEAR / COMPUTE strip |
| Result header | `#EDEDED` → `#B9BCC1` | Runway ident band over the result pane |
| Module bar idle | `#E9E9E9` → `#B8BBC0` | Bottom tab, not selected |
| Module bar selected | `#A4AAB0` → `#7A8590` | Bottom tab, current module |
| Pencil badge | `#FFBB2B` → `#FF9A2C` | Required-input badge |
| Pencil badge active | `#FFFFFF` → `#B8E0F4` | Badge while its popover is open |
| Segment active | `#5FBBE7` → `#3096BC` | Segmented control (ABSOLUTE / RELATIVE) |
| Runway tag | `#52D0FF` → `#3698C8` | `FULL` / intersection tag on the runway strip |

## Rules

- The data colours are bright on purpose: they sit on `#434343` and must read in a sunlit cockpit.
  Contrast of blue, green, yellow and white on the card is above 7 : 1.
- Never put a data colour on metal directly. Values live on cards.
- Never use the operator's brand colours inside the work screens. They belong to the app icon, the
  login screen and the logo tab only.
- The **dim** control (sun icon) lays `black 45 %` over the whole canvas. Don't build a separate
  dark mode: the palette is already a night palette for data.
