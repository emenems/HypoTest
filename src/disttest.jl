
"""
	testhist()
Testing distributions using χ^2
Null hypothesis: no significant difference between sample and parent populaiton
Test is based on a comparison of expected and observed occurrances (histograms)
Following steps are carried out (see Measurements and their Uncertainty by I.G. Hughes & T.P.A. Hase):
	1. create histogram using observations (`x`): O
	2. create histogram using given distributions (`d`): E
	 	* use the same bins as in 1 and distribuiton CDF * number of observations
	3. combine bins with occurance E < 5 (to avoid chi^2 to be skewed by the asymetry of Poisson)
	4. compute χ^2 = sum((O-E)^2/E)
	5. return statistics
		* good fit: χ^2 ≈ 1 and P(χ^2;v) ≈ 0.5
		* poor fit χ^2 << 1 || χ^2 > 3 and P(χ^2;v) → 1 || P(χ^2;v) < 1e-4

**Input**
* `x`: observations
* `distin`: input distribution to be tested agains `x`
* `unkpar`: number of unknown parameters used to define `dising` (e.g. =2 if only estimated mean and deviation define the normal distribution). Will be used to compute degree of freedom
* `bin_method`: see `histbins`
* `alpha`: significance level, a probability threshold below which the null hypothesis will be rejected

**Output**
* test summary as TestResult

**Example**
```
# generate sample
d = Distributions.Binomial(100,0.1)
x = rand(d,100)+0.0; # must be float
# compute test
out = testhist(x,d,0,alpha=0.001,bin_method="Scott")
out.estim < out.critical

```
"""
function testhist(x::Vector{Float64},distin,unkpar::Int;
				bin_method="Scott",alpha::Float64=0.05)::TestResult
	xuse = HypoTest.prepdata(x);
	n = length(xuse);
	b = HypoTest.histbins(xuse,method=bin_method);
	# initial E (will be modified to E>5)
	E = HypoTest.theobins(distin,b,n);
	r = find(x->x.<5.,E);
	i = 1; # count iteration to avoid infinite loop
	while !isempty(r)
		r[1]+1 < length(b) ? deleteat!(b,r[1]+1) : nothing
		r[1]+1 == length(b) ? deleteat!(b,length(b)-1) : nothing
		E = HypoTest.theobins(distin,b,n);
		r = find(x->x.<5.,E)
		i += 1;
		i > n ? break : nothing
	end
	# Compute observed occurrances using updated bins
	O = HypoTest.countbins(xuse,b);
	# compute χ^2
	chi2 = HypoTest.pearsonschi2(E,O);
	# compare with tabled critical value
	v = (length(b)-1) - unkpar - 1; # degree of  freedom (length(b)-1 == number of bins)
	chi2crit = HypoTest.chi2critical(v,alpha);
	return TestResult("data sampled from given distribution",
					 "",chi2,chi2crit,alpha);
end

"""
	pearsonchi2(E,O)
Calculating the test-statistic using `E` expected and `O` observed values
"""
pearsonschi2(E::Vector{<:Real},O::Vector{<:Real})::Float64 = sum(((O.-E).^2)./E)

"""
	chi2critical(v,alpha)
Compute chritical chi^2 value using `v` degree of freedom and `alpha` significace level
"""
function chi2critical(v::Int,alpha::Float64)::Float64
	c = Distributions.Chisq(v);
	return Distributions.quantile(c,1-alpha);
end
