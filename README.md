# Advanced Derivatives modelling project

## Pricing of European call options & realized variance options under the exponential CGMY Lévy model and the Heston model.

The main purpose of this project was to price realized variance options under the exponential CGMY Lévy model and the Heston model. Since realized variance options are exotic non-traded derivatives, we have to price in a mark to model fasion. The calibration for each model was done using European call options for the S&P 500. Almost everything was done in MATLAB with the exception of recovering the interest rates and dividend yield, which was done in R. The main functions used in the project are described in further details below. 

### Recovering the interest rate and dividend yield

Recovering of interest rates and dividend yield was done in R. The basic way to recover both from the option-chain was:

* Select a number of ATM calls for all maturities.
* Compute prices of the put options using put-call parity
* Now we choose the interest rates *r* and dividend yield *q* such that we minimize the squarred error between the market put prices and the put option prices recovered from the put-call parity:

<img src="https://latex.codecogs.com/svg.latex?\min_{r_i,q}&space;\sum_{i=1}^{6}&space;\sum_{j=1}^{9}&space;\left(Put_{PC}(K_j,T_i,r_{T_i},q)&space;-&space;Put_{Market}(K_j,T_i)\right)^2." title="\min_{r_i,q} \sum_{i=1}^{6} \sum_{j=1}^{9} \left(Put_{PC}(K_j,T_i,r_{T_i},q) - Put_{Market}(K_j,T_i)\right)^2." />

where *N* is the number of maturities and *M* is the number of put options. 