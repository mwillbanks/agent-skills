// evals/fixtures/functional-composition-auth.ts
// Positive/compliant functional style (for contrast or "already good" review).
// Uses closures, delegation, higher-order guards. No classes.

type User = { id: string; roles: string[] };
type Permission = string;

function withRole(required: Permission) {
  return (handler: (user: User, ...args: any[]) => Promise<any>) =>
    async (user: User, ...args: any[]) => {
      if (!user.roles.includes(required)) throw new Error("Forbidden");
      return handler(user, ...args);
    };
}

export const getUserProfile = withRole("user")(
  async (_user: User, id: string) => {
    // implementation using injected deps via closure
    return { id, profile: "..." };
  },
);

export const getAdminReport = withRole("admin")(async (_user: User) => {
  return { report: "sensitive" };
});
