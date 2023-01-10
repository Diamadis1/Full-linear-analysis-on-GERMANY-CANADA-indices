# Full-linear-analysis-on-GERMANY-CANADA-indices
Full linear analysis on GERMANY, CANADA indices, forecast one and two steps ahead, VAR model, Granger Causality

Comparing cross-correlation and granger causality we see that the two indicators influence each other in most time windows with a changing direction.

The cross-correlation is transferred from one indicator to another the next day and in some cases maybe two days after that.

![image](https://user-images.githubusercontent.com/98957437/211606705-06b7977e-10cb-48a8-98c7-1ff1ad11cde4.png)

Of course there is strong positive cross-correlation at Lag=0 which suggests that the indices are moving in the same direction on several occasions at time 0.
Models were selected based on AIC criteria with lag scores of 0–4.
![image](https://user-images.githubusercontent.com/98957437/211606958-065007e4-a0fe-4beb-a869-e1c1cfaf277f.png)

![image](https://user-images.githubusercontent.com/98957437/211607031-8dd7e43e-fff0-460d-9f8e-64d875aa8c1b.png)
Based on the previous analysis fitting ARIMA models is appropriate. The degree of these models will therefore vary between p=0-2, i=0 and q=0-2.
        (AR(0-2), MA (0-2).

To select the best models from these we used the Akaike and Bayesian information criteria to examine the nine possible combinations.

In most time windows the best model was estimated to be ARMA(2,2).
![image](https://user-images.githubusercontent.com/98957437/211607089-f27af207-d693-4b69-a103-ee4707315f8c.png)
![image](https://user-images.githubusercontent.com/98957437/211607141-e53378fe-9e3f-4ca9-9c6a-69456df9f717.png)

