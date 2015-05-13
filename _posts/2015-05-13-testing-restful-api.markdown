---
layout: post
title:  "Testing a RESTful API with php and curl"
date:   2015-05-13
categories: php, rest, api test
---

Testing a RESTful API can be tricky, but it is totaly feasible. To keep things
as easy as possible I use `curl` to do all the calls. To clean the code as
clean as possible, instead of using the PHP implementation of `curl`, I prefer
to directly call the `curl` command.

By default `curl` does GETs, but of course it is possible to use other verbs by
using the `-X` switch. Beside setting the verb, there are two other things to
setup: the headers and the data. This is done with the switched `-H` and `-d`,
except for the GET which takes data on the url.

Here are two little functions that contructs the GET and the other requests:

```php
    public static function get($resource, $payload='', $header='')
    {
        $headerStr = "-H 'Content-Type: application/json'";
        if (is_array($header)) {
            foreach($header as $key => $value) {
                $headerStr .= " -H '$key: $value'";
            }
        }
        $apiUrl = self::$apiUrl;
        $cmd = "curl $headerStr '$apiUrl$resource/$payload' 2> /dev/null";
        $output = shell_exec($cmd);
        return $output;
    }

    private static function call($verb, $resource, $payload, $header)
    {
        $headerStr = "-H 'Content-Type: application/json'";
        if (is_array($header)) {
            foreach($header as $key => $value) {
                $headerStr .= " -H '$key: $value'";
            }
        }
        $apiUrl = self::$apiUrl;
        $cmd = "curl $headerStr -d '" . CJSON::encode($payload) . "' -X $verb '$apiUrl$resource' 2> /dev/null";
        $output = shell_exec($cmd);
        return $output;
    }
```
