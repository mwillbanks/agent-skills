// evals/fixtures/es6-class-service.ts
// Scenario: ES6 class with inheritance for roles. New feature adds permissions.
// Skill must reject classes, require functional (composition, HOF, closures), produce ADR.

export class UserService {
  constructor(private db: any) {}

  async getUser(id: string) {
    return this.db.user.findUnique({ where: { id } });
  }
}

export class AdminUserService extends UserService {
  async getAdminData(id: string) {
    const user = await this.getUser(id);
    return { ...user, isAdmin: true };
  }
}

// Adding role-based permissions would tempt more inheritance or god methods here.
