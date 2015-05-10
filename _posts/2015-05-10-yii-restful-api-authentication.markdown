---
layout: post
title:  "Authentication of RESTFUL APIs"
date:   2015-05-10
categories: yii, rest, api, authentication
---

Authentication nin a RESTFUL api is crucial. You don't want to give
unauthorized access to private resources, nor to allow dangerous operations.
There are many ways to authenticate a request. For instance:

1. HTTP basic auth
2. authorization token
3. HMAC

I will not talk about HTTP basic auth here because it is the less handy. The
other two are interesting and deserve some attention.

== Authorization token ==
Using an authorization token is much easier than using an HMAC, but also lesser
secure. In particulare, the authorization token authenticate the request,
allows to verify the authorization, but does not protect the integrity of the
request. Nor it avoids replay attacks.

In order to use this method, it is enough to pass in the HTTP request a header 
containing a secret shared between client and server. Note that the secret is
passed in plaintext, therefore it is necesary to protect the confidentiality of
the communication with other means (usually with a TLS channel).

On the server side, one must retrieve the secret from the request, and verify
with a list of allowed secrets; if it is in the list, then the request was
authorised. In theory it is possible to define any custom header,
the `Authorization` standard header was defined for this scope.
Unfortunately, while it is rather easy to access a custom header from PHP (one
will find it in the `$_SERVER` array), to retrieve the `Authorization` header
it is necessary some more work:

```php
    function getAuthorizationHeader() {
        $headers =  apache_request_headers();
        if (isset($headers['Authorization'])) {
            return $headers['Authentication'];
        }
    }
```

Once the server has the authorization token, it must check whether it is valid.
To to this, it needs a table of allowed tokens. The table must also link the
token with the user. Let's say our table has the following schema: `id,
user\_id, token, is\_expired`, the server can do something like:

```php
    1. get token from header
    2. search token
    3. verify is_authorized
```

== HMAC ==
HMAC is more secure than authorization tokens, but also more difficult to
implement, test and use.

HMAC is computed by concatenating the parameters with a secret shared with the
server and by computing an hash over that string.

The first problem is what to exactly sign. A reasonable list is:

1. the parameters, lower case, alphabetically ordered
2. the HTTP verb
3. the resource
4. a timestamp

A second problem is how to transport such a signature. A good solution is to
use the `authorization` HTML header. In this case you have to choose a format
for the header because, AFAIK there is not a standard one. The header must
contains the indication of which user computed the signature, the hash function
used and the signature itself. I used the following format:

```
Authorization: hmac johndoe:417b84bd8cc348b246aaf66ac6654c8bc9f3f340
```

so that by looking at it the server knows the user that made the request.
Knowing the user is fundamental because the server must look into its database
to retrieve the shared secret. Once the server retrieved the secret, it can
proceed with the verification of the signature:

1. take all the request parameter, order alphabetically and turn to lower case
2. concatenate the parameters, the HTTP verb, the resource and the timestamp,
   just as the client did
3. concatenate the shared secret and compute the digest
4. verify that its digest matches the signature
5. verify that the request is fresh. This is done by the timestamp is not too 
old. What "too old" means, depends on the application.

Of course, since the client and the server usually live in two different
computers, the client must also send the exact timestamp used to compute the
signature. Again, this is passed through the HTTP header. A good candidate
would be the `Date` header.

Testing authenticated API calls is difficult. The main problems come from the
timestamp: since each call must be short lived, in theory one should a new hash
each time he performs a request. Of course this quickly becomes a nightmare
when the API is under development, so I suggest to first develop the businness
logic without any signature verification, and only when that part is OK, turn
on the security stuff for a final test.
