---
name: security-audit
description: Auditing code changes for security vulnerabilities, risky patterns, and secrets exposure. Use when reviewing changes that touch authentication, authorization, input handling, external APIs, secrets, cryptography, or data persistence — or whenever asked to security-review a change before it lands.
---

# Security audit

Examine every changed file in full context and assess it across the categories below. Report findings by severity and conclude with a verdict.

## Categories

### Injection
- SQL injection (string-concatenated queries — use parameterized queries).
- Command injection (unsanitized input reaching a shell).
- Path traversal (user-controlled file paths without sanitization).
- Template, LDAP, and XML injection.

### Authentication and authorization
- Missing or bypassable authentication checks.
- Broken access control (user A can reach user B's data).
- Insecure session management (weak tokens, missing expiry, no invalidation on logout).
- JWT issues (algorithm confusion, `none` algorithm, missing signature verification).

### Secrets and sensitive data
- Hardcoded credentials, API keys, tokens, or passwords.
- Secrets committed to version control.
- Sensitive data logged or exposed in error messages.
- PII or sensitive data transmitted without encryption.

### Input validation
- Missing validation on user-supplied data.
- Trusting client-supplied values for security decisions.
- Type coercion that leads to unexpected behavior.

### Cryptography
- Weak algorithms (MD5/SHA1 for passwords, ECB mode, DES, RC4).
- Hardcoded IVs or salts.
- Insecure randomness for security purposes.

### Dependencies and supply chain
- New dependencies that are unvetted, unmaintained, or carry known CVEs.
- `eval`, dynamic `require`/`import`, or other dynamic code execution.

### Data exposure
- API responses returning more data than necessary.
- Debug endpoints or verbose error responses on production paths.

## Output

One finding per line:

```
[CRITICAL|HIGH|MEDIUM|LOW] category — file/path.ext:line — description — recommended fix
```

- **CRITICAL** — exploitable vulnerability, must fix before merge.
- **HIGH** — serious risk, fix before merge.
- **MEDIUM** — real concern, harder to exploit or limited impact.
- **LOW** — best-practice / defence-in-depth improvement.

Conclude with `SECURITY APPROVED` (no CRITICAL/HIGH) or `SECURITY REVIEW REQUIRED` (list the CRITICAL/HIGH findings again).

Report only what has a realistic attack vector — a concrete file, line, and fix for each finding. If you find a hardcoded secret, never include its value in the output.
