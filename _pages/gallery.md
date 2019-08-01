---
layout: page
title: Pictures
permalink: /gallery/
---

{% assign image_files = site.static_files | where: "image", true %}
{% for myimage in image_files %}
  ![me]({{ myimage.path }}){: height="36px" width="36px"}
{% endfor %}
