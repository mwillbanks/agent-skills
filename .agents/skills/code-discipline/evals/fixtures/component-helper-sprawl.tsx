// evals/fixtures/component-helper-sprawl.tsx
// Scenario: React component that has grown 5+ local helpers (format, normalize, build, resolve).
// Violates component-logic rules. Skill must force move to proper layer or inline simple cases.

function formatName(user: any) {
  return `${user.first} ${user.last}`;
}
function normalizePrice(p: number) {
  return p.toFixed(2);
}
function buildDisplayLabel(item: any) {
  return `${item.sku} - ${item.name}`;
}
function resolveStockStatus(qty: number) {
  return qty > 0 ? "In stock" : "Out";
}
function sanitizeInput(v: string) {
  return v.trim().toLowerCase();
}

export function ProductCard({ product, user }: any) {
  const name = formatName(user);
  const price = normalizePrice(product.price);
  const label = buildDisplayLabel(product);
  const stock = resolveStockStatus(product.qty);
  const cleaned = sanitizeInput(product.searchTerm || "");

  return (
    <div>
      <h2>{name}</h2>
      <span>{price}</span>
      <span>{label}</span>
      <span>{stock}</span>
      <input defaultValue={cleaned} />
    </div>
  );
}
