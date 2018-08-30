# Run the test from HypoTest folder
using HypoTest
using Base.Test

# List of test files:
tests = ["momentestim_test.jl"]

# Run all tests in the list
for i in tests
	include(i)
end
println("Test End!")
