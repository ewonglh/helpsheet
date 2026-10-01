---
name: helpsheet
description: Build a 2-page A4 LaTeX helpsheet (cheat sheet, formula sheet, crib sheet, exam notes) for computer science, mathematics or statistics exams. Output is a compiled PDF plus the .tex source, checked to be exactly 2 pages with terse, scannable bullets. Use whenever the user mentions a cheat sheet, cheatsheet, help sheet, formula sheet, crib sheet, "notes I can bring to the exam", a 1-page or 2-page summary, or asks to condense lecture notes, slides, a syllabus or past material into printable revision notes, even if they never say LaTeX.
---

# Helpsheet

Goal: `helpsheet.tex` + `helpsheet.pdf`. One A4 sheet, both sides, landscape, 4 columns, exactly 2 pages.

All paths below are relative to this skill's folder.

## Phase 1: Intake (one message, max 3 questions)

1. Ask all three at once:
   - Exam type and topics? Open or closed book?
   - Weakest topics? (these get space first)
   - No material attached? Ask for notes, slides, syllabus or a topic list.
2. Material attached? Skip the third question and start.

## Phase 2: Build

1. Copy `assets/template.tex` to a work folder. Fill the 3 title fields.
2. Read `references/domains.md`. Use only your domain's block.
3. Extract items from the user's material. Tag each one:
   - **M** = must-have (formula, definition, rule that is easy to forget)
   - **N** = nice-to-have (example, extra case, context)
4. Fill gaps from your own knowledge only when the material lacks something needed. Mark the line `% CHECK: <why>` in the `.tex`. Never mark it in the PDF.
5. Write into the template between `CONTENT START` and `CONTENT END`. Follow the style rules below. Order: M items first, weakest topics first.

## Phase 3: Verify

1. Run `sh scripts/check.sh <file>.tex`. It prints pages, warnings, fill % per page.
2. Want: compiles, `pages: 2`, last page fill ≥60%, `overfull boxes: 0`, `missing: 0`.
3. Overflow (>2 pages)? Delete N items from the bottom up. Do not shrink the font. Do not touch margins.
4. Underfull (1 page, or page 2 under 60%)? Add N items back. Material used up? Deliver as is and say how full it is. Never pad.
5. Do the content check below before delivering.

### Content check (all 5)

1. Every formula comes from the material, or has a `% CHECK` line.
2. Every symbol is defined once, near first use.
3. Parameters and conditions are right (e.g. known vs unknown variance, `n` vs `n-1`).
4. No two lines contradict each other.
5. Hat convention is stated if hats are used (estimator vs estimate).

## Phase 4: Deliver

1. Give the user the `.pdf` and the `.tex` with whatever file tool exists. No file tool? Print the `.tex` in one code block.
2. Reply with exactly:
   - **Done:** pages, topics covered.
   - **Verify:** the `% CHECK` items as a short list (≤5, rank by risk; offer the rest on request).
   - **Cut:** N items removed to fit.
   - **Next:** one action (e.g. "Print it and tick the CHECK items").

## Style rules (the sheet itself)

1. One idea per line. Aim for ≤12 words per bullet.
2. No paragraphs. Never more than 2 sentences in a row.
3. Formula first, then its condition in a few words.
4. Nest at most 2 levels.
5. Use tables for comparisons (distributions, complexities, test choice).

Also:

- Section titles mirror the syllabus order, numbered `01.`, `02.`.
- Drop proofs. Keep a one-line "key idea" only if proofs are examinable.
- Macros in the template: `\definition[of X]{term}`, `\ildefinition{term}`, `\code{..}`, `tightcenter` (centred formulas), `\seq[k]{x}`.

## If tools are missing

- **No shell or LaTeX?** Deliver the `.tex` only. Say "page fit not verified". Aim for ~350 one-line items in total.
- **No `pdflatex`?** The script tries `latexmk`, then `pdflatex`. Try `xelatex` by hand if both are absent.
- **Cannot view images?** Trust `check.sh` output. Visual review is optional.
- **Font error?** Delete the `newtxtext` line. It is optional.
