// evals/fixtures/monorepo-dup-package-b.ts
// Duplicate logic in another package.

export function isValidEmail(email: string): boolean {
  return /^[^@]+@[^@]+\.[^@]+$/.test(email);
}

export function createUserInPackageB(data: any) {
  if (!isValidEmail(data.email)) throw new Error("bad email");
  // ...
}
