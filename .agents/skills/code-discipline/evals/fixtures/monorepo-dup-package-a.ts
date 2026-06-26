// evals/fixtures/monorepo-dup-package-a.ts
// Simulates duplication across packages. Both A and B have nearly identical local isValidEmail.

export function isValidEmail(email: string): boolean {
  return /^[^@]+@[^@]+\.[^@]+$/.test(email);
}

export function createUserInPackageA(data: any) {
  if (!isValidEmail(data.email)) throw new Error("bad email");
  // ...
}
