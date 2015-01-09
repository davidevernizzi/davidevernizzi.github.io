---
layout: post
title:  "Migrations with Yii"
date:   2015-MM-DD
categories: yii, migrations
---

Migrations in yii allow a clean way to change your database schema. Using
migrations we can add tables, colummns or change fields type.

To use a migration in Yii, just create a new one typing

```
yiic migrate create migration_name
```

and a new file will be created under the directory `protected/migrations`. The
name of the file has a prefix which indicates the timestamp when the migration
was created.

The file has two functions `up` and `down` and two commented functions `safeUp`
and `safeDown`. The difference is that safeUp and safeDown will use
a transaction 
