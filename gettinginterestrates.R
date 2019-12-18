library(pracma)



#-------------------------------Isolating interest rates and dividends ----------------------------------------

strikes = c(2550, 2575, 2600, 2625, 2650, 2675, 2700, 2725, 2750)

maturities = c(37/365, 65/365, 93/365, 184/365, 282/365, 373/365)

#Market put options
marketputs = read.table('marketputs2.csv')

#Derived put-call parity options (derived in MATLAB). 
pcpcalls = read.table('pcpcalls2.csv')


PutCallParity <- function(calls, strikes, maturity, rate, dividend){

	temp <- calls + strikes * exp(-rate * maturity) - 2662.85*exp(-dividend*maturity)

	return(temp)
}

errorfunction <- function(x){

	diff <- matrix(0L, nrow=9, ncol=6)

	diff[1:9,1] <- (PutCallParity(pcpcalls[1:9,1], strikes[1:9], maturities[1], x[1], x[7]) - marketputs[1:9,1])
	diff[1:9,2] <- (PutCallParity(pcpcalls[10:18,1], strikes[1:9], maturities[2] , x[2], x[7]) -  marketputs[10:18,1])
	diff[1:9,3] <- (PutCallParity(pcpcalls[19:27,1], strikes[1:9],maturities[3] , x[3], x[7]) -  marketputs[19:27,1])
	diff[1:9,4] <- (PutCallParity(pcpcalls[28:36,1], strikes[1:9],maturities[4] , x[4], x[7]) -  marketputs[28:36,1])
	diff[1:9,5] <- (PutCallParity(pcpcalls[37:45,1], strikes[1:9],maturities[5] , x[5], x[7]) -  marketputs[37:45,1])
	diff[1:9,6] <- (PutCallParity(pcpcalls[46:54,1], strikes[1:9],maturities[6] , x[6], x[7]) -  marketputs[46:54,1])

	return(diff)
}


fun <- function(x){sum(errorfunction(x)^2)}

estimates <- nlm(fun, c(0.03,0.017,0.017,0.017,0.017,0.017,0.017))$estimate



library(ggplot2)

matplot <- data.frame(maturities)
estplot <- data.frame(estimates[-7])

ggplot() + geom_line(aes(x=matplot[,1], y=estplot[,1]*100), col="steelblue", size = 1) + 
	xlab('Annualized maturity') + ylab('Interest rates (%)') + 
		theme(plot.title = element_text(hjust = 0.5, size=14, face='bold'))+ 
  ggtitle("Recovered interest rates from options")


dividend <- estimates[7]

rates <- estimates[1:6]


#-------------------------------------------------------------------------------------------------------------


