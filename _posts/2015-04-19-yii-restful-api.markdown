---
layout: post
title:  "RESTFUL API with yii 1.1.x"
date:   2015-04-19
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
requests to `BASEURL/api` will be handled by the `ApiController` class within
the functions `actionIndex`, `actionCreate`, `actionUpdate`, `actionDelete`
respectively.

Then, it is necessary to write some basic code for handling the API calls. We
must at least 1) get the data and 2) authenticate the requests. Moreover, we
may also want to log calls and so on. We will do all this in the `beforeAction`
funcion of `ApiController`.

To get data from the request we must take into account the type of the request.
In the case of a GET, data will be into the `$\_GET` variable. The POST can be
either a form request either a raw data request (typically a JSON one). In the
first case its data will be in the `$\_POST` variable, while in the second case
we must fetch data from PHP raw input stream which can be accessed via
`php://input`. The PUT and the DELETE only have raw input.

In order to get data from raw input stream, we can write a very simple data
function like:

```php
    private function getContent()
    {
        if (null === $this->content)
        {
            if (0 === strlen(($this->content = file_get_contents('php://input'))))
            {
                $this->content = false;
            }
        }

        return $this->content;
    }
```

Next, we can use such a function to get data according to the request type:

```php
        switch($_SERVER['REQUEST_METHOD']) {
        case 'GET':
            $this->data = $_GET;
            break;
        case 'POST':
            $this->data = CJSON::decode($this->getContent());
            break;
        case 'DELETE':
            $this->data = CJSON::decode($this->getContent());
            break;
        case 'PUT':
            $this->data = CJSON::decode($this->getContent());
            break;
        default:
            // raise some error here
            break;
        }
```

In a next post, I will talk about authentication.
