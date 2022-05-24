# Not a test file, just a useful datastructure

# n: width
# d: depth
struct TreeOrderTest <: TreeOrder
    contents::Set{Int}
    n::Int
    d::Int
end

function TreeOrderTest(s::Union{Nothing,String}=nothing; n=2, d=3)
    if isnothing(s)
        s = repeat("x", d)
    end

    length(s) == d || error("wrong string length")
    1 ≤ n ≤ 10 || error("n not in interval")

    cnts::Set{Int} = Set()
    offset = 0
    for c in s
        if c == 'x'
            for j in offset .+ (0:(n - 1))
                push!(cnts, j)
            end
        else
            parsed_c = parse(Int, c)
            0 ≤ parsed_c < n || error("cannot parse string")
            push!(cnts, offset + parsed_c)
        end
        offset += 10
    end

    return TreeOrderTest(cnts, n, d)
end

function Base.isless(t1::TreeOrderTest, t2::TreeOrderTest)
    return t1.contents ⊆ t2.contents
end

Base.zero(::Type{TreeOrderTest}) = TreeOrderTest()
function Base.:(==)(t1::TreeOrderTest, t2::TreeOrderTest)
    return t1.contents == t2.contents && t1.n == t2.n && t1.d == t2.d
end
function PersistentVals.children(t::TreeOrderTest; target)
    @assert target < t

    i = 0
    found = false
    while !found && i < t.d
        for j in 0:(t.n - 1)
            val = 10 * i + j
            if val in t.contents && val ∉ target.contents
                found = true
            end
        end
        i += !found
    end

    ret = []
    unchanged = Set([x for x in t.contents if x ÷ 10 != i])
    for j in 0:(t.n - 1)
        newel = copy(unchanged)
        push!(newel, i * 10 + j)
        push!(ret, TreeOrderTest(newel, t.n, t.d))
    end
    return ret
end

macro to_str(s::String)
    return TreeOrderTest(s)
end

@testset "TreeOrderTest" begin
    @test to"xxx" ≤ to"xxx"
    @test to"0xx" ≤ to"xxx"
    @test to"1xx" ≤ to"xxx"
    @test to"x0x" ≤ to"xxx"
    @test to"x11" ≤ to"xxx"

    @test to"01x" ≤ to"01x"
    @test to"010" ≤ to"01x"
    @test !(to"1xx" ≤ to"01x")
    @test !(to"x0x" ≤ to"01x")
    @test !(to"x11" ≤ to"01x")
end
