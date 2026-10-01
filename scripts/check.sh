#!/bin/sh
# usage: sh check.sh sheet.tex   -> compiles, reports pages, warnings, fill
f="${1:?usage: check.sh file.tex}"
b="${f%.tex}"
if command -v latexmk >/dev/null; then
  latexmk -pdf -interaction=nonstopmode -halt-on-error "$f" >"$b.build.log" 2>&1
elif command -v pdflatex >/dev/null; then
  pdflatex -interaction=nonstopmode -halt-on-error "$f" >"$b.build.log" 2>&1
  pdflatex -interaction=nonstopmode "$f" >>"$b.build.log" 2>&1
else
  echo "NO LATEX COMPILER: deliver .tex only; page fit UNVERIFIED"
  exit 2
fi
[ -f "$b.pdf" ] || {
  echo "COMPILE FAILED. Last errors:"
  grep -n -m5 -A2 '^!' "$b.log" "$b.build.log" 2>/dev/null
  exit 1
}
p=$(pdfinfo "$b.pdf" 2>/dev/null | awk '/^Pages:/{print $2}')
echo "pages: ${p:-unknown} (want 2)"
echo "overfull boxes: $(grep -c 'Overfull' "$b.log")  (want 0)"
echo "missing refs/chars: $(grep -c -E 'Undefined|Missing character' "$b.log")  (want 0)"
if command -v pdftotext >/dev/null; then
  # fill = rightmost text edge / page width. Columns fill left to right, so this ~ share of the page used.
  pdftotext -bbox "$b.pdf" - 2>/dev/null | awk '
    /<page /{pg++; match($0,/width="[0-9.]+"/); w[pg]=substr($0,RSTART+7,RLENGTH-8)+0}
    /<word /{match($0,/xMax="[0-9.]+"/); x=substr($0,RSTART+6,RLENGTH-7)+0; if(x>m[pg])m[pg]=x}
    END{for(i=1;i<=pg;i++) printf "page %d fill: %d%%\n", i, 100*m[i]/w[i]}'
fi
last=$(pdftotext -bbox "$b.pdf" - 2>/dev/null | awk '/<page /{pg++;match($0,/width="[0-9.]+"/);w=substr($0,RSTART+7,RLENGTH-8)+0} /<word /{match($0,/xMax="[0-9.]+"/);x=substr($0,RSTART+6,RLENGTH-7)+0;if(x>m[pg])m[pg]=x} END{printf "%d",100*m[pg]/w}')
if [ "${p:-0}" -gt 2 ]; then
  echo "RESULT: OVERFLOW, cut nice-to-have items"
elif [ "$p" = "2" ] && [ "${last:-0}" -ge 60 ]; then
  echo "RESULT: OK"
elif [ "$p" = "2" ]; then
  echo "RESULT: PAGE 2 UNDER 60% FULL. Add nice-to-have items if material remains; else deliver and say so"
else echo "RESULT: UNDERFULL (1 page). Add nice-to-have items if material remains; else deliver and say so"; fi
