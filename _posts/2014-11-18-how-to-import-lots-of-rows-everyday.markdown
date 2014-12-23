---
layout: post
title:  "How to import lots of rows on MySql"
date:   2014-11-18
categories: mysql
---

Let’s say you have a lot of data to import. Let’s say you don’t want to do it everyday without any downtime. Here is how I do this.

As an example, I will use a table that contains the customer base. Let’s call it `tbl_customer`.

* Import with `mysqlimport` to a staging table, we will call it `tbl_customer_import`. It is easier to keep on the staging table the same structure that the original data, even if our `tbl_customer` will have a different schema.

```
$ mysqlimport --delete --lines-terminated-by='\r\n' --ignore-lines=1 --compress -h DB_SERVER -u DB_USER -p tbl_name.csv
```

* It you are importing to Amazon RDS databases, you alsa have to use the `local` switch.

* Mark rows to delete and delete them

```
/* Mark to delete */
update prod_table
set to_keep=0;
 
update prod_table t, stage_table s
set t.to_keep=1
where t.field=s.fiels;
 
/* Actually delete them */
delete from prod_table
where to_keep=0;
```

* Update modified rows

```
update tbl_customer c, tbl_customer_import i
set
c.phone_number=i.phone_number,
c.mobile_number=i.mobile_number,
/*
 upadte other fields
 */
where c.customer_id = i.customer_id;
```

* Insert new rows

```
insert ignore into tbl_customer (
   customer_id,
   phone_number,
   mobile_number,
   /*
    Other fields
    */
)
select
   customer_id,
   phone_number,
   mobile_number,
   /*
    Other fields
    */
from tbl_customer_import;
```

That's it.
