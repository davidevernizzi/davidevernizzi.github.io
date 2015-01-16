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
and `safeDown`. The difference is that `safeUp` and `safeDown` will automatically
roll back if the migration did not finish correctly. Always use `safeUp` and
`safeDown`, otherwise you could end in the situation where a migration only
partially finished can't be undone. This happens, for instance if you create
many three fields `a, b, c` in the migration and it fails to create `b`,
you will not be able to undo the migration because it will fail tring to drop field
`c`. Similarly, it will also fail to reapply the migration because it will try
to recreate field `a`. And you get stuck.

When creating a column (either via the `createTable` or the `addColumn`) you
must specify the columnt type. You can use one of the types specified by the
`getColumntType` which are:

* pk and bigpk: an auto-incremental primary key type, will be converted into
* "int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY" or "bigint(20) NOT NULL
* AUTO_INCREMENT PRIMARY KEY"
* string: string type, will be converted into "varchar(255)"
* text: a long string type, will be converted into "text"
* integer: integer type, will be converted into "int(11)"
* bigint: integer type, will be converted into "bigint(20)"
* boolean: boolean type, will be converted into "tinyint(1)"
* float: float number type, will be converted into "float"
* decimal: decimal number type, will be converted into "decimal"
* datetime: datetime type, will be converted into "datetime"
* timestamp: timestamp type, will be converted into "timestamp"
* time: time type, will be converted into "time"
* date: date type, will be converted into "date"
* binary: binary data type, will be converted into "blob"
