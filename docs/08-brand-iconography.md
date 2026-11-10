# 08 Branding and iconography

The family borrows a **genre** (the classic skeuomorphic performance EFB), not anyone's identity.
The operator's own brand is the only brand on screen, and it stays at the edges.

## Where the operator brand appears

| Place | What |
| --- | --- |
| App icon | Flat brand colour background, one light line drawing of the module, small brand mark in a corner |
| Logo tab (home, top centre) | Operator wordmark, white on black, on a silver tab |
| Login screen | Wordmark, crew ID + password, LOG IN |
| Status bar / app name | `<Operator> <Module>` |

Brand colours stay out of the work screens (see [02 Colour](02-colour.md)). Take logos and marks
from the operator's official brand files, never redraw them.

## App icons

- One family: flat, no gradient, no gloss (the icon is the brand, the inside is the instrument).
- One line drawing per module: departing aircraft + runway line (TakeOff), arriving aircraft +
  runway line (Landing), level aircraft (In-Flight), scale / sheet (Loadsheet).
- Line weight equal across the family; brand mark always the same size and position.
- Generate icons from code so every module icon is consistent. Export a 1024 PNG + SVG.

## Module icons (inside the app)

- Line drawings, 2 pt, `#555555`, no fill, on the glossy module tiles.
- Fixed set: eQRH (book with colour tabs, the only coloured icon), takeoff, cruise, landing,
  documents, aircraft fin (tail/type).
- Toolbar glyphs: refresh, sun (dim), export. Same stroke, `#555555` (export dimmed `#A0A0A0` when
  unavailable).

## Never

- No third-party logos, wordmarks, product names or "company of" lines, not even as placeholders.
- No screenshots of third-party apps in this repo, in tickets or in release notes. Reference
  material stays local and private.
- No real operator registrations as defaults in shipped builds: use your own fleet. Demo launch
  states may use neutral examples.
- No real state emblems or authority marks.
