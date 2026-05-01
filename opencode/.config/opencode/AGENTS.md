# Global Agent Instructions

Personal preferences and conventions that apply across all projects.

---

## Testing

- Use the **Given-When-Then** naming structure for all tests.
  - `given<context>_when<action>_then<expected outcome>`
  - Example: `givenUserIsLoggedOut_whenLoginWithValidCredentials_thenRedirectsToDashboard`
  - Omit the `when` part when it does not add value.
    - Example:  `whenValidating`
- Test names should read as a specification, not an implementation description.

---

## Java Code Style

- Prefer `var` for local variable declarations where the type is clear from context (Palantir style).
  - Good: `var result = someService.compute();`
  - Avoid: `SomeComplexType result = someService.compute();`

---

## General

- Prefer editing existing files over creating new ones.
- Do not add unnecessary comments or filler code.
