we are started doing the EDA:

df["Churn"].value_counts(normalize=True)   // it gives you percentage
means that No -> 73%
yes 26%
73% of customers did not churn
26% customers churn

it is not severely imbalanced, highly imbalanced looks like No: 95% and yes: 5%

##### what should we do when the dataset is actaully imbalanced? is it a end of the machine learning thing, that this dataset is highly imbalanced we cannot proceed further until we get another dataset? is that how professionals do it in real life?

lets start the investigation
1. contract
Q. does contract type affect churn?
pd.crosstab() => creates a cross tabulation of two or more factors

Relationship we establish is: the longer the contract commitment, the lower the churn rate.
we dont immediately claim causation, but we can create hypotheses.

we just found out that month to month has higher churn rate, but that cannot be the only factor driving it, we have to see if other factors are influencing to it too?

If we train a model later, we expect contract to have high importance but we should not decide that only from intuition, we will eventually confirm using: 
    Feature importance, Model coefficients, and SHAP values

## correlation and causation:
correlation means two things move together, while causation means one thing makes the other happen. Correlation does not equal causation.
example: vegan ice cream sales and shark attackes go up at the same time because of hot summer weather, not because eating ice cream attracts sharks.


2. tenure:
   does tenure affect churn?

This is called grouped descriptive statistics.
   df.groupby("churn")["tenure"].describe()

   we are comparing the distribution of a numerical feature across different classes.


3. Does monthly price affect churn?

df.groupby("Churn")["MonthlyCharges"].describe()

higher monthly charges may be associated with higher churn.
Most churned customers are paying around 75-80 per month

correlation is not causation at all. just because we saw that high price has more churn that doesnt give us the right to say that it is true. we have to investigate further.



## standard deviation
how spread out the values are.
small std: customers have similar charges
large std: charges vary a lot

Stayed:
std = 31.09

Churned:
std = 24.66

The stayed customers have a wider range of charges.


4. Internet service

## hypothesis testing
the target is:
churn

Business question:
is customer contract type associated with churn?
H0: contract type and churn are independent
H1: contract type and churn are associated










