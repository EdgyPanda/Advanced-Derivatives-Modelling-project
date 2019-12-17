# Advanced Derivatives modelling project

## Pricing of European call options & realized variance options under the exponential CGMY Lévy model and the Heston model.

The main purpose of this project was to price realized variance options under the exponential CGMY Lévy model and the Heston model. Since realized variance options are exotic non-traded derivatives, we have to price in a mark to model fasion. The calibration for each model was done using European call options for the S&P 500. Almost everything was done in MATLAB with the exception of recovering the interest rates and dividend yield, which was done in R. The main functions used in the project are described in further details below. 

### Recovering the interest rate and dividend yield

Recovering of interest rates and dividend yield was done in R. The basic way to recover both from the option-chain was:

* Select a number of ATM calls for all maturities.
* Compute prices of the put options using put-call parity
* Now we choose the interest rates *r* and dividend yield *q* such that we minimize the squarred error between the market put prices and the put option prices recovered from the put-call parity:

![equation](http%3A%2F%2Fwww.sciweavers.org%2Ftex2img.php%3Feq%3D%255Cmin_%257Br_i%252Cq%257D%2520%255Csum_%257Bi%253D1%257D%255E%257BN%257D%2520%255Csum_%257Bj%253D1%257D%255E%257BM%257D%2520%255Cleft%2528Put_%257BPC%257D%2528K_j%252CT_i%252Cr_%257BT_i%257D%252Cq%2529%2520-%2520Put_%257BMarket%257D%2528K_j%252CT_i%2529%255Cright%2529%255E2.%26bc%3DWhite%26fc%3DBlack%26im%3Djpg%26fs%3D12%26ff%3Darev%26edit%3D0)

where *N* is the number of maturities and *M* is the number of put options. 