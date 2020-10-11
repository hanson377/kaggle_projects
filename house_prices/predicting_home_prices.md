Predicting Home Prices
================

## **Objectives**

In this document, we will explore using a Gradient Boosted model for
predicting home prices within the context of the class Kaggle
competition dataset.

-----

## **Exploratory Data Analysis**

-----

Let us begin by looking at the distribution for the variable we are
attempting to predict, SalePrice.

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](predicting_home_prices_files/figure-gfm/sale%20price%20distribution-1.png)<!-- -->

|     Mean | 10th Percentile |    25th | 50th | 75th | 90th |
| -------: | --------------: | ------: | ---: | ---: | ---: |
| 180.9212 |         106.475 | 129.975 |  163 |  214 |  278 |

-----

## **Factor Variables**

-----

Now that we have an understanding of our predictor variables
distribution, let us move onto identifying which factor variables seem
to have values significantly implacting our key variable. To do this, we
will cycle through a large number of boxplots and test for significance
with simple ANOVA models.

Below, we will examine the following:

1.  Location  
2.  Sales Condition

-----

## **Location**

Below, we examine Location’s impact on Sales Price. First, let us look
at a simple boxplot.

![](predicting_home_prices_files/figure-gfm/look%20at%20location-1.png)<!-- -->

| Factor Value | Sample Size |      Mean | 10th Percentile |     25th |    50th |     75th |     90th |
| :----------- | ----------: | --------: | --------------: | -------: | ------: | -------: | -------: |
| NAmes        |         225 | 145.84708 |        110.0000 | 127.5000 | 140.000 | 158.0000 | 180.3000 |
| CollgCr      |         150 | 197.96577 |        132.9500 | 152.9588 | 197.200 | 225.7250 | 260.1500 |
| OldTown      |         113 | 128.22530 |         87.0000 | 105.9000 | 119.000 | 140.0000 | 161.0000 |
| Edwards      |         100 | 128.21970 |         82.4500 | 101.5000 | 121.750 | 145.2250 | 177.2000 |
| Somerst      |          86 | 225.37984 |        162.2500 | 177.9750 | 225.500 | 252.9195 | 305.2385 |
| Gilbert      |          79 | 192.85451 |        167.5200 | 174.0000 | 181.000 | 197.2000 | 231.6000 |
| NridgHt      |          77 | 316.27062 |        202.5000 | 253.2930 | 315.000 | 374.0000 | 438.2924 |
| Sawyer       |          74 | 136.79314 |        110.5300 | 127.2500 | 135.000 | 149.4625 | 167.1000 |
| NWAmes       |          73 | 189.05007 |        152.0000 | 165.1500 | 182.900 | 205.0000 | 241.2000 |
| SawyerW      |          59 | 186.55580 |        119.7128 | 145.5000 | 179.900 | 222.5000 | 264.2040 |
| BrkSide      |          58 | 124.83405 |         78.6000 | 100.5000 | 124.300 | 141.1750 | 181.5500 |
| Crawfor      |          51 | 210.62473 |        139.0000 | 159.2500 | 200.624 | 239.0000 | 311.5000 |
| Mitchel      |          49 | 156.27012 |        118.6000 | 131.0000 | 153.500 | 171.0000 | 202.0600 |
| NoRidge      |          41 | 335.29532 |        250.0000 | 265.0000 | 301.500 | 341.0000 | 430.0000 |
| Timber       |          38 | 242.24745 |        173.5000 | 186.9000 | 228.475 | 286.1157 | 321.3500 |
| IDOTRR       |          37 | 100.12378 |         55.0000 |  81.0000 | 103.000 | 120.5000 | 140.0400 |
| ClearCr      |          28 | 212.56543 |        151.4000 | 183.7500 | 200.250 | 242.2250 | 277.9000 |
| StoneBr      |          25 | 310.49900 |        188.1000 | 213.5000 | 278.000 | 377.4260 | 476.6142 |
| SWISU        |          25 | 142.59136 |        107.2000 | 128.0000 | 139.500 | 160.0000 | 185.2000 |
| Blmngtn      |          17 | 194.87088 |        164.4240 | 174.0000 | 191.000 | 213.4900 | 239.0312 |
| MeadowV      |          17 |  98.57647 |         78.2000 |  83.5000 |  88.000 | 115.0000 | 131.5400 |
| BrDale       |          16 | 104.49375 |         86.7000 |  91.0000 | 106.000 | 118.0000 | 121.0000 |
| Veenker      |          11 | 238.77273 |        165.0000 | 184.2500 | 218.000 | 282.0000 | 324.0000 |
| NPkVill      |           9 | 142.69444 |        127.9000 | 140.0000 | 146.000 | 148.5000 | 149.8000 |
| Blueste      |           2 | 137.50000 |        126.7000 | 130.7500 | 137.500 | 144.2500 | 148.3000 |

