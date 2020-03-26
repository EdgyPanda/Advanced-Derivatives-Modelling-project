# Advanced Derivatives modelling project

## Pricing of European call options & realized variance options under the exponential CGMY Lévy model and the Heston model.

The main purpose of this project was to price realized variance options under the exponential CGMY Lévy model and the Heston model. Since realized variance options are exotic non-traded derivatives, we have to price in a mark to model fasion. The calibration for each model was done using European call options for the S&P 500. Almost everything was done in MATLAB with the exception of recovering the interest rates and dividend yield, which was done in R. The main functions used in the project are described in further details below. 

### Recovering the interest rate and dividend yield

Recovering of interest rates and dividend yield was done in R. The basic way to recover both from the option-chain was:

* Select a number of ATM calls for all maturities.
* Compute prices of the put options using put-call parity.
* Now we choose the interest rates *r* and dividend yield *q* such that we minimize the squarred error between the market put prices and the put option prices recovered from the put-call parity:

<img src="images/eq1.svg" />

where *N* is the number of maturities and *M* is the number of put options. 


### Pricing of European call options

From standard pricing theory we know that analytical pricing formulas for options arise, when integrating the payoff against the density of the stock price process. However closed-form solutions for the densities of both processes are not available and thus we exploit the fact that they both have closed-form characteristic functions which provide the necessary condition to use Fourier pricing methods and recover the European call prices used in the calibration procedure. 

For the CGMY model we used the Fourier pricing teqnique of [Lewis (2001)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=282110), which meant that we had to use the characteristic function for the standardized stock price process. That is, divide by the discounted stock price on both sides. The characteristic function for the CGMY model is reduced to 

<img src="images/eq2.svg" />


and for z_i = 0.5, we can then recover the call prices for a vector of strikes by: 

<img src="images/eq3.svg" />


We have verified the above pricing approach using the FFT approach of [Carr & Madan (1999)](http://homepages.ulb.ac.be/~cazizieh/sp_files/CarrMadan%201998.pdf) (see below for integral), under the stock price process formulated as:

<img src="images/eq4.svg" />


which provides the same results as the Lewis approach. The pricing of European calls under the Heston model is done using [Carr & Madan (1999)](http://homepages.ulb.ac.be/~cazizieh/sp_files/CarrMadan%201998.pdf) FFT approach. Moreover we use the consistent characteristic function derived by [Schoutens et al. (2006)](https://perswww.kuleuven.be/~u0009713/ScSiTi03.pdf), 

<img src="images/eq5.svg" />


with 

<img src="images/eq6.svg" />


Then we can recover the call options for a vector of strikes using [Carr & Madan (1999)](http://homepages.ulb.ac.be/~cazizieh/sp_files/CarrMadan%201998.pdf) FFT approach

<img src="images/eq7.svg" />


with

<img src="images/eq8.svg" />




### Calibration procedure
The general calibration procedure involves minimizing the sum of squared error between the market calls and the model call prices across maturity and strikes 

<img src="images/eq9.svg" />


The MATLAB implemententation involves using the build-in function *lsqnonlin* to minimize the sum of squared error and find the parameter values for each model. An example is provided below.

```matlab
S0 = 2663.60
fun = @(x) price_lewis(S0, strikes, maturities, rates, dividend, x(1),x(2),x(3),x(4));

lossfunc_CGMY = @(x) (marketcalls - fun(x));

x0 = [26.9716  156.8135  222.8883    0.0106];

lb = [0.00001, 0, 0, 0.0001];
up = [inf, inf, inf 1.999999];
options = optimoptions(@lsqnonlin, 'Display', 'iter', ...
    'MaxFunctionEvaluations', 10000, 'MaxIterations', 10000);


solution=lsqnonlin(lossfunc_CGMY, x0, lb, up, options);

```


### Pricing of realized variance options 
in [Carr et al. (2005)](https://link.springer.com/article/10.1007/s00780-005-0155-x) derive a closed-form Laplace transform to the realized variance call options, which then can be numerically inverted in order to recover the call prices for a given vector of strikes. The Laplace transform is given as

<img src="images/eq10.svg" />


where 

<img src="images/eq11.svg" />


is the Laplace transform of the (non-)annualized quadratic variation, which is of much more complex nature for the CGMY model than for the Heston model. Moreover in the CGMY model we work with the non-annualized counterparts and then rescale the resulting quadratic variation as done in [Carr et al. (2005)](https://link.springer.com/article/10.1007/s00780-005-0155-x). In the Heston model we work with the annualized counterparts. 

In the Heston model we have provided 3 (different) formulations of the annualized Laplace transform for the integrated variance. The first two formulations are presented in [Pisani (2015)](http://pure.au.dk/portal/files/98446744/Camilla_Pisani_PhD_thesis.pdf) and the last formulation follows [Drimus (2012)](https://www.tandfonline.com/doi/full/10.1080/14697688.2011.565789), which all yield the same results. The first two formulations for [Pisani (2015)](http://pure.au.dk/portal/files/98446744/Camilla_Pisani_PhD_thesis.pdf) are provided in the functions *Integratedvar_laplacetrans.m* and *integratedvar_laplacetrans2.m* and the Drimus formulation is *drimuslaplace.m*. The code for the Laplace transform of the variance call is *Laplace_Hestonvar.m*. 

In the CGMY model we have only constructed the Laplace transform for the non-annualized quadratic variation provided in [Carr et al. (2005)](https://link.springer.com/article/10.1007/s00780-005-0155-x). The code is provided in the function *laplace_transform.m* and the code for the Laplace transform of the variance call is *Laplacetransform_varoptions.m*. 


In order to recover the variance call prices we have to invert the Laplace transform. We have done this using the Bromwich inversion integral given by 

<img src="images/eq12.svg" />


where *t* is a vector of strikes. This has been directly implemented in MATLAB:

```matlab
%example: 

a = 0.01; 
t =(0:0.01:0.25)*100; 
tic
int = @(u) real(feval(@Laplacetransform_varoptions,...
    a+1i.*u,rates,maturities,C*100^(Y), G/100,...
    M/100,Y)).*cos(u.*t); % Laplace transform of variance options. 
inversion6m = 2.*exp(a.*t)/pi .* integral(int,0,1000, 'ArrayValued', true); % Bromwich integral
toc

```

If one wants to use different inversion teqniques we advise to look at [Pisani (2015)](http://pure.au.dk/portal/files/98446744/Camilla_Pisani_PhD_thesis.pdf) who evaluates different Laplace inversion teqniques for the Laplace transform of a variance call option under the SVJ-v type model. 


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
