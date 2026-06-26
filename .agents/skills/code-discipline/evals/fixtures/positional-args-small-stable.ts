// Scenario: a tiny helper with a small, fixed positional signature.
// Keep this positional unless there is a real variance reason to change it.

export function mixRgb(red: number, green: number, blue: number) {
  return `rgb(${red}, ${green}, ${blue})`;
}
