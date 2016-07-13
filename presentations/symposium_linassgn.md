# Linear assignment

Now that we have our coefficients, we're going to make our distances between them better
How? Our technique, which we call sliding wavelets, helps us make similar shapes even more similar, while keeping distant shapes far apart
This makes our distance metric better at differentiating between classes of shapes

The way we do this is with a technique called linear assignment, which helps match our two shapes up by warping them together

Each element in a coefficient vector represents a location on the original grid

How do we match up two shapes?
We construct a cost matrix that tells us the best places to warp each point
Let's say we have two coefficient vectors
First, we see how well each element matches up to every other element by taking the outer product between the coefficient vectors
But we also want to control how much warping happens, so we use a distance matrix
This distance matrix has all the pairwise distances between all the locations on the original grid, which controls how far you let shapes warp

We can control the amount of warping by weighting this distance matrix by a parameter called lambda
High lambda means the distances between points matters more, so there's less warping
Low lambda means the distances between the points you're warping matters less, so you're able to warp farther

There's been previous work on single-resolution wavelets, which showed promising results on increasing shape retrieval
Our contribution was to extend this to multiresolution wavelets
We're still in the process of validating this, as picking an optimal lambda is difficult
Our current results using sliding coefficients don't improve the retrieval
But we'll keep investigating the idea because the singleres version was so promising

