---
layout: post.njk
title: Making an Astrological Clock III
tags: posts
date: 2026-06-08
---
This article is the third of a series where I build a digital clock to show real-time astronomical locations of planetary bodies.

In my [first post]({% for post in collections.all %}{% if post.inputPath == "./posts/astrological-clock-1.md" %}{{ post.url | url }}{% endif %}{% endfor %}), we wrote a script to calculate astronomical positions of the seven classical planets. In my [second post]({% for post in collections.all %}{% if post.inputPath == "./posts/astrological-clock-2.md" %}{{ post.url | url }}{% endif %}{% endfor %}), we verified the accuracy of the results of these calculations versus high-quality scientific data. You can check out my [GitHub repository](https://github.com/nickplaysjazz/astronomy-calculations) that contains the code for this project.

In today's post we are going to map our astronomical position calculations into the terms of astrology. We've done the hard work up front for this post. Consider again our orbiting body around the sun:

<div class="no-style" style="background: #fdfaf7; padding: 1.5rem; border-radius: 12px; margin: 2rem auto; max-width: 360px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); text-align: center;">
  <a href="https://commons.wikimedia.org/wiki/File:Orbit1.svg" target="_blank" rel="noopener">
    <img width="330" alt="Diagram illustrating and explaining various terms in relation to Orbits of Celestial bodies." src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Orbit1.svg/330px-Orbit1.svg.png" style="display: block; margin: 0 auto;">
  </a>
  
  <div style="font-size: 0.7rem; color: #665; margin-top: 1rem; line-height: 1.3; font-family: sans-serif;">
    Lasunncty at the English Wikipedia, <a href="http://creativecommons.org/licenses/by-sa/3.0/" target="_blank" rel="noopener" style="color: #855; text-decoration: underline; border: none;">CC BY-SA 3.0</a>, via Wikimedia Commons
  </div>
</div>

We calculated previously the right ascension of a planet, that is, the longitude and latitude of the planet in reference to the *equator* on Earth. That's what you'd use if you wanted to point a telescope at a point in the sky. 

However, astrologers are interested in the position of the planets versus the *ecliptic*, the plane that contains the orbit of the earth around the sun. That's different from the plane of the equator! The image I showed above does a good job highlighting this. The spin of earth around its axis defines the equator, a plane like the yellow plane, but the orbit of earth around the sun defines the ecliptic, the gray plane. We need to rotate our positions onto the ecliptic. See also [this Wikipedia page](https://en.wikipedia.org/wiki/Celestial_equator) for more info.

Fortunately, we already calculated this in our code! We have the geocentric ecliptic coordinates already, calculated along the way towards our equatorial coordinates. I've moved some code around and created a second script in the [GitHub repository](https://github.com/nickplaysjazz/astronomy-calculations) that will calculate the zodiacal planetary positions for a given time, but it uses the same mathematics that we were using previously. No extra math needed. 

Now we have a horizontal position in degrees across the ecliptic, but we need to express this in astrological terms. Instead of a degree from 0 to just below 360, we now define signs every 30 degrees. The first sign, starting due east, is Aries, which will go from 0 degrees to 29.99... degrees. The next sign, going from 30.00 degrees to 59.99... degrees, is Taurus. And so we go on, next for Gemini, Cancer, Leo, Virgo, Libra, Scorpio, Sagittarius, Capricorn, Aquarius, and finally Pisces. I'll also convert this into degrees and arc-minutes, as that's more traditional.

It's interesting to note that since astrologers couldn't get the positions of the planets accurate down to the arc-minute, they historically leaned towards placing emphasis on the degree in the sign alone. This is partially why I decided our clock should be accurate to the arc-minute rather than aiming for higher accuracy. 

So for our test date of June 4, 2026 CE at 12:00 UTC we get the following:
```txt
+---------+-----------+----------+
|  Planet |      Sign | Position |
+---------+-----------+----------+
|     sun |    gemini |  13° 54' |
|    moon | capricorn |  29° 08' |
| mercury |    cancer |  04° 53' |
|   venus |    cancer |  19° 31' |
|    mars |    taurus |  12° 20' |
| jupiter |    cancer |  24° 44' |
|  saturn |     aries |  12° 30' |
+---------+-----------+----------+
```

Great! We have the positions of the planets in basic astrological terms. 

We already know these numbers are correct since we validated the planetary positions in the [last post]({% for post in collections.all %}{% if post.inputPath == "./posts/astrological-clock-2.md" %}{{ post.url | url }}{% endif %}{% endfor %}), but just for completion let's compare our results to an astrology program.

I can recommend the [Astrolog program](https://www.astrolog.org/astrolog.htm), open-source and free from a lovely Geocities-like website. Thanks to Walter D. Pullen for working on this program. I had lots of fun generating all sorts of data and images with this program. After noodling around, we get the following astrology wheel, showing the planets in their signs, along with a lot of data I'm going to ignore. 

![Horoscope wheel for June 6, 2026 CE at 12:00 UTC, calculated via the Astrolog program.](/images/astrolog_horoscope_wheel.bmp)

If you look on the center-right, you will see the readouts of the positions of the planets, which I've summarized in the table below.
| Planet | My Calculations | Astrolog Calculations |
|--------|-------------------------------|--------------------------|
|sun|gemini 13° 54'|gemini 13° 53'|
|moon|capricorn 29° 08'|capricorn 29° 07'|
|mercury|cancer 04° 53'|cancer 04° 52'|
|venus|cancer 19° 31'|cancer 19° 31'|
|mars|taurus 12° 20'|taurus 12° 20'|
|jupiter|cancer 24° 44'|cancer 24° 44'|
|saturn|aries 12° 30'|aries 12° 31'|

Once more, we confirm that our data is within 1 arc-minute or so of more trustworthy sources. (I had Astrolog use the [Swiss Ephemeris](https://www.astro.com/swisseph/swephinfo_e.htm), which is evidently today's state-of-the-art data for astrologers.) 

On our next post we will break out the electronics and begin building our clock.