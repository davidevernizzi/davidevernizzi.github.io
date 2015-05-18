---
layout: post
title:  "Advanced REST routing with yii"
date:   2015-MM-DD
categories: yii, rest, routing
---

Here is another post on the REST API written using yii 1.1.x. I know that the
framework is not suitable at all for this job. And it's also old. But I'm
having fun coding my API, so let's continue.

In my [first post](http://www.vernizzis.it/blog/yii-restful-api/) about this topic I had used some very simple and basic
routes to ust GET, POST, PUT and DELETE verbs correctly:

```php
      'components'=>array(
          ...
          'urlManager'=>array(
              'urlFormat'=>'path',
              'rules'=>array(
                  '<controller:\w+>/<id:\d+>'=>'<controller>/view',
                  '<controller:\w+>/<action:\w+>/<id:\d+>'=>'<controller>/<action>',
                  '<controller:\w+>/<action:\w+>'=>'<controller>/<action>',
                  array('api/index', 'pattern'=> 'api/', 'verb' => 'GET'),
                  array('api/create', 'pattern'=> 'api/','verb' => 'POST'),
                  array('api/update', 'pattern'=> 'api/','verb' => 'PUT'),
                  array('api/delete', 'pattern'=> 'api/','verb' => 'DELETE'),
              ),  
          ),  
          ...
```

which works, but have the problems of being hard-linked to a specific
controller (`ApiController`, in this case). It is very easy to generalize it to
adapt to any controller:


```php
      'components'=>array(
          ...
          'urlManager'=>array(
               'urlFormat'=>'path',
               'rules'=>array(
                   array('<controller>/index', 'pattern'=> '<controller:\w+>/*', 'verb' => 'GET'),
                   array('<controller>/create', 'pattern'=> '<controller:\w+>/', 'verb' => 'POST'),
                   array('<controller>/update', 'pattern'=> '<controller:\w+>/*', 'verb' => 'PUT'),
                   array('<controller>/delete', 'pattern'=> '<controller:\w+>/*', 'verb' => 'DELETE'),
               ),
           ),
          ...
```

Note that I put a `\*` after some of the `<controller:\w+>/\*`. This is needed
because otherways, making a GET `http://url-to-api/index.php/foo/1` would not
result into the GET of the foo object with `id=1`, but would result into a call
to the `action1` of the `FooController` (beause yii would automatically bind
the first parameter after the controller name to the action name). Of course,
this is not necessary with the POST because it is not supposed to have
a precise endpoint after the resource name.
