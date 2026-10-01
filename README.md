# helpsheet

Builds a **2-page A4 LaTeX helpsheet** (cheat sheet, formula sheet, exam notes) for computer science, mathematics and statistics exams. Output: `.pdf` + `.tex`.

## Quick start

1. Install the skill (`helpsheet.skill`).
2. Attach your notes, slides or syllabus.
3. Say: "make me a cheat sheet for my <course> exam".
4. Answer the 3 intake questions (about 1 min).
5. Check the `% CHECK` list before printing.

## What you get

- One A4 sheet, both sides, landscape, 4 columns, exactly 2 pages
- Font fixed at `\footnotesize`. Content gets cut, never shrunk.
- Terse bullets, one idea per line, tables for comparisons
- Blue math, tight spacing, section numbers like `01.`
- The `.tex` source, so you can edit it

## How it works

| Phase | What happens |
|---|---|
| 1. Intake | Asks: exam type and open/closed book, weak topics, material (if none attached) |
| 2. Build | Tags each item **M** (must-have) or **N** (nice-to-have), fills the template |
| 3. Verify | Compiles, checks 2 pages, 0 overfull boxes, last page ≥60% full |
| 4. Deliver | Gives `.pdf` + `.tex`, a short `CHECK` list, and what was cut |

Overflow: N items are removed from the bottom up. Underfull: N items are added back. If the material runs out, the sheet is delivered as is. It is never padded.

## Content rules

- Content comes from **your material first**.
- Anything added from the model's own knowledge is marked `% CHECK` in the `.tex` only. The PDF stays clean.
- Verify every `CHECK` item against your course notes before the exam.
- Proofs are dropped unless they are examinable.

## Files

| File | Purpose |
|---|---|
| `SKILL.md` | Instructions the model follows |
| `assets/template.tex` | Self-contained LaTeX preamble and layout |
| `scripts/check.sh` | Compile and report pages, warnings, fill % |
| `references/domains.md` | ≤8 lines of block guidance per domain |
| `evals/evals.json` | 3 test prompts (stats, CS, math) |

## Requirements

- A TeX Live install with `pdflatex` (or `latexmk`) and `pdfinfo`
- Standard packages only: `multicol`, `helvet`, `amsmath`, `xcolor`, `enumitem`, `geometry`, `mathtools`
- `newtxtext` is optional. The template skips it if missing.

## Without LaTeX or a shell

- The `.tex` is still delivered. Compile it yourself, e.g. on Overleaf.
- Page fit is then **unverified**. Aim for about 300 one-line items.
- No file tool? The `.tex` is printed in one code block.

## Run the check by hand

```
sh scripts/check.sh sheet.tex
```

Want: `pages: 2`, `overfull boxes: 0`, `RESULT: OK`.

## Known limits

- Tested on 3 short sample inputs. The cut-to-fit loop has not been run on a full-size real sheet.
- Inline fractions render small. This is a LaTeX default.
- Page fit is checked by PDF text positions, not by eye. Look at the PDF before printing.
