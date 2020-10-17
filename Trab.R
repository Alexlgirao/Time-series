library(fpp)
library(fpp2)
library(tseries) 
library(forecast)
library(TSstudio)
library(readxl)
library(BETS)
library(gridExtra)

df <- read_excel("Ferti.xlsx")

head(df)
tail(df)
class(df$consumo)


########### Tranformando em TS #########

fert.ts <- ts(df$consumo , frequency = 12, 
              start = c(1998,1), end = c(2019,9))

fert.ts

###### EDA ######

autoplot(fert.ts)+
  ggtitle("Entrega de Fertilizantes")+
  xlab("Ano")+
  ylab("Milhares de tonelada")

ggseasonplot(fert.ts, year.labels = TRUE, year.label.left = TRUE)+
  ylab("Milhares de tonelada")+ xlab("Mês") + ggtitle("Entrega de Fertilizantes 1998 - 2019")

ts_seasonal(fert.ts, type = "box")

autoplot(decompose(fert.ts, type = "multiplicative"))
autoplot(decompose(fert.ts, type = "additive"))
corrgram(fert.ts, lag.max=36)


############ Separação de train / tests ############

ts.train <- window(fert.ts, start=c(2007,1), end=c(2018,12))

ts.test <- window(fert.ts, start = c(2019,1), end=c(2020, 1))

################## Modelagem ############

########## Holt-Winters Aditivo ##########

hw.a <- hw(ts.train, seasonal = "additive", h = 15, level = 95) 
fit.hwa <- hw.a$fitted 
fit.hwa

autoplot(ts.train, series = "Série_Real", lwd= 1.2)+ #serie_original
  autolayer(fit.hwa, series = "modelo HW- Aditivo", lwd = 1.2)+ # Ajuste do modelo
  autolayer(hw.a, series = "Previsão", showgap = FALSE)



########## Holt-Winters Multiplicativo ##########


hw.m <- hw(ts.train, seasonal = "multiplicative", h = 15, level = 95)
fit.hwm <- hw.m$fitted
fit.hwm

hw.m

autoplot(ts.train, series = "Série Orignal", lwd= 1.1)+ #serie_original
  autolayer(fit.hwm, series = "modelo HW-Multiplicativo", lwd =1.1)+# Ajuste do modelo
  autolayer(hw.m ,series = "Previsão", showgap = FALSE) # previsão h= 12 períodos 





#################### Verificar Autocorrelação ########

tsdisplay(ts.train)


############ testes formais ###########
# Regra de Ouro: P-VALOR BAIXO INDICA REJEITAR Ho #

# AUGMENTED DICKEY-FULLER - É o teste mais usado

# Ho: A série não é estacionária (status quo)
# H1: A série é estacionária (alternativa)
adf.test(ts.train)
#data:  fert.ts
#Dickey-Fuller = -10.003, Lag order = 6, p-value = 0.01
#alternative hypothesis: stationary
# Rejeita h0 

kpss.test(ts.train)
# 2. KPSS # esse é o único teste em que a Ho é série estacionária

# Ho: A série é estacionária (status quo)
# H1: A série não é estacionária
pp.test(ts.train)

# Ho: A série não é estacionária (status quo)
# H1: A série é estacionária


checkresiduals(ts.train)
########## 1 diferença  #########

diff.fert <- diff(ts.train)

tsdisplay(diff.fert)

adf.test(diff.fert)
#data:  fert.ts
#Dickey-Fuller = -10.003, Lag order = 6, p-value = 0.01
#alternative hypothesis: stationary
# Rejeita h0 

kpss.test(diff.fert)
#data:  diff.fert
#KPSS Level = 0.014767, Truncation lag parameter = 4, p-value = 0.1

pp.test(diff.fert)
checkresiduals(diff.fert)

#### pelos testes a serie é estacionaria 

### Modelo Arima
auto.arima(diff.fert, seasonal = TRUE, 
           stepwise = FALSE, approximation = FALSE)

# ARIMA(2,0,0)(2,1,0)[12] with drift 
sarima <- Arima(diff.fert, order = c(2,0,1), seasonal = c(2,1,0),
                method = "ML")

sarima
t_test(model = sarima)
# teste de ausência de autocorrelação serial

# teste Ljung-Box
Box.test(x = sarima$residuals, lag=12, type = "Ljung-Box", fitdf = 5)
checkresiduals(sarima)
# Não podemos rejeitar Ho. A série é iid

# Checando a Heterocedasticidade

# Teste proposto por Engle (1982) # GARCH

# Ho: Os resíduos ao quadrado são uma sequência de
#       ruídos brancos, ou     seja, os resíduos são homocedásticos.

# H1: a série é heterocedástico

require(FinTS)
library(FinTS)

ArchTest(sarima$residuals, lags = 36)


# Não rejeitamos a hipóse nula. A série se comporta como um WN.


# NORMALIDADE

# Ho : ~ N(mi, sigma2)
# H1 : Rejeita Ho

require(normtest)
library(normtest)

jb.norm.test(sarima$residuals, nrepl = 2000)

shapiro.test(sarima$residuals)

hist(sarima$residuals)

round(summary(sarima$residuals), digits = 3)
#não rejeita H0

#################### Comparando os modelos ##############

accuracy(hw.a$model)
accuracy(hw.m$model)
accuracy(sarima)


AIC(sarima)
AIC(hw.a$model)
AIC(hw.m$model)

#modelo escolhido Sarima


# Previsão

require(forecast)

forecast.arima <- forecast(object = sarima, h = 15, level = 95)

forecast.arima$fitted

autoplot(fert.ts, series = "Serie Original")+
  #autolayer(ts.test, lwd = 1.5) #+
  autolayer(forecast.arima$fitted, series = "Modelo AUTOARIMA")+
  autolayer(forecast.arima, series = "Previsão", showgap = FALSE , lwd = 0.5)+
  ggtitle("Entrega de Fertilizantes")+
  xlab("Ano")+
  ylab("Milhares de tonelada")


autoplot(ts.test , series = "Serie de teste")+
  autolayer(forecast.arima$upper, series = "Limite Maximo da previsão")+
  autolayer(forecast.arima$lower, series = "Limite Minimo da previsão")+
  ggtitle("Entrega de Fertilizantes")+
  xlab("Ano")+
  ylab("Milhares de tonelada")
