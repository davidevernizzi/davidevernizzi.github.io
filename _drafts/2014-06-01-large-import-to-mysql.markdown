---
layout: post
title:  "Import large files to mysql"
date:   2014-06-01
categories: mysql
---


I'm now finished with my very-large-import-task and I have learn something
since the beginning. Importing very large dataset is feasible, but you have to
keep in mind some tricks. First, when you import you should remove all the
indexes. Second you should have a very high bandwith since it will be the true
bottleneck.

After some tries and tweakings I have come to use this procedure
1) Use a sister table for each import. I didn't directly use the target table,
but I used a sister table with the same schema which I erase at the beginning
of each import.
2) Truncate the sister table at the beginning of each import
3) Drop any index on the sister table before begin to import
4) Import your dataset using mysqlimport -c. The dataset may be too large for 
you database to handle. In that case the whole import will fail and will be
rolled back, resulting into zero-rows in the sister table.
5) Create the indexes
6) Update all the existing queries on the target table with the values of the
corresponding rows in the sister table
7) Inser new row from sister table to target table.
