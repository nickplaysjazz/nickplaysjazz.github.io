---
layout: base.njk
title: The 3B1B String Problem II
tags: posts
date: 2026-05-25
---
This is Part II on a math puzzle posted by 3Blue1Brown. You see the intro to the problem [here](https://youtube.com/shorts/ZHXt0-_gSj4). 

You have a box filled with $n$ strings. You randomly select the end of one string and tie it to the end of another randomly selected string. Sometimes you'll pick up a string and its own end, meaning you'll tie a loop. Other times, you'll just tie together two strings into one longer string. Either way, you'll eventually end up with only loops of strings. After tying together all ends, **what is the average number of loops you will have if you start with $n=50$ strings?** 

In [Part I]({% for post in collections.all %}{% if post.inputPath == "./posts/string-problem-1.md" %}{{ post.url | url }}{% endif %}{% endfor %}), we derived that the number of loops $a_n = \sum_{k=0}^{n-1}\frac{1}{2k+1} = 1 + \frac{1}{3} + \frac{1}{5} + \cdots + \frac{1}{2n-1}$ is, for large $n$, $\approx \ln (2n - 1) - \frac{1}{2} \ln (n - 1) + \gamma/2$ with $\gamma\approx 0.577$ the [Euler-Mascheroni constant](https://en.wikipedia.org/wiki/Euler%27s_constant). Hence $a_{50} \approx 2.938$ loops. 

In this post, we are going to support our answer with some Monte Carlo sampling. This approach is pretty simple. We will use a Python simulation to act out the structure of tying our strings into loops, measure the number of loops we get, and repeat the simulation many times. The average number of loops should statistically agree with our previous answer.

I thought it would be fun to use an LLM to get the code started. It's a great use case for an LLM to define some efficient code, particularly since we have an expected answer with which to compare. The LLM that I used identified [disjoint-set data structures](https://en.wikipedia.org/wiki/Disjoint-set_data_structure) as an efficient way to store our data, so that's what we will work with. 

Let's start with the main code block. No surprises here, just setting up the trials and reporting statistics after we are done.

```python
import numpy as np

if __name__ == "__main__":
    N_STRINGS = 50
    TRIALS = 10000

    results = [run_trial(N_STRINGS) for _ in range(TRIALS)]

    # calculate & print important statistics
    mean_val = np.mean(results)
    std_dev = np.std(results)
    standard_error = std_dev / np.sqrt(TRIALS)
    ci_margin = 1.96 * standard_error

    print(f"Mean Loops: {np.mean(results):.4f}")
    print(f"Std Dev: {np.std(results):.4f}")
    print(f"Std Error: {standard_error:.4f}")
    print(f"95% Confidence Interval: [{mean_val - ci_margin:.4f} to {mean_val + ci_margin:.4f}]")
```

The `run_trial()` function makes use of a `DisjointSet()` data structure that we will define shortly. It will keep track of the strings that are still in use. 

```python
def run_trial(N):
    strings = DisjointSet(N)
    ends = list(range(N)) * 2
    num_loops = 0
    current_pool_size = len(ends)

    for _ in range(N):
        # select on end randomly
        it1 = np.random.randint(0, current_pool_size)
        str1 = ends[it1]
        ends[it1] = ends[current_pool_size - 1]
        current_pool_size -= 1

        # select another end randomly
        it2 = np.random.randint(0, current_pool_size)
        str2 = ends[it2]
        ends[it2] = ends[current_pool_size - 1]
        current_pool_size -= 1

        # tie strings together, potentially forming a loop
        if strings.find(str1) == strings.find(str2):
            num_loops += 1
        else:
            strings.union(str1, str2)

    return num_loops
```

Let's take a small example, e.g. 5 strings. Then `ends = [0, 1, 2, 3, 4, 0, 1, 2, 3, 4]` initially. We pick an end randomly, say `it1 = 7`. Then `ends[it1] = 2`, that is, we have picked the second end of string with ID 2. 

What's going on with `ends[it1] = ends[current_pool_size - 1]` and `current_pool_size -= 1`? This is a really neat trick that saves us loads of computer time. The obvious thing to do after we have picked & tied a certain string end would be to remove it from the list entirely. Unfortunately, constantly resizing lists ends up being computationally expensive. In this LLM-generated solution, we set `ends[it1]` to the final value of the array, and then decrement `current_pool_size` by 1. In effect, we have replaced the old string end with some other value, and we ignore one spot on the list. No list resizing on the fly at all. A smart move by the LLM!

So how do we keep track of the strings as a disjoint set? 

```python 
class DisjointSet:

    def __init__(self, n):
        self.parent = list(range(n))

    def find(self, i):
        path = []
        while self.parent[i] != i:
            path.append(i)
            i = self.parent[i]
        for node in path:
            self.parent[node] = i
        return i

    def union(self, i, j):
        root_i = self.find(i)
        root_j = self.find(j)
        if root_i != root_j:
            self.parent[root_i] = root_j
            return True
        return False
```

Initially, `strings` is a list from 0 to n. As strings are tied together, these values in the list will be replaced by some representative "parent" string value. The `find()` method does exactly that, telling us what the parent node is. (Incidentally, as another time-saving trick, the parent nodes are updated during this `find()` method to speed up the next time we need to find a given parent!). The `union()` method uses these parent nodes to lengthen the string. 

Now with all the preliminaries out of the way, how does the code perform? For 50 strings and 10,000 trials, $a_{50}=2.9496 \pm 0.0131$. Our value of $a_{50} = 2.938$ falls within this 95% confidence interval. Great! Our results agree very well, and further trials don't give significantly improved results. 

![A plot of the average number of loops formed versus the number of trials. By 10,000 trials, the simulated mean agrees extremely well with the theoretical mean. The error bars become very small as the number of trials increases.](/images/monte_carlo_conv.jpeg)

Furthermore, keeping the number of trials constant at 10,000, our theoretical solution agrees really well with simulations as you change the number of strings. Surprisingly, even at as low as $n=5$ strings, our approximate solution works really well!

![A plot of the average number of loops formed versus the number of initial strings. The theoretical curve lines up with simulated points very well, with only some minor variation between the two at very high number of initial strings.](/images/monte_carlo_num_strings.jpeg)

That's a wrap on this problem. A bit of fun looking at it from two different angles—theoretical and numerical—to be confident in our solution.  