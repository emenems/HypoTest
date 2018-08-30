
"""
	meanconfid(x;sigma)
Compute the mean with confidence interval assuming normal
distribution (or large sample size => central limit theorem)

**Input**
* x: vector of samples (NaNs will be removed)
* sigma: optional input in case sigma (standard deviation, not variance) is known
* alpha: (1-alpha) gives the conficende interval for x_mean

**Output**
* x_mean: estimated mean
* x_confid: tuple with (lower,upper) confidence bounds defined by alpha

**Example**
```
# known standard deviation
x = [2.,3.,5.,6.,9.]
x_mean,x_confid = meanconfid(x,sigma=2.5)

# including NaN and Unknown sigma
push!(x,NaN);
x_mean,x_confid = meanconfid(x)
```
"""
function meanconfid(x::Vector{Float64};alpha::Float64=0.05,sigma::Float64=NaN)
	x_use = HypoTest.prepdata(x);
	x_mean = Distributions.mean(x_use);
	s = isnan(sigma) ? Distributions.std(x_use) : sigma;
	if isnan(sigma) && length(x_use) < 100
		d = Distributions.TDist(length(x_use)-1);
	else
		d =  Distributions.Normal();
	end
	q = Distributions.quantile(d,1-alpha/2);
	return x_mean,(x_mean-q*s/sqrt(length(x_use)),x_mean+q*s/sqrt(length(x_use)))
end

"""
	stdconfid(x;x_mean)
Compute the standard deviation with confidence interval assuming normal
distribution

**Input**
* x: vector of samples (NaNs will be removed)
* x_mean: optional input in case true mean is known (=>n instead n-1)
* alpha: (1-alpha) gives the conficende interval for sigma

**Output**
* sigma: estimated standard deviation (not variance)
* x_confid: tuple with (lower,upper) confidence bounds defined by alpha

**Example**
```
x = [1.95,1.96,1.98,1.99,2.00,2.00,2.01,2.01,2.01,2.01,
	2.02,2.02,2.03,2.03,2.04,2.04,2.05,2.06,2.08,2.10];
# unknown mean value
s,s_interval = stdconfid(x,alpha=0.05)

# known mean
x = [19.01,19.02,18.99,19.00,19.05,19.05,19.0,18.98,18.99,19.0];
s,s_interval = stdconfid(x,alpha=0.05,x_mean=19.)
```
"""
function stdconfid(x::Vector{Float64};alpha::Float64=0.05,x_mean::Float64=NaN)
	x_use = HypoTest.prepdata(x);
	sigma = Distributions.std(x_use, mean = isnan(x_mean) ? nothing : x_mean,
								corrected = isnan(x_mean) ? true : false);
	k = isnan(x_mean) ? length(x_use)-1 : length(x_use);
	d = Distributions.Chisq(k);
	qlow,qhigh = Distributions.quantile(d,1-alpha/2),Distributions.quantile(d,alpha/2);
	return sigma,(sqrt(k*sigma^2/qlow), sqrt(k*sigma^2./qhigh))
end
