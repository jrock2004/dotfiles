# General Instructions

## Interaction Rules

### Critical Review Mode

- Always challenge assumptions and propose alternatives to code or reasoning.
- Correct weak or incorrect reasoning plainly; suggest better approaches.

### General Interaction

- Never say “You’re absolutely right”.
- No anthropomorphizing (no “I’m sorry”, “I’m happy to help”).
- Avoid comments unless:
  1. Logic is non-obvious or counterintuitive.
  2. Code behavior differs from common expectations.

---

## Hallucination Prevention

- Before suggesting an API/method, confirm it exists in the latest stable library release.
- If unsure, state uncertainty and offer an alternative.
- If told a suggestion doesn’t exist, treat it as a hallucination and give a new solution.

---

## TypeScript Rules

- Assume high TypeScript/JavaScript proficiency.

- Never use `any`.
  - If the value shape is known or can be derived from context, define a **named** `interface` or `type` instead of using `unknown`.
  - Use `unknown` only for truly generic values that cannot be typed without guesswork.
  - For mocks, use `Partial<Type>` instead of removing required props or using `any`.
  - For maps, use `Record<string, ValueType>` with a defined `ValueType`.

- Use strong types everywhere.
- Use **interfaces for data structures**; **type aliases for unions/utility compositions**.
- Prefer **explicit return types** for exported functions and public APIs.
- When `unknown` is used, **immediately narrow** via type guards, discriminated unions, or schema inference (e.g., `z.infer<typeof schema>`).

- Prefer **discriminated unions** over boolean flags for state.
- Avoid non-null assertions (`!`); use guards or early returns.
- Use `as const` for static data and `satisfies` to preserve literal types without widening.
- Keep module-level types **exported and reused** (no duplicate inline shapes).

- Use optional chaining (`?.`) and nullish coalescing (`??`).

- Place types/interfaces at the end of component files unless for props.
- Non-prop reusable types go in `types.ts`.

---

## React Rules

- Functional components + hooks only.
- Follow hooks rules (no conditional hooks).
- Keep components small, semantic, and accessible.

---

## Naming Conventions

- PascalCase: components, interfaces, type aliases.
- camelCase: variables, functions, methods.
- `_` prefix: private class members.
- ALL_CAPS: constants.
- Import order: React → libraries → local modules → types → styles.

---

## Error Handling

- Wrap async ops in try/catch.
- Use React error boundaries.
- Log errors with context.

---

## Testing Rules

### Framework & Libraries

- Vitest runner.
- React Testing Library (`@testing-library/react`).
- `@testing-library/user-event` for events.
- `@testing-library/jest-dom` for matchers.
- `msw` for network mocks.
- `vi.fn()` for mocks.

### File Structure

- Colocate tests: `Component.tsx` → `Component.test.tsx`.
- `.test.tsx` for components, `.test.ts` for utilities.
- Mocks/utilities → `__mocks__/`.

### Query Priority

1. `getByRole`
2. `getByLabelText`
3. `getByPlaceholderText`
4. `getByText`
5. `getByTestId` (only if none above work)

### Guidelines

- Integration-style: render → interact → assert.
- Don’t test internal implementation details.
- Avoid `.className` or deep DOM queries.
- No large DOM snapshots.
- Don’t test library internals; test your usage.
- Prefer `userEvent` over `fireEvent`.
- Await async actions.
- Use `findBy...` for async elements.
- No arbitrary timeouts; use `waitFor` with explicit expectations.
- Keep tests fast: avoid over-mocking and unnecessary waits.

### Running Tests

- Use `pnpm test:ci` for continuous integration runs.
- Use `pnpm test:coverage` to run tests with coverage.
- Prefer `pnpm` over `npm` or `yarn` in all scripts and docs.
- Keep test output clean; avoid extra logging unless debugging.

---

## MSW Rules

- Model handlers from the API’s perspective.
- Single `mocks/handlers.ts` for happy paths; override per test with `server.use(...)`.
- Scope handlers by resource (`/users`, `/posts`).
- Strongly type params/bodies; no `any`.
- Don’t assert requests directly; assert UI/state changes.
- Extract reusable predicates for query/body matching.
- Keep mocks minimal and realistic.
- Node tests: `setupServer(...handlers)` with global hooks.
- Default: mock what tests depend on; passthrough the rest.

**Additional Best Practices (from MSW docs):**

- Use `{ once: true }` for one-time overrides.
- Keep handler files small; split by feature if needed.
- Use `onUnhandledRequest: 'error'` in setup to catch missing mocks.

**MSW Example – Base Setup**

    // mocks/handlers.ts
    import { http, HttpResponse } from 'msw';

    export const handlers = [
      http.get('/api/user/:id', ({ params }) =>
        HttpResponse.json({ id: params.id, name: 'Ada Lovelace' })
      ),
    ];

    // mocks/server.ts
    import { setupServer } from 'msw/node';
    import { handlers } from './handlers';

    export const server = setupServer(...handlers);

    // vitest.setup.ts
    import { afterAll, afterEach, beforeAll } from 'vitest';
    import { server } from './mocks/server';

    beforeAll(() => server.listen({ onUnhandledRequest: 'error' }));
    afterEach(() => server.resetHandlers());
    afterAll(() => server.close());

**MSW Example – Runtime Override in Test**

    import { http, HttpResponse } from 'msw';
    import { server } from '@/mocks/server';

    test('shows alternate user', async () => {
      server.use(
        http.get('/api/user/:id', () =>
          HttpResponse.json({ id: '42', name: 'Grace Hopper' })
        )
      );
      // ...render, interact, assert
    });

---

## Accessibility

- All interactive elements must have an accessible name.
- Prefer role-based queries for a11y checks.
- Use `data-testid` only if no other stable selector exists.

---

## Things to Avoid

- Large DOM snapshots.
- Brittle selectors.
- Mocking React components (except unavoidable framework constraints, e.g., Next.js router).
