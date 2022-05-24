@testset "abstract.jl" begin
    struct A{T,D} <: AbstractPVal{T,D} end

    a = A{Int,Int}()
    @test_throws PersistentVals._NotDefinedPVal get(a, 3)
    @test_throws PersistentVals._NotDefinedPVal PersistentVals.set!(a, 3, 3)
end
