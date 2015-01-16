---
layout: post
title:  "Resize a vagrant VM which uses LVM"
date:   2015-MM-DD
categories: tag
---

* VMDK -> VDI
* Resize VDI [see changes in virtualbox gui]
* resize partition with gparted
* check that cfdisk in vm sees new size
* lvextend -L +10G /dev/...
* resize2fs [see new space with df]

