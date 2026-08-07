# Framework idioms

Single source for the "prefer the framework mechanism over the hand-rolled
equivalent" rule. The **planner**, **plan-reviewer**, and **implementer** all
point here instead of each carrying their own copy of the catalog.

For any cross-cutting concern — error handling, validation, configuration, type
conversion, dependency wiring — check whether the framework already provides a
declarative or hook-based mechanism before reaching for a hand-rolled one.

## Catalog

- **Serialization / type conversion** — JPA `@Convert` + `AttributeConverter`,
  not manual JSON (de)serialization in getters/setters.
- **Error handling** — Camel `onException().handled(true)`, not try/catch inside
  a processor.
- **Dependency wiring** — CDI `@Produces`, not manually instantiating a
  dependency and threading it through constructors.

The pattern generalizes past these three: whenever code reaches for boilerplate a
framework annotation or hook would eliminate, the framework mechanism wins.

## Per role

- **Planner** — plan the idiom from the start. When the request describes a
  lower-level approach but a standard mechanism exists, plan the mechanism and
  flag the trade-off so the choice is explicit.
- **Plan-reviewer** — raise a `NON-IDIOMATIC` flag naming the idiomatic
  alternative and the reason.
- **Implementer** — if the plan asks for the hand-rolled form, note the
  idiomatic alternative in your response, then implement the plan as written. Do
  not deviate unilaterally.
