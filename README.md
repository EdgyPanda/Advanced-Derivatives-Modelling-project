# Advanced Derivatives modelling project

## Pricing of European call options & realized variance options under the exponential CGMY Lévy model and the Heston model.

The main purpose of this project was to price realized variance options under the exponential CGMY Lévy model and the Heston model. Since realized variance options are exotic non-traded derivatives, we have to price in a mark to model fasion. The calibration for each model was done using European call options for the S&P 500. Almost everything was done in MATLAB with the exception of recovering the interest rates and dividend yield, which was done in R. The main functions used in the project are described in further details below. 

### Recovering the interest rate and dividend yield

Recovering of interest rates and dividend yield was done in R. The basic way to recover both from the option-chain was:

* Select a number of ATM calls for all maturities.
* Compute prices of the put options using put-call parity.
* Now we choose the interest rates *r* and dividend yield *q* such that we minimize the squarred error between the market put prices and the put option prices recovered from the put-call parity:

<img src="https://latex.codecogs.com/svg.latex?\min_{r_i,q}&space;\sum_{i=1}^{N}&space;\sum_{j=1}^{M}&space;\left(Put_{PC}(K_j,T_i,r_{T_i},q)&space;-&space;Put_{Market}(K_j,T_i)\right)^2." title="\min_{r_i,q} \sum_{i=1}^{N} \sum_{j=1}^{M} \left(Put_{PC}(K_j,T_i,r_{T_i},q) - Put_{Market}(K_j,T_i)\right)^2." />

where *N* is the number of maturities and *M* is the number of put options. 


### Pricing European call options

From standard pricing theory we know that analytical pricing formulas for options arise, when integrating the payoff against the density of the stock price process. However closed-form solutions for the densities of both processes are not available and thus we exploit the fact that they both have closed-form characteristic functions which provide the necessary condition to use Fourier pricing methods and recover the European call prices used in the calibration procedure. 

For the CGMY model we used the Fourier pricing teqnique of [Lewis (2001)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=282110), which meant that we had to use the characteristic function for the standardized stock price process. That is, divide by the discounted stock price on both sides. The characteristic function for the CGMY model is reduced to 

<img src="https://latex.codecogs.com/svg.latex?\phi_T^0(u)=e^{-iu\omega&space;T&plus;TC\Gamma(-Y)\left[(M-iu)^Y-M^Y&plus;(G&plus;iu)^Y-G^Y\right]}," title="\phi_T^0(u)=e^{-iu\omega T+TC\Gamma(-Y)\left[(M-iu)^Y-M^Y+(G+iu)^Y-G^Y\right]}," />

and for z_i = 0.5, we can then recover the call prices for a vector of strikes by: 

<img src="https://latex.codecogs.com/svg.latex?C(S_0,K,T)&space;=&space;S_0e^{-qT}&space;-&space;\frac{\sqrt{S_0K}e^{-(r&plus;q)T/2}}{\pi}\int_{0}^{\infty}\Re\left[e^{iuk}\phi_T^0\left(u-\frac{i}{2}\right)\right]\frac{du}{u^2&space;&plus;&space;\frac{1}{4}}." title="C(S_0,K,T) = S_0e^{-qT} - \frac{\sqrt{S_0K}e^{-(r+q)T/2}}{\pi}\int_{0}^{\infty}\Re\left[e^{iuk}\phi_T^0\left(u-\frac{i}{2}\right)\right]\frac{du}{u^2 + \frac{1}{4}}." />

