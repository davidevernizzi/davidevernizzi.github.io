---
layout: post
title:  "getByText does not catch href, but has href property"
date:   2020-03-29
tags: []
---

While testing with `@testing-library` I wanted to test the href of a link. The link came in the format `<a href="foo">bar</a>` and I wanted to check that `foo` was present. `getTextById` does not find `foo`, but can find `bar` and the element found has a `href` property. Therefore, the test becomes:

```javascript
expect(getByText(/bar/i).href).toBe('bar');
```
