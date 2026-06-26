// Scenario: the file still uses function declarations even though hoisting is not needed.
// This eval checks syntax cleanup without mixing in architecture changes.

export function formatDisplayName(firstName: string, lastName: string) {
  return `${firstName} ${lastName}`.trim();
}

export function buildGreeting(firstName: string) {
  return `Hello ${firstName}`;
}
