---
layout: post
title:  "RESTFUL API with yii 1.1.x"
date:   2015-MM-DD
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

HMAC is computed with ...

The first problem is what to sign. A reasonable list is:

1. the parameters, lower case, alphabetically ordered
2. the HTTP verb
3. the resource
4. a timestamp

transported within the authorization header

format fo the authorizartion header

verfication process

test
+ client
+ difficulties due to timestamp + expiration
