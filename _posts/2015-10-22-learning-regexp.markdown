---
layout: post
title:  "Learning RegExp"
date:   2015-10-22
categories: regexp, sublime
---

Knowing regexp is always a good tool. They can be useful for many tasks: from
searching strings to manipulating texts. A fun way to learn regexp is by using
[this site]( http://regexcrossword.com/); it basically is a crossword game
where definitions are in facts regular expressions.

Once you have learn them, you can visualize and debug them with:

* https://www.debuggex.com/
* http://regviz.org/

Another nice thing you can do with regexp is to generate code from text you
already have. For example, you can take the description of a SQL table and
write a migration that creates that table only by using regexp.

For this task sublime text is a mighty ally since it can highlight the matched
pattern. Let's see how to do this.

* First copy the table definition from your preferred SQL editor. Here I used
  adminer (which I way recommend!).

![Our starting table, straight copied from adminer]({{ site.url }}/images/sublime_sql.png)

* Then open the search/replace feature and start typing the regexp. Take
  advantage of sublime's capacity to highlight matches, so you will not miss
  anything.

![Highlighting in action]({{ site.url }}/images/sublime_highlight.png)

![The complete regexp]({{ site.url }}/images/sublime_replace.png)

* Finally use the partial matches to build your migration code.

![The complete regexp]({{ site.url }}/images/sublime_replaced.png)

In my example the starting code was:

```
id  int(11) Auto Increment   
user_id int(11) NULL     
client_id   varchar(255) NULL    
client_secret   varchar(255) NULL    
status  int(11) NULL     
created_at  timestamp [CURRENT_TIMESTAMP]    
last_use    timestamp [0000-00-00 00:00:00]
```

on which I used this regexp:

```
^([a-zA-Z_]*)\t([^\t]*)(\t )*$
     ^        ^    ^     
     |        |    |     
 field name   | field type
              |          
        adminer's separator
```

to achieve the final code:

```php
$this->createTable('tbl_token', array(
    'id' => 'int(11) Auto Increment',
    'user_id' => 'int(11) NULL',
    'client_id' => 'varchar(255) NULL',
    'client_secret' => 'varchar(255) NULL',
    'status' => 'int(11) NULL',
    'created_at' => 'timestamp [CURRENT_TIMESTAMP]',
    'last_use' => 'timestamp [0000-00-00 00:00:00]',
);
```
Of course I had to manually add the first and the last line, but it's not a big
deal if you have to handle large tables and your little regexp will save you
tens of manual line definition.

Note that the last `(\t )*` is not really necessary, but it allows us to be
sure that we matched the whole line and that we didn't miss anything.
