"""
	corrp(x,y)
Compute Pearson's correlation coefficient (`r`) and corresponding `p` value with
null hypothesis of no correlation (against alternative of a non-zero correlation).
`p` values (two-tailed) below 0.05 typically indicate that `r` is statistically
significant, see e.g., https://www.medcalc.org/manual/correlation.php

**Example**
```
x,y = collect(1.:1:10),collect(0.:10:90);
y[end] = 80;
r,p = corrp(x,y);
```
"""
function corrp(x::Vector{Float64},y::Vector{Float64})
	xi,yi = HypoTest.prepdata(x,y);
	n = length(xi);
	r = cor(xi,yi);
	t = HypoTest.tpearval(r,n);
	return r, HypoTest.pvalcorr(t,n)
end

# t-value for Pearson's correlation coefficient: https://www.danielsoper.com/statcalc/formulas.aspx?id=44
tpearval(r,n) = r/sqrt((1-r^2)/(n-2));

# two-tailed probability for correlation (=t-distribution)
pvalcorr(t,n) = 2*(1-Distributions.cdf(Distributions.TDist(n-2),t));
