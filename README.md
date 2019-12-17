# Advanced Derivatives modelling project

## Pricing of European call options & realized variance options under the exponential CGMY Lévy model and the Heston model.

The main purpose of this project was to price realized variance options under the exponential CGMY Lévy model and the Heston model. Since realized variance options are exotic non-traded derivatives, we have to price in a mark to model fasion. The calibration for each model was done using European call options for the S&P 500. Almost everything was done in MATLAB with the exception of recovering the interest rates and dividend yield, which was done in R. The main functions used in the project are described in further details below. 

### Recovering the interest rate and dividend yield

Recovering of interest rates and dividend yield was done in R. The basic way to recover both from the option-chain was:

* Select a number of ATM calls for all maturities.
* Compute prices of the put options using put-call parity
* Now we choose the interest rates *r* and dividend yield *q* such that we minimize the squarred error between the market put prices and the put option prices recovered from the put-call parity:

![equation](http://www.sciweavers.org/tex2img.php?eq=%5Cmin_%7Br_i%2Cq%7D%20%5Csum_%7Bi%3D1%7D%5E%7BN%7D%20%5Csum_%7Bj%3D1%7D%5E%7BM%7D%20%5Cleft%28Put_%7BPC%7D%28K_j%2CT_i%2Cr_%7BT_i%7D%2Cq%29%20-%20Put_%7BMarket%7D%28K_j%2CT_i%29%5Cright%29%5E2.&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=0)

where *N* is the number of maturities and *M* is the number of put options. 