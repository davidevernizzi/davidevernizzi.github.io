Safari and Chrome parse JSON differently. In particular the following JSON will be valid for Safari (at least in version 9.0.2, but not in version 9.0.1) and invalid in Chrome:

```Json
{
   "key": "\$"
}
```

Chrome is right since the definition of JSON mandates that  after a \ only the following elements are accepted: `" \ / b f n r t u(followed by 4 digits)`
