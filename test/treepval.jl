@testset "treepval.jl" begin
    @testset "linear order" begin
        # UInt with ≤ reversed
        struct Linear <: TreeOrder
            val::UInt
        end
        Base.isless(v1::Linear, v2::Linear) = isless(v2.val, v1.val)
        Base.zero(::Type{Linear}) = Linear(0)
        PersistentVals.children(l::Linear) = [Linear(l.val + 1)]

        lintree = TreePVal{Int,Linear}(0)
        @test get(lintree, Linear(0)) == 0
        @test get(lintree, Linear(2)) == 0

        set!(lintree, 6, Linear(0))
        @test get(lintree, Linear(0)) == 6

        set!(lintree, 3, Linear(1))
        @test_throws PersistentVals._TimestampInvalid set!(lintree, 2, Linear(0))
        @test_throws PersistentVals._TimestampInvalid get(lintree, Linear(0))
        @test get(lintree, Linear(2)) == 3
    end

    @testset "partial order" begin
        tree = TreePVal{Int,TreeOrderTest}(0)
        @test get(tree, to"xxx") == 0
        @test get(tree, to"0xx") == 0
        @test get(tree, to"x0x") == 0
        @test get(tree, to"xx0") == 0

        #        1xx (0)
        #  xxx <       00x (6)
        #        0xx <
        #              01x (0)
        set!(tree, 6, to"00x")
        @test get(tree, to"000") == 6
        @test get(tree, to"00x") == 6
        @test get(tree, to"00x") == 6
        @test get(tree, to"01x") == 0
        @test get(tree, to"1xx") == 0
        @test get(tree, to"1x1") == 0

        @test_throws PersistentVals._TimestampInvalid get(tree, to"0xx")
        @test_throws PersistentVals._TimestampInvalid get(tree, to"xxx")
        @test_throws PersistentVals._TimestampInvalid get(tree, to"x1x")

        #        1xx < ... 111(3)
        #  xxx <       00x (6)
        #        0xx <
        #              01x (0)
        set!(tree, 3, to"111")
        @test get(tree, to"111") == 3
        @test get(tree, to"110") == 0
        @test get(tree, to"10x") == 0
        @test_throws PersistentVals._TimestampInvalid get(tree, to"11x")
        @test get(tree, to"000") == 6
        @test get(tree, to"00x") == 6
        @test get(tree, to"00x") == 6
        @test get(tree, to"01x") == 0
    end
end
