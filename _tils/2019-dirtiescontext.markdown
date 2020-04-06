---
layout: post
title:  "Use @Dirtiescontext to invalidate a context in SpingBoot JUnit tests"
---

In JUnit with SpringBoot the context is shared among different testsuites (at least in our setup).

This implies that if the DB is changed by a test, it stays changed for the subsequent tests.

To inform Spring that the context must be refreshed, use the annotation `@DirtiesContext`.
