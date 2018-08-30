# meanconfid
function meanconfid_test()
	x = [2.,3.,5.,6.,9.]
	x_mean,x_confid = meanconfid(x,sigma=2.5,alpha=.05)
	@test x_mean ≈ 5.0
	@test x_confid[1] ≈ 2.81 atol=0.02
	@test x_confid[2] ≈ 7.19 atol=0.02

	# Unknown sigma
	x_mean,x_confid = meanconfid(x)
	@test x_mean ≈ 5.0
	@test x_confid[1] ≈ 1.60 atol=0.02
	@test x_confid[2] ≈ 8.4 atol=0.02

	# with NaN
	push!(x,NaN);
	x_mean,x_confid = meanconfid(x)
	@test x_mean ≈ 5.0
	@test x_confid[1] ≈ 1.60 atol=0.02
	@test x_confid[2] ≈ 8.4 atol=0.02
end

# meanconfid
function stdconfid_test()
	x = [1.95,1.96,1.98,1.99,2.00,2.00,2.01,2.01,2.01,2.01,
		2.02,2.02,2.03,2.03,2.04,2.04,2.05,2.06,2.08,2.10];
	# unknown mean value
	s,s_interval = stdconfid(x,alpha=0.05)
	@test s^2 ≈ 0.001352 atol = 0.00001
	@test s_interval[1] ≈ 0.027964 atol = 0.00001
	@test s_interval[2] ≈ 0.053710 atol = 0.00001

	# known mean
	x = [19.01,19.02,18.99,19.00,19.05,19.05,19.0,18.98,18.99,19.0];
	s,s_interval = stdconfid(x,alpha=0.05,x_mean=19.)
	@test s^2 ≈ 0.00061 atol = 0.000001
end

# Run
meanconfid_test()
stdconfid_test()
