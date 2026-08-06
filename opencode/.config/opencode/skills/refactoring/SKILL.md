---
name: refactoring
description: Keeping the system consistent when changing existing code. Use whenever adding, removing, renaming, or changing the behavior of existing code — a rename across files, a changed function signature, an altered serialization shape, or reshaped data. Trigger even when the user says "clean up", "rename", "extract", or "change how X works" without saying the word refactor.
---

# Refactoring

A refactor is not done when the code compiles — it is done when everything that
depended on the old shape or behavior has been brought along with it. Every item
below is a place the old assumption can survive and turn green tests into a lie.

Account for each that applies to the change:

- Test data, fixtures, and helpers built around the old structure or behavior.
- Mapping and serialization expectations, and any contract-level checks.
- API and integration tests asserting the changed surface.
- Mocks, stubs, and test builders that construct or validate the changed parts.
- Documentation and examples describing the old behavior.

The bar: no reference to the old shape survives the change. Grep for the old
name, the old field, the old signature — every hit resolved, or consciously left
and justified.
