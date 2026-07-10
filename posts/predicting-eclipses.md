---
layout: post.njk
title: Predicting Eclipses 
tags: posts
date: 2026-07-09
---
I've been sharing a lot about astronomical calculations lately. In a previous series of posts (see the [first post]({% for post in collections.all %}{% if post.inputPath == "./posts/astrological-clock-1.md" %}{{ post.url | url }}{% endif %}{% endfor %})), I created a clock to show the positions of the planets down to an accuracy of the arc-minute. 

I've worked out another fun astronomical calculator. This time we are predicting when and where eclipses are visible on Earth. See my [GitHub repository](https://github.com/nickplaysjazz/astronomy-calculations) that contains the code for this.

We have already determined how to calculate the geocentric positions of the planets. All we need is the ecliptic longitude, ecliptic latitude, and physical distance of the planets, the end-products of our previous calculation. Now, eclipses can only occur at [syzygy](https://en.wikipedia.org/wiki/Syzygy_(astronomy)) of the Earth, Moon, and Sun; that is, when all three lie in a straight line. 

Note that a syzygy can only occur when the Moon is a full Moon or a new Moon. This happens precisely when the Sun and Moon share the same ecliptic longitude; that is, the horizontal coordinate lines up. But for a syzygy to take place, the *vertical* coordinates of the Sun & Moon, the ecliptic *latitudes*, must be sufficiently close together!

Great! Let's start by finding the dates of new Moon & full Moon. In our code, we scan once per day across a year to see the difference in ecliptic longitude between the Moon and the Sun. (Really, I think you'd only need to do this once roughly every two weeks since that's the rate of change between a full Moon & new Moon, but there's no benefit to be had here. The calculation is rapid.) 

When the difference between the two longitudes changes signs, we know we are at a full Moon or new Moon, and an eclipse *may* occur. If this difference changes at 0 degrees, then a new moon is occurring, and a solar eclipse may occur. If this difference changes from -180 to +180 degrees, then a full moon is occurring, and a lunar eclipse may occur. Once we have found a potential syzygy occurring on a day, we use a more accurate root-finding method to determine the exact time that the ecliptic longitudes are equal. 

We know the Sun & the Moon are horizontally aligned. Are they close enough vertically for an eclipse to take place? Denote the ecliptic latitude of the moon as $\beta$. Our goal now is to calculate a *maximum* "pocket" of latitude $\beta_{max}$ within which an eclipse is visible. 

## Finding the Maximum Ecliptic Latitude for an Eclipse
We want to find the maximum latitude $\beta_{max}$ where either:
- (for a lunar eclipse) the shadow cast by the Earth hits the Moon, or
- (for a solar eclipse) the shadow cast by the Moon hits the Earth.

Let's denote the "angular radius" of the Moon and Sun as $r_{moon}, r_{sun}$. This number represents the angle covered on the celestial sphere by that body. For the sun, this is $r_{sun} = \arcsin{\frac{SUN\ RADIUS}{SUN\ DISTANCE}}$. The "horizontal parallax" of the Moon and Sun will be $\pi_{moon}, \pi_{sun}$. That's the scaling of the planetary body size due to how close we are to that body. This is actually equal to the angular size of Earth viewed from the target body, so it has the same form as before. For the sun, it is $\pi_{sun} = \arcsin{\frac{EARTH\ RADIUS}{SUN\ DISTANCE}}$. 

**Let's start with the solar eclipse.** If we were at the center of the Earth, the eclipse begins exactly when the Moon touches the Sun. That's $r_{sun} + r_{moon}$. On the Earth's surface, parallax makes the Moon appear larger (making it easier for an eclipse to occur) and the Sun appear larger (making it harder for an eclipse to occur). In other words, $\beta_{max} = r_{sun} + r_{moon} + \pi_{moon} - \pi_{sun}$.

Let's take this one step further to determine the type of solar eclipse:
1. If $\beta \leq \beta_{max}$ but $\beta > r_{moon} - r_{sun} + \pi_{moon} - \pi_{sun}$, then the Moon only grazes the edges of the Sun. This is a partial solar eclipse.
2. Otherwise, the Moon is crossing the center of the Sun. When $r_{moon} \geq r_{sun}$, we have a total solar eclipse. Otherwise the Moon doesn't completely cover the Sun and we get an annular solar eclipse.

**Now for the lunar eclipse.** The "umbra" is the dark center of the shadow cast by the Earth, where the Sun is totally obscured. The "penumbra" is the lighter outer shadow, where the Sun is only partially obscured. It turns out that $R_{umbra} = \pi_{moon} + \pi_{sun} - r_{sun}$ and $R_{penumbra} = \pi_{moon} + \pi_{sun} + r_{sun}$. A lunar eclipse occurs exactly for the condition $\beta_{max} = R_{penumbra} + r_{moon}$.

But again, we can classify the types of lunar eclipses:
1. If $\beta \leq \beta_{max}$ yet $\beta > R_{umbra} + r_{moon}$, then the Moon never enters the umbra. This is a penumbral lunar eclipse.
2. Otherwise if $\beta \leq R_{sumbra} + r_{moon}$ but $\beta > R_{umbra} - r_{moon}$, we have a partial lunar eclipse, where only a portion of the Moon enters the umbra. Otherwise, we have a total lunar eclipse.

Fantastic! We can now predict when an eclipse occurs (its moment of syzygy) and classify its type. But a remaining interesting question is where are these eclipses visible?

