# Global Agent Instructions

Personal preferences and conventions that apply across all projects.

## Decision Framework

Evaluate every solution against: correctness, security, performance,
maintainability, testability.

## Conventions

- **Java**: prefer `var` for local declarations where the type is clear from
  context (Palantir style). `var result = someService.compute();`, not
  `SomeComplexType result = someService.compute();`.
- **Test naming**: Given-When-Then describing behavior, not implementation —
  `givenEmptyRepository_whenSearching_thenReturnsEmptyList`.
- **Dependencies**: reach for the standard library, then an existing project
  dependency, before adding a new one. Do not add a dependency for a small
  utility without clear justification.