-----

## **Sales Condition**

Now, we move on to examining Sales Condition’s impact on Sales Price.

![](predicting_home_prices_files/figure-gfm/look%20at%20sale%20condition-1.png)<!-- -->

| Factor Value | Sample Size |     Mean | 10th Percentile |     25th |    50th |    75th |     90th |
| :----------- | ----------: | -------: | --------------: | -------: | ------: | ------: | -------: |
| Normal       |        1198 | 175.2022 |        107.9700 | 130.0000 | 160.000 | 205.000 | 265.2700 |
| Partial      |         125 | 272.2918 |        164.5800 | 193.8790 | 244.600 | 339.750 | 419.9192 |
| Abnorml      |         101 | 146.5266 |         84.9000 | 104.0000 | 130.000 | 172.500 | 220.0000 |
| Family       |          20 | 149.6000 |        103.3000 | 115.5000 | 140.500 | 170.250 | 226.0000 |
| Alloca       |          12 | 167.3774 |         91.4198 | 116.3833 | 148.145 | 202.043 | 268.1030 |
| AdjLand      |           4 | 104.1250 |         81.3000 |  81.7500 | 104.000 | 126.375 | 127.0500 |

    ## Call:
    ##    aov(formula = SalePrice ~ SaleCondition, data = train)
    ## 
    ## Terms:
    ##                 SaleCondition    Residuals
    ## Sum of Squares   1.247649e+12 7.960263e+12
    ## Deg. of Freedom             5         1454
    ## 
    ## Residual standard error: 73991.44
    ## Estimated effects may be unbalanced

From the above, we know a few things. The simple boxplot seems to imply
that ‘Partial’ and ‘AdjLand’ houses might be significantly different
from the other condition types. A post-hoc Tukey test seems to confirm.
Although our ANOVA model itself is not of significance, the Tukey HSD
reveals that there exist significant differences between most conditions
and the two types named above.

As a result, we should generate binaries for these two types and
incorporate them into our model. However, it should be noted that houses
with these conditions are rather small in volume, so we might not expect
them to make a huge difference.

-----

## **Continuous Variables: Correlation**

-----

Now that we have a few factor variables to make a part of our model,
lets now examine some correlations between some of our predictor
variables and Sales Price.

To get an initial look at some of our strongest correlations, we will
product a correlation matrix containing the relationships between all of
our numeric variables.

Below, we can see that some of the most correlationed variables include:
Living area, Garage area, Total Basement Square Footage, and First Floor
Square Footed.

``` r
keep <- c('SalePrice','LotFrontage','LotArea','MasVnrArea','BsmtFinSF1','BsmtFinSF2','BsmtUnfSF','TotalBsmtSF','X1stFlrSF','X2ndFlrSF','LowQualFinSF','GrLivArea','GarageArea','WoodDeckSF','OpenPorchSF')

scale_numeric <- data.frame(scale(na.omit(train[keep])))

correlations <- scale_numeric %>% correlate() %>% focus(SalePrice)
```

    ## 
    ## Correlation method: 'pearson'
    ## Missing treated using: 'pairwise.complete.obs'

``` r
ggplot(correlations,aes(x=reorder(rowname,-SalePrice),y=SalePrice,fill=rowname)) + geom_bar(stat='identity') + xlab('Variable') + ylab('Pearson Correlation with Sale Price') + theme(legend.position='bottom',legend.title=element_blank()) + ggtitle("Pearson Correlations for Sale Price")
```

![](predicting_home_prices_files/figure-gfm/identify%20numerics-1.png)<!-- -->

``` r
ggplot(scale_numeric, aes(x=SalePrice,y=GrLivArea)) + geom_point()
```

![](predicting_home_prices_files/figure-gfm/individual%20relationships-1.png)<!-- -->

``` r
ggplot(scale_numeric, aes(x=SalePrice,y=GarageArea)) + geom_point()
```

![](predicting_home_prices_files/figure-gfm/individual%20relationships-2.png)<!-- -->

``` r
ggplot(scale_numeric, aes(x=SalePrice,y=TotalBsmtSF)) + geom_point()
```

![](predicting_home_prices_files/figure-gfm/individual%20relationships-3.png)<!-- -->

``` r
ggplot(scale_numeric, aes(x=SalePrice,y=X1stFlrSF)) + geom_point()
```

![](predicting_home_prices_files/figure-gfm/individual%20relationships-4.png)<!-- -->

``` r
ggplot(scale_numeric, aes(x=SalePrice,y=MasVnrArea)) + geom_point()
```

