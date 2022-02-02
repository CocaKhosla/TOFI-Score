# TOFI-Score (Tentative Opportunity For Increment)

## Introduction
> **Tentative Opportunity For Increment** or TOFI is a metric that I have created that allows us to estimate the feasablity of buying a bond by not only taking into account its _rate of interest_, but also its probability of _changing bond ratings_ and probability of _defaulting_. This is achieved using *Markov Chains* and the formula of *theoretical estimation*.

## The Theory
When someone purchases a bond, they consider four factors:
- Annualized Rate of Interest.
- Duration of the bond.
- Bond Rating.
- Minimum price to purchase.

Implicitly, another factor is also considered when we look at Bond Rating which is _probability of defaulting_. Now, when a person buys the bond they are aware of these factors but can't quantify it. Also, when one purchases a bond, while they consider the probability of defaulting, they don't consider the probability of a bond rating changing. This is managed using TOFI.

TOFI takes a Markov Chain where each i<sup>th</sup> row and column represents an S&P bond rating. These are:
- AAA
- AA
- A
- BBB
- BB
- B
- C
- Default

AAA is the highest rated bond with the most security and least default rates. On the contrary, the C rated bonds have the lowest security with the highest default rates and highest rates of interest. Default implies the inability to pay the loan lended by the company. So each element in this matrix represents the probability of entering from i<sup>th</sup> row rating to the j<sup>th</sup> column rating. Each row adds up to 1.

Now, to calculate what the theoretical probability of these ratings changing in n years would like, your original matrix A becomes A<sup>n</sup>. With these theoretical probabilities, you can calculate the total _estimated value you will receive_ from the bond. Let's call this value **x**. Side by side, one can also calculate the bond value that they will get assuming the bond does not deviate its rating. Let's call this value **y**.

The TOFI Score of a particular bond = **x-y**. 

## Interpretation of TOFI Score
If TOFI Score:
- **> 0**, the theoretical gain is _greater than_ its presented rate of interest.
- **= 0**, the theoretical gain is _equal_ to its presented rate of interest.
- **< 0**, the theoretical gain is _lesser_ than its presented rate of interest.

Therefore, ideally the buyer would want a positive TOFI Score since it protects them from the offchance of their bond rating changing.

## Assumptions
- Transition of a bond rated x into a different rating y results in the interest rate of the bond changing to the interest rate of y for the whole period So, a BBB rated bond now and BBB rated bond n years later will have the same rate of interest
- The rates of interest are the average rates of interest of these specific ratings as taken from Google
- When a bond defaults, you bondholder gets 0 return, i.e, not even the principal amount is paid
- The Markov Chain is taken from the S&P Annual Report.
- Face value of each bond is $1000
- The rate of interest for the bonds will be calculated for the entire period (this is due to the inherent nature of Markov Chains)
- Bond ratings change interest rates
- The unrated bond interests are those of Adidas and their probabilities are guessed. This row and column could be removed if wished upon.

## Other features
- Calculate the **expected time for a bond rating to default**
- Calculate the **proportion of a particular rated bond in the market**
- Calculate the **fraction of bonds that default**
