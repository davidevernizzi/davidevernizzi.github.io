---
layout: post
title:  "AWS CLI S3 sync command removes the ACL"
---

`aws s3 sync origin dest` doeas not preserve the ACL, so if the bucket il public, it will be not accessible after a sync. To keep it public, run `aws s3 sync --acl public-read origin dest`
