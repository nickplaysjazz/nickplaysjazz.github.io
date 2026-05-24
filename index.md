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

<div class="site-footer">
This site is a member of the Combo Crew. Visit another member:
</div>
<center>
<div class="no-style">
<a href="https://webri.ng/webring/combocrew/next?via=https%3A%2F%2Fnickplaysjazz.com%2F">
<img src="https://tilde.club/~twinbfield/assets/combo_crew_88x31_red.png" border="0" width="88" height="31" alt="Combo Crew Webring" />
</a>
</div>
</center>