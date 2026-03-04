---
name: visual-audit
description: >-
  Performs adversarial visual audit of Beamer slides checking for overflow, font
  consistency, box fatigue, and layout issues. Triggers on: "visual audit",
  "check the slides", "audit slide layout".
argument-hint: "[TEX filename]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Visual Audit of Slide Deck

Perform a thorough visual layout audit of a Beamer slide deck.

**Input:** `$ARGUMENTS` — path to `.tex` file in `Slides/`.

**Talk files:** !`ls Slides/*.tex 2>/dev/null | head -5`

---

## Steps

1. **Read the slide file** specified in `$ARGUMENTS`

2. **Compile and check for overfull hbox warnings:**
   ```bash
   cd slides && TEXINPUTS=../preambles:$TEXINPUTS xelatex -interaction=nonstopmode $ARGUMENTS
   ```

3. **Audit every slide for:**

   **OVERFLOW:** Content exceeding slide boundaries
   **FONT CONSISTENCY:** Inline font-size overrides, inconsistent sizes
   **BOX FATIGUE:** 2+ colored boxes on one slide, wrong box types
   **SPACING:** Missing negative margins, crowded content
   **LAYOUT:** Missing transitions, missing framing sentences, semantic colors

4. **Produce a report** organized by slide with severity and recommendations

5. **Follow the spacing-first principle:**
   1. Reduce vertical spacing with negative margins
   2. Consolidate lists
   3. Move displayed equations inline
   4. Reduce image/SVG size
   5. Last resort: font size reduction (never below 0.85em)