## Predicting the Location of Eclipse Visibility
It is much simpler to predict the visibility of lunar eclipses than solar eclipses, so let's start there. Lunar eclipses happen over a very large area. Anyone who can see the Moon sees the eclipse. In our script, we will do one simple calculation: at the precise moment of syzygy, determine the visibility of the Moon across the entire globe. 

Now, calculating when the Moon is visible is not exactly trivial, but it's somewhat routine. See [Paul Schlyter's](https://stjarnhimlen.se/comp/riset.html) detailed explanation of this calculation; it's the same thing we'd use if we wanted rise and set times of the planetary body. In our case, we are calculating the altitude of the Moon for a given latitude & longitude on the globe, and if this altitude is above zero, then the Moon is above the horizon, and the lunar eclipse will be visible. We do this for a grid of points across the globe. 

I didn't concern myself with the movement of this lunar eclipse as it forms, so there are areas outside the envelope of visibility at the time of maximum eclipse that will see the lunar eclipse as it's forming but *won't* be so noted on our map. 

The solar eclipse is significantly more involved. We know the time of the maximum eclipse, but we want to see the path of totality as it sweeps across the globe. Here's the general way I handled this:
1. Sweep across a 5-hour window centered around the time of maximum eclipse in 5 minute increments. 
2. At the given time, for every point on our grid of latitude and longitude on the globe, calculate the Sun's altitude. If the Sun is below the horizon, skip this location; the Sun is not visibile, and it's nighttime there.
3. Otherwise, at the given latitude and longitude, calculate the topocentric Right Ascension and Declination of the Moon. This is very similar to the geocentric calculations we already have, but it accounts for the small shift in the Moon's position due to our position on the Earth's surface. [Paul Schlyter](https://stjarnhimlen.se/comp/ppcomp.html) already has explained how to do this calculation. 
4. Calculate the angular separation $\theta$ between the Sun and the topocentric position of the Moon. Using the same boundaries we described earlier, we can determine if $\theta$ shows we are in the path of totality or within the envelope of partial solar eclipse. 

The path of totality is a really tight path. In fact, I went ahead and subdivided my grid points on the globe when we are checking for totality; if any part of the grid point is in the path of totality, we mark the whole cell on our map as lying within the path of totality.

## An Example Using the Code
Let's use our code to see what eclipses are going to happen next year in 2027. Take a look at the [GitHub repository](https://github.com/nickplaysjazz/astronomy-calculations) to use it yourself. 

We see four eclipses will occur. (Actually, we missed a [penumbral lunar eclipse taking place on 2027-07-18](https://eclipsewise.com/lunar/LEprime/2001-2100/LE2027Jul18Nprime.html). But the eclipse is so comically shallow that I'm not upset that I missed it.)
```txt
Scanning for eclipses one year forward from: 2027-01-01 00:00 UTC
+---------------------+-------------------------+
| Date (UTC)          | Type                    |
+---------------------+-------------------------+
| 2027-02-06 15:55:14 | Annular Solar Eclipse   |
| 2027-02-20 23:19:59 | Penumbral Lunar Eclipse |
| 2027-08-02 10:06:03 | Total Solar Eclipse     |
| 2027-08-17 07:31:51 | Penumbral Lunar Eclipse |
+---------------------+-------------------------+

Report successfully saved to 'eclipse_report.txt'.
```

In `eclipse_report.txt` we have more detailed information about where these eclipses are visible. Professional eclipse predictions are by Fred Espenak, [www.EclipseWise.com](https://www.EclipseWise.com). These images are used with permission. 

First we compare the [annular solar eclipse taking place on 2027-02-06](https://eclipsewise.com/solar/SEprime/2001-2100/SE2027Feb06Aprime.html).

![Solar Eclipse of February 2027 as predicted by my code](/images/feb_2027_solar_eclipse_ascii.jpg)
![Solar Eclipse of February 2027 as predicted by Fred Espenak](/images/feb_2027_solar_eclipse_espenak.gif)

And also we can compare the [penumbral lunar eclipse taking place on 2027-02-20](https://eclipsewise.com/lunar/LEprime/2001-2100/LE2027Feb20Nprime.html). 

![Lunar Eclipse of February 2027 as predicted by my code](/images/feb_2027_lunar_eclipse_ascii.jpg)
![Lunar Eclipse of February 2027 as predicted by Fred Espenak](/images/feb_2027_lunar_eclipse_espenak.gif)

The accuracy of these paths looks satisfyingly close! I'm very pleased with the results we have here. Let me know what you think in the comments and if you'd like to see more astronomical calculations in the future. 

*An extra note.* If you're astronomically inclined, you may notice that I have left out one detail. Our earlier calculations for planetary positions use UTC for time, but for the precision needed for accurate eclipse predictions, we need to use terrestrial time (TT). These two are different due to the cumulative difference between the fixed-length day and the rotation of the Earth. The difference $\Delta T$ is fit by a complex piecewise polynomial presented by [Espenak and Meeus](https://eclipse.gsfc.nasa.gov/LEcat5/deltatpoly.html). The [uncertainty in this value](https://eclipse.gsfc.nasa.gov/LEcat5/uncertainty.html) is very low for the modern age (on the order of fractions of a second), but eclipse predictions with this tool will not be very good the further you get from today. For comparison, in 2026, $\Delta T$ is roughly 70 seconds; ignoring this shifted the locations of my eclipse predictions nearly a quarter of the way around the globe! 
