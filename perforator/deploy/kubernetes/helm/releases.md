<!--
IMPORTANT: read this when updating release notes.

Here is the format used:

```
# Version/Unreleased

Fixes:

+ Description (PR or commit[1])

Enhancements:

+ Description (PR or commit)

Internal changes:

+ Description (PR or commit)
```

1: If you are sending patch to GitHub, specify PR. Otherwise (if you are sending patch to internal monorepo), leave unset and then specify Git commit.
-->

# 0.2.6
Enhancements:
+ Allow enabling/disabling certain perforator microservices
+ Allow to deploy extra objects

Fixes:
+ Fix storage service declaration

# 0.2.5

Enhancements:
+ Allow customizing environment variables for all components
+ Upgrade perforator to [v0.0.3](https://github.com/yandex/perforator/releases/tag/v0.0.3)

# 0.2.4

Fixes:
+ Fix mount extra volumes (#30)

Enhancements:
+ Add default images for all components (677ca2b)
+ (experimental) Add support for automated migrations (see `.databases.{postgresql,clickhouse}.migrations` for details) (1d38dff)

Internal changes:
+ Change auto-generated CA subject (75f12f2)

# 0.2.3

Fixes:
+ Fix CA certificate recreating on helm upgrade (6b9207e)

Enhancements:
+ Support custom CA for agent-storage communication (6b9207e)

# 0.2.2

Enhancements:
+ Support custom CA for ClickHouse, PostgresSQL and object storage (#25)

# 0.2.1

Fixes:
+ Fix dnsPolicy overrides (#16)
+ Fix duplicated spec.tls in ingresses (#17)

# 0.2.0

Fixes:
+ Use prefix match for ingresses (e492fd8)

Enhancements:
+ Always recreate pods on helm upgrade (4ccce88)

# 0.1.0

Initial release