![](predicting_home_prices_files/figure-gfm/individual%20relationships-5.png)<!-- -->

``` r
ggplot(scale_numeric, aes(x=SalePrice,y=BsmtFinSF1)) + geom_point()
```

![](predicting_home_prices_files/figure-gfm/individual%20relationships-6.png)<!-- -->

-----

## **Condition Model**

-----

We will now train a model with the variables we identified as helpful
above. We will also generate a simple OLS model for comparison purposes
to ensure that the gradient boosted model is superior.

``` r
set.seed(1)

keep <- c('SalePrice','GrLivArea','GarageArea','TotalBsmtSF','X1stFlrSF','MasVnrArea','BsmtFinSF1','Neighborhood')

final <- train[keep]

model1 <- gbm(SalePrice~GrLivArea+GarageArea+TotalBsmtSF+X1stFlrSF+MasVnrArea+BsmtFinSF1,data=final, distribution="gaussian",n.trees=5000, interaction.depth=4)
summary(model1)
```

![](predicting_home_prices_files/figure-gfm/run%20model-1.png)<!-- -->

    ##                     var   rel.inf
    ## GrLivArea     GrLivArea 31.387799
    ## TotalBsmtSF TotalBsmtSF 20.438242
    ## GarageArea   GarageArea 19.697099
    ## BsmtFinSF1   BsmtFinSF1 12.169876
    ## X1stFlrSF     X1stFlrSF  8.815345
    ## MasVnrArea   MasVnrArea  7.491638

``` r
simple_linear <- lm(SalePrice~GrLivArea+GarageArea+TotalBsmtSF+X1stFlrSF+MasVnrArea+BsmtFinSF1,data=final)
summary(simple_linear)
```

    ## 
    ## Call:
    ## lm(formula = SalePrice ~ GrLivArea + GarageArea + TotalBsmtSF + 
    ##     X1stFlrSF + MasVnrArea + BsmtFinSF1, data = final)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -682145  -19342     562   18786  268450 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) -12495.612   4320.557  -2.892  0.00388 ** 
    ## GrLivArea       66.973      2.909  23.022  < 2e-16 ***
    ## GarageArea      92.596      6.783  13.652  < 2e-16 ***
    ## TotalBsmtSF     42.121      5.004   8.417  < 2e-16 ***
    ## X1stFlrSF       -6.948      5.789  -1.200  0.23032    
    ## MasVnrArea      50.772      7.419   6.844 1.14e-11 ***
    ## BsmtFinSF1      14.228      3.065   4.642 3.77e-06 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 44950 on 1445 degrees of freedom
    ##   (8 observations deleted due to missingness)
    ## Multiple R-squared:  0.6799, Adjusted R-squared:  0.6785 
    ## F-statistic: 511.5 on 6 and 1445 DF,  p-value: < 2.2e-16

We now generate some predictions and visualize them against the actual
observed values.

``` r
## generate predictions
final$pred_boost=predict(model1,newdata=final,n.trees=5000)
final$pred_ols=predict(simple_linear,newdata=final,n.trees=5000)

## view predicted versual actual
ggplot(final, aes(x=pred_boost/1000,y=SalePrice/1000)) + geom_point() + xlab('Predicted Sale Price') + ylab('Sale Price from Training Data') + coord_cartesian(xlim=c(0,600),ylim=c(0,600)) + geom_abline(intercept = 0, slope = 1, linetype='dashed',colour='red')
```

![](predicting_home_prices_files/figure-gfm/generate%20preds-1.png)<!-- -->

``` r
ggplot(final, aes(x=pred_ols/1000,y=SalePrice/1000)) + geom_point() + xlab('Predicted Sale Price') + ylab('Sale Price from Training Data') + coord_cartesian(xlim=c(0,600),ylim=c(0,600)) + geom_abline(intercept = 0, slope = 1, linetype='dashed',colour='red')
```

    ## Warning: Removed 8 rows containing missing values (geom_point).

![](predicting_home_prices_files/figure-gfm/generate%20preds-2.png)<!-- -->

It is pretty clear from the above that the boosted model is far superior
to the simple ols model. However, we can quantify this by calculating
and comparing the mean squared error for both models.

When do we do this, we see that the mean squared error is decreased by
nearly 100% with the boosted model.

``` r
## calculate mean squared error
mse2_boost <- mean((final$pred_boost - final$SalePrice)^2,na.rm=TRUE)
mse2_ols <- mean((final$pred_ols - final$SalePrice)^2,na.rm=TRUE)
delta <- ((mse2_boost/mse2_ols)-1)*100
```

Boosted Model: 3.784064110^{7}

OLS Model: 2.011014510^{9}

% Delta: -98.1183308
