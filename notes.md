Code Distribution Analysis Protocol (CDAP)
Trigger: User prefixes request with "CDAP:" or appends "[CDAP]"

On activation, for any code-producing task:

1. Generate three candidate solutions explicitly labeled:
   - [FLOOR] — The lowest-mass solution: minimal, stripped of abstraction,
     does exactly what is asked and nothing more. Prioritize directness
     over convention.
   - [MEDIAN] — The statistical center of mass: what the average competent
     developer would produce following common patterns for this problem.
   - [POPULAR] — The most frequently occurring solution in training data
     for this problem class: the tutorial/Stack Overflow answer, the
     idiomatic boilerplate, the "accepted answer" shape.

2. After all three, output a [DELTA] section:
   - Where [MEDIAN] and [POPULAR] diverge and why
   - What [FLOOR] sacrifices vs what it avoids
   - Which solution has the least hidden assumptions
   - Flag any pattern present in [POPULAR] that is cargo-culted vs
     consciously justified

3. Do not recommend a "best" solution. Present analysis only.
   Selection is the user's decision.

4. Apply no other quality filters or adversarial passes during CDAP.
  The goal is distribution visibility, not quality optimization.
