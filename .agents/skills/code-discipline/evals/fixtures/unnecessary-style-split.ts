// evals/fixtures/unnecessary-style-split.ts
// Scenario: Styles split into separate file with no ownership/reuse benefit.
// File and Style Organization Rules violated. Should be colocated.

import { css } from "styled-components";

export const buttonStyles = css`
  padding: 8px 16px;
  background: blue;
  color: white;
`;

// Button.tsx would import this for no good reason (single consumer, local styles).
