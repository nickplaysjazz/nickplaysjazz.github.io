---
layout: base.njk
title: posts
permalink: /posts/index.html
---

Here's a complete list of all the blog posts I've made.

<ul class="post-list">
{%- for post in collections.posts -%} <li class="post-item">
    <span class="post-date">{{ post.date | postDate }}</span>
    <a href="{{ post.url }}">{{ post.data.title }}</a>
  </li>
{%- endfor -%}
</ul>