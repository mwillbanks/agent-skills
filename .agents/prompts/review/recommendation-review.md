# Recommendation Review

Use this when you want actionable recommendations and patch guidance.

## Prompt

Perform a `recommendation-review` pass.

Requirements:
1. Produce concrete recommendations, not generic advice.
2. Include implementation guidance for each finding.
3. Distinguish safe immediate fixes vs larger follow-up work.
4. Prioritize by risk and engineering ROI.
5. Note testing and documentation implications.

Output:
- Prioritized findings
- Recommended fix plan
- Safe direct fixes (if applied)
- Follow-up sequence
