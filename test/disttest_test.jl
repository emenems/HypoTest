# testhist
function testhist_test()
	# see test/input/disttest_test.xls
	x = vcat(zeros(4),zeros(5).+1,zeros(10).+2,zeros(13).+3,
			 zeros(18).+4,zeros(16).+5,zeros(9).+6,zeros(9).+7,
			 zeros(4).+8,zeros(2).+10);
	d = Distributions.Normal(4.,2.5);
	out = testhist(x,d,0,alpha=0.05,bin_method=10);
	@test out.critical ≈ 14.06714 atol = 0.001
	@test out.estim ≈ 7.8890424 atol = 0.0001
	@test out.alpha == 0.05

	# same as above but without known dist. parameters ()
	d2 = Distributions.Normal(3.744444,2.200925);
	out2 = testhist(x,d2,2,alpha=0.01,bin_method=10);
	@test out2.critical ≈ 15.08627 atol = 0.001
	@test out2.estim ≈ 19.828286 atol = 0.0001
	@test out2.alpha == 0.01

	# "perfect" input data + high confidence
	d3 = Distributions.Binomial(1000,0.1)
	srand(123);
	x = rand(d3,1000)+0.0; # must be float
	out3 = testhist(x,d3,0,alpha=0.01,bin_method="Scott")
	@test out3.estim < out3.critical # do not reject the hypothesis
end

testhist_test();
