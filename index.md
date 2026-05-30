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

### Recent Finds
* [The 2026 Junethack Tournament](https://junethack.net/) - Starts June 1st! Keep an eye on how I'm doing
* [Melon Match](https://twinadam.itch.io/melon-match) - An entertaining Suika-clone, playable in your browser. Made by a friend of mine!

<div class="site-footer" style="text-align: center; margin-bottom: 1rem;">
This website is a member of the Combo Crew webring. Visit other members:
</div>

<div class="no-style" style="display: flex; justify-content: center; align-items: center; gap: 1.5rem;">
  <a href="https://webri.ng/webring/combocrew/previous?via=https://www.nickplaysjazz.com%2F" 
     title="Previous Member" 
     style="color: rgba(245, 235, 230, 0.6); font-size: 1.5rem; font-family: monospace; text-decoration: none; display: flex; align-items: center; height: 31px;">&lt;</a>
  
  <a href="https://webri.ng/webring/combocrew/random?via=https://www.nickplaysjazz.com%2F"  style="display: block; height: 31px;">
    <img src="https://tilde.club/~twinbfield/assets/combo_crew_88x31_red.png" border="0" width="88" height="31" alt="Combo Crew Webring" style="display: block;" />
  </a>
  
  <a href="https://webri.ng/webring/combocrew/next?via=https://www.nickplaysjazz.com%2F"  
     title="Next Member" 
     style="color: rgba(245, 235, 230, 0.6); font-size: 1.5rem; font-family: monospace; text-decoration: none; display: flex; align-items: center; height: 31px;">&gt;</a>
</div>