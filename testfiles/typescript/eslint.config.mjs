// Flat ESLint config (ESLint 9+). The eslint LSP auto-discovers this file.
// Rules below are intentionally chosen so index.ts triggers visible
// diagnostics AND an auto-fixable rule (prefer-const) for code-action testing.
import js from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      // Auto-fixable -> use this to test the "eslint: fix" code action.
      'prefer-const': 'error',
      // Non-fixable warnings/errors -> use these to test diagnostics.
      'no-console': 'warn',
      '@typescript-eslint/no-unused-vars': 'warn',
    },
  },
);
