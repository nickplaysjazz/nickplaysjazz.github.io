---
layout: post.njk
title: Making an Astrological Clock I
tags: posts
date: 2026-06-04
---
This article is the first of a series where I build a digital clock to show real-time astronomical locations of planetary bodies.

I first had this idea when playing [Kerbal Space Program](https://en.wikipedia.org/wiki/Kerbal_Space_Program), which got me interested in how astronomers predict & measure the positions of the planets. I ended up writing a python script to do this, and I thought a fun application of this script would be to put the planetary bodies in terms of astrology. 

This first post will be on how we mathematically predict the planetary bodies positions. Later posts will cover converting this to astrological terms and designing and building the clock.

I am not an astronomer by trade, but I'll try to summarize briefly the relevant science upfront. We know from [Kepler's laws](https://en.wikipedia.org/wiki/Kepler%27s_laws_of_planetary_motion), later derived from Newton's laws of motion, that the movement of two planetary bodies follows an ellipse. We can define this mathematically with six independent terms, called the [orbital elements](https://en.wikipedia.org/wiki/Orbital_elements). It's easier to see an example rather than explaining each of them. 

<div class="no-style" style="background: #fdfaf7; padding: 1.5rem; border-radius: 12px; margin: 2rem auto; max-width: 360px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); text-align: center;">
  <a href="https://commons.wikimedia.org/wiki/File:Orbit1.svg" target="_blank" rel="noopener">
    <img width="330" alt="Diagram illustrating and explaining various terms in relation to Orbits of Celestial bodies." src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Orbit1.svg/330px-Orbit1.svg.png" style="display: block; margin: 0 auto;">
  </a>
  
  <div style="font-size: 0.7rem; color: #665; margin-top: 1rem; line-height: 1.3; font-family: sans-serif;">
    Lasunncty at the English Wikipedia, <a href="http://creativecommons.org/licenses/by-sa/3.0/" target="_blank" rel="noopener" style="color: #855; text-decoration: underline; border: none;">CC BY-SA 3.0</a>, via Wikimedia Commons
  </div>
</div>

In a perfect world, given a specific time, these constant orbital elements would determine the positions of the planets exactly. However, due to gravitational perturbations by other planetary objects and the effects of general relativity, these orbital elements change slowly over time. The modern solution is to measure the positions of the planets and fit an equation to describe the orbital elements over time; this equation will be valid for some determined degree of accuracy and for some determined length of time.

## Goals for the Calculations
Let's define some goals:
1. **Positions are calculated for the seven classical planetary bodies alone: Mercury, Venus, Mars, Jupiter, Saturn, the Sun, and the Moon.**

    Traditional astrology utilizes only these bodies to begin with. That's plenty to work with. We will just neglect Uranus and Neptune along with Pluto and the other dwarf planets for now. In any case, they move extremely slowly, which is not so interesting on a clock.

2. **Positions should be accurate to $\pm$ 1 arc-minute when compared with high-quality planetary position data.**
    
    How accurate is this? The fastest moving planetary body here is obviously the Moon, which has a "sidereal" period of 27.321661 days (that is, a full circle travelled around the earth relative to the stars, *not* the time from new moon to new moon, which would be a "synodic" period of 29.53 days). 1 arc-minute is therefore traversed by the Moon on average in 1.82 minutes. Our clock could be off by, at worst, roughly 2 minutes. 

    We will see when we get to the astrology that the arc-*degree* is more important. The moon travels one arc-degree on average in 1.82 hours. So certainly an error of $\pm$ 2 minutes of time for the fastest moving planetary body will satisfy an astrologer.

3. **Positions only need to be accurate for roughly 1900 CE to 2100 CE.**

    I do not care if this clock outlasts me.

4. **Positions are not obtained not via lookup tables ("ephemeris" tables) but from calculations.**

    On one hand, it's no fun to just reference a big table of planet positions over time. On the other hand, when we get to the building of the digital clock, we are going to be using very small computer memory chips. There will be no room for storing large datasets!

## Performing the Calculations
Great news: the hard work has been done for us! A [fantastic write-up](https://stjarnhimlen.se/comp/ppcomp.html) by Paul Schlyter explains how to perform these calculations in great detail. The accuracy is indeed 1-2 arc-minutes, and the formula will be valid for many years (an error of roughly 7 arc-minutes for the Moon in 1000 years). It fits our use case exactly. 

I don't want to re-invent the wheel, since Paul Schlyter already did such a great job explaining everything. Let me just highlight what the general algorithm looks like here:

1. Calculate the "day number," which converts the year, month, date, and UTC time into a single decimal number.

2. Calculate the six orbital elements as a function of the day number.

3. Use the orbital elements to calculate the Cartesian position of the planetary body relative to Earth, also as a function of the day number.

4. Map the Cartesian position of the planet onto the celestial sphere. This gives us the "Right Ascension" (eastward direction relative to the equator) and "Declination" (northward angle relative to the equator). These numbers are what you would use if you wanted to point a telescope at a planetary body.

## The Code
I've created a [astronomy-calculations GitHub repository](https://github.com/nickplaysjazz/astronomy-calculations) that I'll use for this project. 

Just to show off the results of the code so far, here's what we find for the planetary positions for June 4, 2026 CE at noon UTC:
```txt
Calculations for: 2026-06-04 12:00 UTC
+---------+----------+----------+
|  Planet |   RA (°) |  Dec (°) |
+---------+----------+----------+
|     sun |  72.5381 |  22.4654 |
|    moon | 302.0482 | -23.0476 |
| mercury |  95.4145 |  25.4792 |
|   venus | 111.4463 |  23.9720 |
|    mars |  40.0928 |  14.9775 |
| jupiter | 116.7463 |  21.5835 |
|  saturn |  12.3947 |   2.8487 |
+---------+----------+----------+
```

Keep an eye out for my [next post]({% for post in collections.all %}{% if post.inputPath == "./posts/astrological-clock-2.md" %}{{ post.url | url }}{% endif %}{% endfor %}), where we will try to validate this code.