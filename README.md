# Time-series FGV
I.	Introdução:
O agronegócio desempenha um importante papel na geração de riqueza no Brasil. Nas últimas décadas, o setor conviveu com inovações em produção e a Empresa Brasileira de Pesquisa Agropecuária – EMBRAPA, tem um papel relevante neste processo. 
O agronegócio efetua anualmente elevados investimentos que retroalimenta toda uma gama de cadeias econômicas, além de contribuir com uma maior eficiência e eficácia na produção de alimentos. Neste quesito, o consumo de fertilizantes ocupa uma parcela signiﬁcativa dos investimentos realizados.

II.	Base de Dados: 
Os dados do arquivo anexado “Ferti.xlsx” contempla a entrega de fertilizantes ao mercado em mil toneladas no período mensal de janeiro de 1998 a janeiro de 2020.  
A fonte dos dados é o sítio da Associação Nacional para Difusão de Adubos –ANDA (http://anda.org.br/estatisticas/).

III.	O trabalho individual: 

O trabalho individual deverá ser entregue sob a forma de um relatório em Word (ou pdf) juntamente com o script em R. As etapas são: 

a.	Um breve comentário inicial relacionado à análise exploratória dos dados, incluindo a visualização, identificação de padrões, decomposição e o entendimento do padrão da série. 

b.	Considerar os seguintes subconjuntos de dados:
Intervalo de janeiro/2007 até dezembro/ 2018 para modelagem da série temporal (train).
intervalo de janeiro/2019 a janeiro/2020 será base para testar o modelo.

c.	Selecionar os modelos de estudo: Holt-Winters Aditivo e o Multiplicativo, bem como o Modelo SARIMA(p,d,q)(P,D,Q)[s].
d.	Plotar os correlogramas ACF e PACF.
e.	Verificar a estacionariedade da série no modelo SARIMA(p,d,q)(P,D,Q)[s].

f.	 Os parâmetros do modelo são estatisticamente significativos? 

g.	Efetuar os testes de diagnósticos para o modelo SARIMA(p,d,q)(P,D,Q)[s] (Ausência de autocorrelação serial; ausência de heterocedasticidade condicional; normalidade).
h.	Qual é o melhor modelo? Justifique.

i.	Efetuar o teste e comparar com os resultados do subconjunto teste.

j.	Efetuar a previsão para um período até dezembro-2021

k.	Conclusão sucinta
