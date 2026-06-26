// Scenario: recursion and hoisting make a declaration the clearer shape.
// This is the counterexample that should not be converted to an arrow function.

export function walkTree(node: TreeNode | null): string[] {
  if (!node) {
    return [];
  }

  return [node.value, ...walkTree(node.left), ...walkTree(node.right)];
}

type TreeNode = {
  value: string;
  left: TreeNode | null;
  right: TreeNode | null;
};
