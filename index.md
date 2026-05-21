---
layout: base.njk
title: home
---

Hello! My name is nickplaysjazz. I am a research scientist and computer programmer. 

I'll be using this blog to share updates on whatever fun projects I'm working on.

### Recent Updates

<ul class="post-list">
{%- for post in collections.posts limit:3 -%} <li class="post-item">
    <span class="post-date">{{ post.date | postDate }}</span>
    <a href="{{ post.url }}">{{ post.data.title }}</a>
  </li>
{%- endfor -%}
</ul>

### Recent Thoughts
* [Melon Match](https://twinadam.itch.io/melon-match) - An entertaining Suika-clone, playable in your browser. Made by a friend of mine!
* [The 2026 Junethack Tournament](https://junethack.net/) - Coming up soon!
* [The Boring Internet](https://www.terrygodier.com/the-boring-internet) by Terry Godier - Fantastic read on our relationship with the internet in 2026.