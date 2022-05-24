@testset "abstract.jl" begin
    struct A{T,D} <: AbstractPVal{T,D} end

    a = A{Int,Int}()
    @test_throws PersistentVals._NotDefinedPVal get(a, 3)
    @test_throws PersistentVals._NotDefinedPVal PersistentVals.set!(a, 3, 3)

    @testset "_NotDefinedPVal" begin
        struct DummyPVal{T,D} <: AbstractPVal{T,D} end
        dpv = DummyPVal{Int,Int}()
        @test_throws PersistentVals._NotDefinedPVal get(dpv, 3)
        @test_throws PersistentVals._NotDefinedPVal set!(dpv, 3, 3)

        try
            get(dpv, 3)
        catch e
            @test e isa PersistentVals._NotDefinedPVal
            buf = IOBuffer()
            showerror(buf, e)
            message = String(take!(buf))
            errmsg = "Interface function get is not defined for $(typeof(dpv))"
            @test message == errmsg
        end
    end
end
