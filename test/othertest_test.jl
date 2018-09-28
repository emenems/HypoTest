function corrp_test()
	x = [1.,2,3,5,10,22,0,1,-3,4,0,8,10,3,4,5,5,5,-10,0];
	y = [2.,3,4,5,7,10,10,11,-3,4,1,-1,0,1,2,3,4,4,4,-5];
	r1,p1 = corrp(x,y);
	# compare to Matlab results ([r,p] = corr(x',y'))
	@test r1 ≈ 0.2923 atol = .0001
	@test p1 ≈ 0.2111 atol = .0001

	x[2] = NaN;
	y[[2,4]] .= NaN;
	r2,p2 = corrp(x,y);
	@test r2 ≈ 0.2892 atol = .0001
	@test p2 ≈ 0.2444 atol = .0001
end

corrp_test();
