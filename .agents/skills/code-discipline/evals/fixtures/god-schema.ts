// evals/fixtures/god-schema.ts
// Scenario: Single massive schema file (simulated 800+ line problem by comment + structure).
// Contains User, Product, Order, all relations, resolvers, types in one file.
// The skill must reject this as GOD file and mandate per-purpose files.

import { gql } from "apollo-server";

export const typeDefs = gql`
  type User {
    id: ID!
    email: String!
    name: String
    posts: [Post!]!
    profile: Profile
  }

  type Post {
    id: ID!
    title: String!
    author: User!
    comments: [Comment!]!
  }

  # ... imagine 200+ more lines of types, inputs, unions, interfaces here for Catalog, Inventory, Order, Payment, etc.

  type Query {
    users: [User!]!
    products: [Product!]!
  }

  type Mutation {
    createUser(input: CreateUserInput!): User!
    # ... many more
  }
`;

// Resolvers would be 400+ lines below: userResolvers, productResolvers, orderResolvers, relation resolvers all mixed.
// This file violates one-dedicated-file-per-schema-purpose.
export const resolvers = {
  Query: {
    /* ... */
  },
  Mutation: {
    /* ... */
  },
  User: { posts: () => {}, profile: () => {} },
  // dozens more
};