We have verified the above pricing approach using the FFT approach of [Carr & Madan (1999)](http://homepages.ulb.ac.be/~cazizieh/sp_files/CarrMadan%201998.pdf) (see below for integral), under the stock price process formulated as:

<img src="https://latex.codecogs.com/svg.latex?\phi_{\ln(S_t))}(u,t)&space;=&space;e^{iu(\ln(S0)&plus;((r-q)&space;&plus;\omega)t)&plus;L_{CGMY}(t))}" title="\phi_{\ln(S_t))}(u,t) = e^{iu(\ln(S0)+((r-q) +\omega)t)+L_{CGMY}(t))}" />

which provides the same results as the Lewis approach. The pricing of European calls under the Heston model is done using [Carr & Madan (1999)](http://homepages.ulb.ac.be/~cazizieh/sp_files/CarrMadan%201998.pdf) FFT approach. Moreover we use the consistent characteristic function derived by [Schoutens et al. (2006)](https://perswww.kuleuven.be/~u0009713/ScSiTi03.pdf), 

<img src="https://latex.codecogs.com/svg.latex?\phi(u,T)&space;=&space;\exp\left\{iu(\log(S_0)&plus;(r-q)T)&plus;\frac{\kappa\theta}{\sigma^2}\left[(\xi&space;-&space;d)T-2\log\left(\frac{1-ge^{-dT}}{1-g}\right)\right]&plus;\frac{v_0}{\sigma^2}(\xi-d)\frac{1-e^{-dT}}{1-ge^{-dT}}\right\}," title="\phi(u,T) = \exp\left\{iu(\log(S_0)+(r-q)T)+\frac{\kappa\theta}{\sigma^2}\left[(\xi - d)T-2\log\left(\frac{1-ge^{-dT}}{1-g}\right)\right]+\frac{v_0}{\sigma^2}(\xi-d)\frac{1-e^{-dT}}{1-ge^{-dT}}\right\}," />

with 

<img src="https://latex.codecogs.com/svg.latex?\xi&space;=&space;\kappa&space;-&space;\rho&space;\sigma&space;ui,&space;\qquad&space;d=&space;\sqrt{(-\varepsilon)^2-\sigma^2(-iu-u^2)},&space;\qquad&space;g&space;=&space;\frac{\xi&space;-&space;d}{\xi&space;&plus;&space;d}." title="\xi = \kappa - \rho \sigma ui, \qquad d= \sqrt{(-\varepsilon)^2-\sigma^2(-iu-u^2)}, \qquad g = \frac{\xi - d}{\xi + d}." />

Then we can recover the call options for a vector of strikes using [Carr & Madan (1999)](http://homepages.ulb.ac.be/~cazizieh/sp_files/CarrMadan%201998.pdf) FFT approach

<img src="https://latex.codecogs.com/svg.latex?C(K,T)&space;=&space;\frac{e^{-\alpha\log(K)}}{\pi}&space;\int_{0}^{\infty}&space;\Re\left(e^{-iu\log(K)}&space;\varrho(u)\right)&space;\:&space;du," title="C(K,T) = \frac{e^{-\alpha\log(K)}}{\pi} \int_{0}^{\infty} \Re\left(e^{-iu\log(K)} \varrho(u)\right) \: du," />

with

<img src="https://latex.codecogs.com/svg.latex?\varrho(u)&space;=&space;\frac{e^{-rT}\phi(u-(\alpha&plus;1)i,T)}{\alpha^2&plus;\alpha-u^2&plus;i(2\alpha&plus;1)u}." title="\varrho(u) = \frac{e^{-rT}\phi(u-(\alpha+1)i,T)}{\alpha^2+\alpha-u^2+i(2\alpha+1)u}." />



### Calibration procedure
The general calibration procedure involves minimizing the sum of squared error between the market calls and the model call prices across maturity and strikes 

<img src="https://latex.codecogs.com/svg.latex?\theta^*&space;=&space;\min_{\theta}&space;\sum_{i,j}&space;\left(C_{Model}(S_0,T_j,K_i,\theta)&space;-&space;C(S0,K_i,T_j)\right)^2." title="\theta^* = \min_{\theta} \sum_{i,j} \left(C_{Model}(S_0,T_j,K_i,\theta) - C(S0,K_i,T_j)\right)^2." />

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

<img src="https://latex.codecogs.com/svg.latex?L(\lambda,T)&space;=&space;\int_{0}^{\infty}&space;e^{-\lambda&space;K}&space;C(K,T)\:&space;dK&space;=&space;e^{-rT}&space;\left[\frac{\gamma(\lambda,&space;T)-1}{\lambda^2}&plus;&space;\frac{\mathbb{E}[Q(0,T)]}{\lambda}\right]." title="L(\lambda,T) = \int_{0}^{\infty} e^{-\lambda K} C(K,T)\: dK = e^{-rT} \left[\frac{\gamma(\lambda, T)-1}{\lambda^2}+ \frac{\mathbb{E}[Q(0,T)]}{\lambda}\right]," />

where 

<img src="https://latex.codecogs.com/svg.latex?\gamma(\lambda,&space;T)&space;=&space;\mathbb{E}\left[e^{-\lambda&space;Q(0,T)}\right]." title="\gamma(\lambda, T) = \mathbb{E}\left[e^{-\lambda Q(0,T)}\right]." />

is the Laplace transform of the (non-)annualized quadratic variation, which is of much more complex nature for the CGMY model than for the Heston model. Moreover in the CGMY model we work with the non-annualized counterparts and then rescale the resulting quadratic variation as done in [Carr et al. (2005)](https://link.springer.com/article/10.1007/s00780-005-0155-x). In the Heston model we work with the annualized counterparts. 
 


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.