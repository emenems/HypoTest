# theobins
function theobins_test()
	d = Distributions.Normal()
	b = collect(-3.:1:3);
	n = 100;
	bc = HypoTest.theobins(d,b,n);
	@test trunc.(Int,round.(bc)) == [2,14,34,34,14,2];
	q = [Distributions.quantile(d,0.99),Distributions.quantile(d,0.99999)]
	@test HypoTest.theobins(d,q,n) ≈ [0.999] atol = 0.001
end

# countbins
function countbins_test()
	x = collect(1.:1.:10);
	bc = HypoTest.countbins(x,[0.,1.,9.,10.]);
	@test bc == [0,8,2]; # see PyPlot.plt[:hist](x,[0.,1.,9.,10.])
	@test HypoTest.countbins(x,[1.,1.,9.]) == [0,9];
	@test HypoTest.countbins([-1.001,0.,0.999],[-2.,-1.,0.,1]) == [1,0,2]
end

# histbins
function histbins_test()
	hb = HypoTest.histbins([0.,1.],method=10)
	@test hb == collect(0:0.1:1.)
	hb = HypoTest.histbins([-1.,0.,1.,2.],method="square")
	@test hb == collect(-1:1.5:2)
end

# prepdata
function prepdata_test()
	@test [1,2,3.] == HypoTest.prepdata([1.,2.,3.])
	@test [-1.,0.99] == HypoTest.prepdata([NaN,-1.,NaN,0.99,NaN])
	# two vectors
	x,y = HypoTest.prepdata([1.,2,NaN],[2.,NaN,9]);
	@test x == [1.]
	@test y == [2.];
	x,y = HypoTest.prepdata([1.,2.,3.],[2.,3.,4.]);
	@test x == [1.,2.,3.];
	@test y == [2.,3.,4.];
end

# Run functions
theobins_test();
countbins_test();
histbins_test();
prepdata_test();
