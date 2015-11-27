---
layout: post
title:  "The impossible bug hunt"
date:   2015-11-25
categories: debug, API
---

Recently I had to find a bug which has shown to be very nasty (not to mention
not existent). One morning a customer called us claiming that one of our
services was not working. The service is composed of two APIs: a SOAP one and
a RESTful one. The problem was reported to affect the SOAP interface (even if
a later analysis show that also the REST API was suffering from the same
issue).

I wrote a small client to test the API and I found that some of the request
were taking too much time to complete. A further analysis show that the
database was suffering because another project hosted on the same server was
consuming all the CPU and the available connections.

I quickly consulted with our CTO and we decided to move the project to
a different machine. This part was pretty easy: we import a full snapshot of
the DB every night from a file that the customer sends us via SFTP, and the
whole import takes around half an hour, so I created a new database on another
server and run the import. While the new DB was filling up, I created a new
version of the API that pointed to the new DB, deployed a new instance of the
API, tested it and switched the URLs (we use AWS ElasticBeanstalk which makes
this latter operation very easy). After we spot the bug, in less than one hour
we were up and running again and the problem was solved.

The problem is that the client reported they still saw connections that lasted
more than 10 seconds (where the average time is less that 0.2 seconds). At that
point I started a crazy bug hunt. I wasn’t able to replicate the bug. I didn’t
even know where the bug was! Our system is composed by a web proxy that
forwards the requests to two different backend machines. The proxy is connected
with the customer thought a TLS connection and the same happens between the
proxy and the backend machines.

A quick look at the apache access log did not give me many info, so I added
some extra debug feature adding -T option. Another look told me that there were
a number of calls lasting slightly more than 10 seconds and all returning 400
as error code. More, the calls lasted only few milliseconds more than 10
seconds, never less than 10 seconds and never more than 10.1 seconds. Strange.
And they were the only API calls returning 400. Very strange.

I tried to spot any error in the backend, but I didn’t find any. So I put debug
lines into the code and I put in production the verbose version of the code
(again, this was pretty easy thanks to AWS EB). Nothing. So I tried to look at
the network packets with tcpdump, but the rate was too high (the API gets
called 1M+ times per day). I dumped some traffic and open it with wireshark,
but no luck. I even decrypted the TLS traffic giving to wireshark out private
key, but nothing yet.

At this point I was convinced that the problem was not in the code, nor in the
backend machines. So I turned my attention to the proxy. I dumped the traffic
there as well, decrypted it, found nothing, dumped a longer session, but
nothing again. I felt like i was searching the needle in a haystack. Luckily,
after some more tries, my devop mentioned that we had done a maintenance on our
proxy few days earlier and suggested we look around that point to see if
anything changed. We didn’t see anything particular neither before, neither
after tha maintenance. At that point an idea struck my mind: maybe the bug have
been there for a long time. I went to look on our oldest logs and I found out
that the bug was there since 370 days. Definitely not a bug.

I called the customer and I asked if they experienced any real problem. I found
that they did not know because they were not in direct contact with the people
who were actually using the system: they only saw logs and they had observed
this strange behavior, so they asked us some support. I asked if they could
check in the older logs if the issue was already there, but this was not
possible because they have been taking these kind logs only after the
programmed maintenance we did to our proxy. I told them that we have this bug
since more than one year and I suggested they could ask to the actual users if
they were experiencing any problems. A couple of hours later they reported that
there were no actual issues and thanked us for the help.

A final investigation show that the client's implementation used a
pool to reuse the connections and avoid the overhead necessary to destroy used
connections and create new ones. The problem lied in our proxy that terminates
the pending connections after 10 seconds of network inactivity.

So, after a whole day searching for a mysterious bug, I learnt that before
starting to search for something crazy, one should make sure that that crazy
thing actually exists.
