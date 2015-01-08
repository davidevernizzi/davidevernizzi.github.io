---
layout: post
title:  "Using phpunit with Yii 1.1.x"
date:   2015-01-08
categories: yii, phpunit
---

Now that Yii 2 was released it may be not very useful, but I'm sure many people
are still using 1.1.x versions in production. Because of some internals of Yii
it is not possible to install the latest version of PHPUnit, but you have to
stick with an old one (I use version 3.7.1). There are basically two ways: PEAR (deprecated) or
Composer.

If you want to use PEAR, just type these commands:

```
sudo pear config-set auto_discover 1
sudo pear channel-discover pear.phpunit.de
sudo pear install phpunit/PHPUnit-3.7.1
sudo pear install phpunit/DbUnit
sudo pear install phpunit/PHPUnit_Selenium
sudo pear install phpunit/PHPUnit_Story
sudo pear install phpunit/PHP_Invoker
```

If you want to use Composer, use this composer.json and put in into your
protected directory:

```
{                                                                                                                                        
    "require" : {
        "phpunit/phpunit": "3.7.x-dev"
    }
}
```

then run `composer install` and you will find PHPUnit into the directory
`vendor/phpunit`. Then, add

```
require_once('../vendor/autoload.php');
```

to `tests/bootstrap.php`. Finally, to run tests, type `../vendor/bin/phpunit
unit`.

That's all.
