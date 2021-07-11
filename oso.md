# oso

Written in Rust to make for embedding in multiple languages including Go, JS, Python, Java.

The policy language (Polar) is a prolog variant.

No open-source server version.

Management features (eg: auditing) is seen as an enterprise feature.

Provides [RBAC patterns](https://docs.osohq.com/java/learn/roles.html)

## oso vs opa

How the policy engine handles data is the key difference. The OPA engine requires data to be pushed/pulled to/from the engine, which it retains in memory for use in policy. Whereas Oso is more tightly coupled with the application. It uses the application's state, objects and methods directly rather than maintaining data separately.

Other dimensions
- deployment: OPA can be embedded library or deployed as a HTTP service. Oso is embedded only.
- management: OPA can log decisions and upload them to a central service whilst masking PII. Oso doesn't yet have this capability, and it looks like it will part of the paid enterprise product.
- policy language: Polar vs Rego. Both are logic programming variants.
- application language: OPA is Go only. Polar is multi-language.
- usage: OPA is in much wider usage. Oso is the new kid on the block.

See:

- [HN discussion](https://news.ycombinator.com/item?id=25444538])
- [Design principles](https://github.com/osohq/oso/blob/dec124f7ebad67a3658c10712832401d80cbec9a/docs/content/any/project/design-principles.md)
