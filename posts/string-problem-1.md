---
layout: base.njk
title: The 3B1B String Problem I
tags: posts
date: 2026-05-23
---
A recent math puzzle posted by 3Blue1Brown caught my attention. You see the intro to the problem [here](https://youtube.com/shorts/ZHXt0-_gSj4); I'll summarize below. Spoilers ahead if you want to give it a shot yourself. 

Imagine you have a box with $n$ strings. You randomly select the end of one string and tie it to the end of another randomly selected string. Sometimes you'll pick up a string and its own end, meaning you'll tie a loop. Other times, you'll just tie together two strings into one longer string. Either way, you'll eventually end up with only loops of strings. The question is: after tying together all ends, **what is the average number of loops you will have if you start with $n=50$ strings?**

I started out by doing some calculations for small $n$ by hand. For $n=1$, you can only end up with 1 loop. For $n=2$, once you select your first end of a string, there are 3 ends remaining; there is a $\frac{1}{3}$ chance of making a self-loop, and a $\frac{2}{3}$ chance of making one long string. Either way you'll end up with 1 string left, and that reduces to our $n=1$ case. Similarly, for $n=3$, there is a $\frac{1}{5}$ chance of making a self-loop, and a $\frac{4}{5}$ chance of making a longer string; either way, you reduce to the $n=2$ case. 

| $n$  | Average number of loops $a_n$  | 
|-------|----|
| 1 | 1  | $=1$|
| 2    | $\frac{1}{3}(1+a_1)+\frac{2}{3}(a_1) =\frac{4}{3}$ |
| 3  | $\frac{1}{5}(1+a_2)+\frac{4}{5}(a_2) =\frac{23}{15}$ |
|4 | $\frac{1}{7}(1+a_3)+\frac{6}{7}(a_3) =\frac{176}{105}$ |

It becomes pretty clear that this obeys a recursion relation:
$$ \begin{equation*}\begin{split}
a_1 &= 1 \\
a_{n+1} &= \frac{1}{2n+1} \left ( a_n + 1 \right ) + \frac{2n}{2n+1} a_n = a_n + \frac{1}{2n+1}
\end{split}\end{equation*}$$

No doubt one could prove this rigorously via induction. How do we get this in explicit terms? As it turns out, there's a neat trick for solving recursive arithmetic sequences.
$$ \begin{equation*}\begin{split}
a_{n+1}- a_{n} &= \frac{1}{2n+1} \\
\sum_{k=1}^{n-1} \left ( a_{k+1} - a_{k} \right) &= \sum_{k=1}^{n-1} \frac{1}{2k+1} \\
 a_n - a_1  &= \sum_{k=1}^{n-1} \frac{1}{2k+1} \\
 a_n &= \sum_{k=0}^{n-1}\frac{1}{2k+1} = 1 + \frac{1}{3} + \frac{1}{5} + \cdots + \frac{1}{2n-1}
\end{split}\end{equation*}$$
Since we sum up $(a_1 - a_0) + (a_2 - a_1) + (a_3 + a_2) + \cdots$ on the left hand side, most of the terms disappear! We end up with a nice sum to evaluate in terms of the number of strings $n$. 

We could stop here, but we can do better than a very long series. Consider the harmonic series $H_n = \sum_{k=1}^n \frac{1}{k} = 1 + \frac{1}{2} + \frac{1}{3} + \cdots + \frac{1}{n}$. As $n\rightarrow \infty$, the partial sum $H_n \rightarrow \ln n + \gamma$, with $\gamma \approx 0.577$ being the [Euler-Mascheroni constant](https://en.wikipedia.org/wiki/Euler%27s_constant). Our sum looks very much like the harmonic series, but we need to get rid of the even terms.

Some manipulation with indices gets us what we need:
$$ \begin{equation*}\begin{split}
H_{2n-1} &= 1 + \frac{1}{2} + \frac{1}{3} + \cdots + \frac{1}{2n-2} + \frac{1}{2n-1} \\
\frac{H_{n-1}}{2} &= \frac{1}{2} \left ( 1+\frac{1}{2} + \cdots + \frac{1}{n-1} \right ) = \frac{1}{2} + \frac{1}{4}+\cdots + \frac{1}{2n-2} \\
\Rightarrow a_n &= H_{2n-1} - \frac{H_{n-1}}{2}
\end{split}\end{equation*}$$

We want the solution for $n=50$ strings, a relatively large number. It's probably justified to use the harmonic series partial sum. For large $n$, 
$$ \begin{equation*}\begin{split}
a_n &\approx \ln (2n - 1) + \gamma - \frac{1}{2} \left ( \ln(n-1) + \gamma \right ) \\
a_n &\approx \ln (2n - 1) - \frac{1}{2} \ln (n - 1) + \gamma/2
\end{split}\end{equation*}$$

For $n=50$ strings, **we expect on average to have $a_{50} \approx 2.938$ loops**. If you were to perform the whole sum by hand, you get $a_{50} = 2.938$. (Our approximation agrees up to the 5th significant figure.)

Since our solution grows logarithmically, you can fill the box with enough strings to get any arbitrary number of loops on average after our tying procedure. However, the number of strings quickly becomes ludicrously large. For instance, if you wanted to get on average $a_n=50$ loops after our tying procedure, you must start with a box that has on the order of $10^{43}$ strings!

Stay tuned for Part II of this post, where I will be doing some Monte Carlo simulations to measure the solution to this problem statistically and compare it to our theoretical answer.
