---
layout: post
title:  "RESTFUL API with yii 1.x"
date:   2015-MM-DD
categories: yii, rest, api
---

Yii 1.x is not the best framework to write RESTFUL APIs. Its main problem it
the lack of good handling of HTTP verbs other than POST and GET. However, PUT
and DELETE become essential when one want to write a proper API. Fortunately,
it is easy enough to add the missing support to Yii.

First, write a proper route configuration. Edit `protected/config/main` file
and write something like this:

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

the last four lines of the `rules` will instruct Yii that GET/POST/PUT/DELETE
requests to `base_url/api` will be handled by the `ApiController` class within
the functions `actionIndex`, `actionCreate`, `actionUpdate`, `actionDelete`
respectively.

Then, it is necessary to write some basic code for handling the API calls. We
must at least 1) get the data and 2) authenticate the requests. Moreover, we
may also want to log calls and so on. We will do all this in the `beforeAction`
funcion of `ApiController`.
