---
layout: post.njk
title: Making an Astrological Clock II
tags: posts
date: 2026-06-07
---
This article is the second of a series where I build a digital clock to show real-time astronomical locations of planetary bodies.

To recap my [first post]({% for post in collections.all %}{% if post.inputPath == "./posts/astrological-clock-1.md" %}{{ post.url | url }}{% endif %}{% endfor %}), we laid out some goals for the project and calculated astronomical positions of the seven classical planets for a provided time. You can check out my [GitHub repository](https://github.com/nickplaysjazz/astronomy-calculations) that contains the code for this project.

Today we will try to verify our calculated astronomical positions versus high-quality scientific data. This is actually a bit more difficult than it seems, though not impossible if you are willing to pay close attention to details. 

The foremost source for information on planetary positions is the [Horizons System](https://ssd.jpl.nasa.gov/horizons/) offered by NASA's Jet Propulsion Laboratory. This is a set of very precise ephemerides (astronomical positions) fit to astronomical observations. Furthermore, you can easily access the data through a web browser. You can also query the system through an API or command-line interface, but for today we won't need any of the stronger capabilities.

What we want to obtain from the Horizons System is the geocentric position of the planets—that is, the position of the planets relative to the Earth's center, not relative to some point on the Earth's surface, which is the topocentric position of the planets. 

In the Horizons System, I use the following settings, which I'm posting here for replicability:
1. Ephemeris Type: Vector Table.
2. The Coordinate Center is Geocentric \[code: 500\].
3. The Time Specification is e.g. 2026-06-04 12:00 UT.
4. The Table Settings. The reference frame is ICRF. The reference plane is the equatorial (not ecliptic!) reference frame. We apply no light-time or aberration-corrections to the vectors, i.e., we want the geometric states. 

If we run this for e.g. Saturn, then in the output text we can see the following.
```txt
*******************************************************************************
$$SOE
2461196.000000000 = A.D. 2026-Jun-04 12:00:00.0000 UTC 
 X = 9.684482405935125E+00 Y = 2.072149975806727E+00 Z = 4.694613587831113E-01
$$EOE
*******************************************************************************
```

We convert this into a right ascension in degrees via `atan2(X,Y)`, 12.07 degrees. But the right ascension for Saturn we got previously was 12.39 degrees! What's the issue?

## Correcting for Precession
Earth's axis of rotation rotates relative to the fixed stars at a very slow period of ~25,000 years. This is the so-called precession of the equinoxes. Our code using [Paul Schlyter's calculations](https://stjarnhimlen.se/comp/ppcomp.html) gives us the planetary positions for the "equinox of the day"; that's what we will want for astrological purposes. 

However, the NASA JPL Horizons System reports for what is known as the J2000.0 epoch. In other words, the positions we have calculated for 2026 CE must be rotated along the ecliptic to the year 2000 CE for comparison with the Horizons System data. The difference is not negligible, even for only 26 years difference!

Paul Schlyter shows us that, rather than applying a rotation matrix, we can make a simplified fix (see [section 8 of his notes](https://stjarnhimlen.se/comp/ppcomp.html#8) for details). I've updated the [GitHub repository](https://github.com/nickplaysjazz/astronomy-calculations) accordingly; you can enable a flag in the `main()` function to correct to a given epoch. 

Let's take our calculated planetary positions, express them in terms of the J2000.0 epoch, and compare that to the NASA JPL Horizons System data. I want to re-iterate that the values we use in our astrological clock will NOT be corrected to a J2000.0 epoch; we want the equinox-of-the-day values. But for the purposes of comparison, we need to apply this correction.

| Planet | My Calculated J2000.0 RA | NASA JPL Horizons System RA|
|--------|-------------------------------|--------------------------|
|sun|72° 08'|72° 08'|
|moon|301° 31'|301° 29'|
|mercury|95° 00'|95° 00'|
|venus|111° 02'|111° 02'|
|mars|39° 43'|39° 44'|
|jupiter|116° 21'|116° 21'|
|saturn|12° 03'|12° 04'|

Spectacular! This is exactly what we are hoping to see: our calculated right ascension values are within 1-2 arc-minutes of the NASA dataset! How satisfying to see. We could do the same for the declination, but I'm confident at this point that we can trust our calculations.

In my [next post]({% for post in collections.all %}{% if post.inputPath == "./posts/astrological-clock-3.md" %}{{ post.url | url }}{% endif %}{% endfor %}) we will map our planetary positions into astrological terms.