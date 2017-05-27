---
layout: post
title:  "Setting up my own email server"
date:   2017-05-27
categories: email, smtp, imap, aws, digital ocean, dns
---

Harder than I expected.

Started with AWS Lightsail. Console was very basic, now it has improved a little.

Chef was NOT OK with Ubuntu 16.04 and chef solo. Tried many times to get it working, but always failed for some reason. Did not try on digital ocean, only on AWS.

Used Docker. Worked almost out of the box. Just on small instances doesn't work well with many other docker container at the same time; in my experiments 3 is the highest number or concurrent Docker container I was able to run before crashes of containers. Also, sometimes the instance freezes for a while.

I used box from TODO and created a simple `docker_compose.yml`. Manually downloaded docker compose command so no installation is necessary. Works great to change params and restart mail server.

AWS Lightsail can't be used because they do not provide reverse DNS. They provide reverse DNS only for ElastiIP, which can only be attached to EC2, which is way more expensive. (Is it still true with new console and domanin management?)

Turned to digital ocean, which was OK. Moving the dropbox container was a breeze. Just copied the whole directory from AWS to Digital Ocean and everything worked out of the box.

In order to have reverse proxy I had to move the domain management on digital ocean. I use Gandi as registar, followed [this guide](https://www.digitalocean.com/community/tutorials/how-to-point-to-digitalocean-nameservers-from-common-domain-registrars) (digital ocean guides are pretty awesome). You can set a droplet as target of DNS records; does this mean I can reboot the droplet, have its IP changed and still keep the DNS working?

Had to *deeply* modify zone file. After a number of tests I ended up with this:

DNS Records for vernizzis.it

Name | TTL | Class | Type | Priority | Data
=
vernizzis.it. | 1800 | IN | SOA | | ns1.digitalocean.com. hostmaster.vernizzis.it. 1495709641 10800 3600 604800 1800
vernizzis.it. | 1800 | IN | NS | | ns1.digitalocean.com.
vernizzis.it. | 1800 | IN | NS | | ns3.digitalocean.com.
vernizzis.it. | 1800 | IN | NS | | ns2.digitalocean.com.
mail.vernizzis.it. | 119 | IN |A | |  198.211.110.209
vernizzis.it. | 14400 | IN | MX | 10 | mail.vernizzis.it.
vernizzis.it. | 3600 | IN | TXT | | "v=spf1 a mx ~all"
mail.vernizzis.it. | 3599 | IN |TXT | | "v=spf1 mx ~all"

Great tools used:
* http://viewdns.info/
* https://www.mail-tester.com/



TODO:
* backup email
* send from any email to avoid spam
* install webmail
* Have spamassassin properly working
* use automatic filters
* setup nagios or other with alarms
* check if AWS lightsail works with new console and domain management
* Check how DO handles the reboot/change IP of droplets
