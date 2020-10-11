Predicting Survival on the Titanic:
================

**Objective:** Compare the predictive power of the following methods:

1.  Logistic Regression  
2.  Classification Tree
3.  Random Forest  
4.  Gradient Boosting

After comparing the above methods, apply model to test data supplied by
Kaggle and upload to see how I rank among other Kaggle Users.

## **Exploratory Data Analysis**

First, we will explore our data to identify key variables that we might
want to include in any predictive model. To do this most efficiently, we
will first define a few functions to quickly cycle through and visualize
differences across factor variables and their values as they relate to
survival rates.

Now that we have some functions, we can quickly calculate survival rates
and visualize them alongside eachother.

![](summary_findings_files/figure-gfm/compare%20survival%20rates%20across%20values%20for%20key%20factor%20variables-1.png)<!-- -->

## **Model Building**

Now that we have our key variables, let us train a few different models
with the variables we identified above. We will then compare the
accuracy of these different models. Namely, we will be comparing
logistic regression, classification trees, and random forest methods.

In the code below, you will the code I use for generating these models.

-----

### **Classification Tree**

-----

``` r
set.seed(1431)

tree <- tree(Survived~.,data=train)
plot(tree)
text(tree)
```

![](summary_findings_files/figure-gfm/look%20at%20tree%20method-1.png)<!-- -->

``` r
prediction_tree <- predict(tree, train, type="class")  # predicted scores
```

-----

### **Logistic Regression**

-----

``` r
logistic <- glm(Survived~.,data=train,family='binomial')
summary(logistic)
```

    ## 
    ## Call:
    ## glm(formula = Survived ~ ., family = "binomial", data = train)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.4374  -0.6331  -0.3443   0.5831   2.5068  
    ## 
    ## Coefficients:
    ##                       Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)           4.440079   0.690718   6.428 1.29e-10 ***
    ## Pclass2              -0.800324   0.468425  -1.709  0.08754 .  
    ## Pclass3              -1.994851   0.481897  -4.140 3.48e-05 ***
    ## EmbarkedQ            -1.194722   0.571989  -2.089  0.03673 *  
    ## EmbarkedS            -0.619350   0.282985  -2.189  0.02862 *  
    ## SibSp_altNot Zero    -0.616628   0.247976  -2.487  0.01290 *  
    ## Parch_altNot Zero    -0.667637   0.291924  -2.287  0.02219 *  
    ## cabin_statusno cabin -0.667183   0.394124  -1.693  0.09049 .  
    ## Fare                  0.001046   0.002549   0.410  0.68159    
    ## Age                  -0.030155   0.009902  -3.045  0.00232 ** 
    ## titleMiss            -0.044465   0.472980  -0.094  0.92510    
    ## titleMr              -2.814893   0.527326  -5.338 9.39e-08 ***
    ## titleMrs              0.873836   0.539645   1.619  0.10539    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 960.90  on 711  degrees of freedom
    ## Residual deviance: 601.32  on 699  degrees of freedom
    ## AIC: 627.32
    ## 
    ## Number of Fisher Scoring iterations: 5

``` r
prediction_logit <- predict(logistic, train, type="response")  # predicted scores

optCutOff <- optimalCutoff(train$Survived, prediction_logit)
prediction_logit <- ifelse(prediction_logit >= optCutOff,1,0)
prediction_logit <- factor(prediction_logit)
```

-----

### **Random Forest**

-----

``` r
forest_model <- randomForest(Survived~., data=train, ntree=500, proximity=T)
prediction_forest <- predict(forest_model, train, type="response")  # predicted scores
```

-----

### **Gradient Boosting**

-----

``` r
temp <- train
temp$Survived <- as.numeric(temp$Survived)

temp$Survived <- temp$Survived-1

boosting_model <- gbm(Survived~., data=temp, distribution='bernoulli',n.trees=10000,interaction.depth=8,shrinkage=0.001)
prediction_boost <- predict(boosting_model, train, n.trees=10000, type = 'response')  # predicted scores

optCutOff <- optimalCutoff(temp$Survived, prediction_boost, optimiseFor = 'misclasserror')
prediction_boost <- ifelse(prediction_boost >= optCutOff,1,0)
prediction_boost <- factor(prediction_boost)

remove(temp)
```

Now that we have our models conditioned, lets compare the accuracy of
our models. We will compare our models on three key metrics:

1.  Misclassification Rates
2.  Sensitivity
3.  Specificity

![](summary_findings_files/figure-gfm/view%20key%20model%20summary%20metrics%20side%20by%20side-1.png)<!-- -->

## **Predictions**

Now that we have a clear winner in the gradient boosted model, lets take
that model and apply it to the test data supplied by Kaggle.

``` r
test <- read.csv("/Users/hanson377/Documents/GitHub/kaggle_projects/Titanic/data/test.csv")
temp <- prepare(test)
test <- data.frame(PassengerId = test$PassengerId,temp)
rm(temp)

test$Survived <- predict(boosting_model, test, type="response")  # predicted scores
```

    ## Using 10000 trees...

``` r
test$Survived <- ifelse(test$Survived >= optCutOff,1,0)

final <- test %>% select(PassengerId,Survived)
final$Survived <- as.numeric(final$Survived)
write.csv(final, "/Users/hanson377/Documents/GitHub/kaggle_projects/Titanic/data/gender_submission.csv", row.names=FALSE)
```
