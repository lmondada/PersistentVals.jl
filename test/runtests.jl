using PersistentVals
using Test

@testset "PersistentVals.jl" begin
    include("treeordertest.jl")

    # Write your tests here.
    include("abstract.jl")
    include("treepval.jl")
end
