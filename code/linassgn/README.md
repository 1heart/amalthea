# Linear assignment package

_Note: This code requires a decent amount of refactoring to release as a full package._

This code implements multiresolution wavelet sliding coefficients, as explained in the original [Peter et al. paper](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2921664/). However, we have not replicated the positive results for shape retrieval from the paper; therefore, use this code at your own peril.

The main work is done in `liassgn_warp.m` in `linassgn_main/`. For examples on how to run the code, see `demo_linassgn.m` under `demos/`.

