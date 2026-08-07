


The company loses customers. can we predict who is likely to leave so the marketing team can intervene?

## understanding numerical and categorical data:

numerical data: represents quantities.
you can perform mathematical operations on it, such as addition, subtraction, averaging and multiplication.


Categorical data:
it represents labels or groups, not quantities.

Caveat: just because something is number that doesnt mean it is numerical identifiers, because they are simply labels for customers like Customer ID: 1000, 1001, 1002, 1003

df.info() only counts actuall null values. it wont necessarily detect blank strings or other placeholders. so later we'll verify that there are no "hidden" missing values.


Data type int64, float64, object is not the same thing as feature type(numerical or categorical).


this is how data scientists work:
form a hypothesis
test it against the data
accept or reject the hypothesis based on evidence

Most of the work happens before machine learning. If the data isn't understood and prepared correctly, even the best algorithm wont produce reliable results.

## continue with EDA

understand the patterns, relationships and problems hidden inside the data

a model can learn from the patterns that exist in the data. So we need to understand those patterns first.

Imagine our dataset was:
NO-> 99%
YES -> 1%
a model that always predicts "NO" would get 99% accuracy but would be completely useless.
This is called class imbalance and it affects how we evaluate models.

Q: what types of customers are more likely to churn?
