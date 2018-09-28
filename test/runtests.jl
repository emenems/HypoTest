# Run the test from HypoTest folder
using HypoTest
using Test
import Distributions
import Random

# List of test files:
tests = ["momentestim_test.jl",
		 "histdata_test.jl",
		 "disttest_test.jl",
		 "othertest_test.jl"]

# Run all tests in the list
for i in tests
	include(i)
end
println("Test End!")
