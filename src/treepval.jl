"""
A partial order under ≤ in a tree structure.

When TreePVal needs to expand a leaf, it will call the `children` method (see below). This
means that we can "invalidate" certain histories: by ignoring certain branches of the tree,
we render them impossible.
"""
abstract type TreeOrder end

"""
    children(n::TreeOrder; target=nothing)

The list of children of `n` in the TreeOrder. Optionally, target can be used to create
a subtree of the entire TreeOrder.
"""
children(n::TreeOrder; target::TreeOrder) = children(n)
children(::TreeOrder) = error("not implemented")

"""
    TreePVal{T,D <: TreeOrder}

Persistent value for a tree-shaped history.

Values are only stored in leaves. Trying to access the value of a non-leaf node will throw
`_TimestampInvalid`. Trying to access a value that is outside of the tree (as defined by
the `children` function) will also throw `_TimestampInvalid`.

# Type parameters
- T: The stored value type.
- D: The timestamp type. Must be a tree-shaped partial order under <. The root must
    be accessible as zero(::D). `children(d::D)` should give the children of node `d` in the
    partial order.
"""
mutable struct TreePVal{T,D<:TreeOrder} <: AbstractPVal{T,D}
    val::T
    date::D
    children::Vector{TreePVal{T,D}}
    function TreePVal{T,D}(
        val::T, date::D, children::Vector{TreePVal{T,D}}
    ) where {T,D<:TreeOrder}
        return new{T,D}(val, date, children)
    end
end

"""
    TreePVal{T,D<:TreeOrder}(val::T, date::D=zero(D), children=[])

Construct a TreePVal.

# Arguments
- val: The value at timestamp `date`.
- date: The current timestamp. Defaults to zero, which should be the root of D.
"""
function TreePVal{T,D}(val::T, date::D=zero(D)) where {T,D}
    return TreePVal{T,D}(val, date, TreePVal{T,D}[])
end

function Base.get(v::TreePVal{T,D}, d::D) where {T,D}
    d ≤ v.date || throw(_TimestampInvalid(d))

    if isempty(v.children)
        return v.val
    end

    for c in v.children
        if d ≤ c.date
            return get(c, d)
        end
    end

    throw(_TimestampInvalid(d))
end

function set!(v::TreePVal{T,D}, newv::T, d::D) where {T,D}
    d ≤ v.date || throw(_TimestampInvalid(d))

    if isempty(v.children)
        if d == v.date
            v.val = newv
            return newv
        else
            # Expand node.
            new_nodes = children(v.date; target=d)
            append!(v.children, [TreePVal{T,D}(v.val, n) for n in new_nodes])
        end
    end

    for c in v.children
        if d ≤ c.date
            return set!(c, newv, d)
        end
    end

    throw(_TimestampInvalid(d))
end

"""
Error thrown when trying to access an inaccessible timestamp
"""
struct _TimestampInvalid{D} <: Exception
    date::D
end

function Base.showerror(io::IO, e::_TimestampInvalid)
    errmsg = "Cannot get/set timestamp $(e.date). Only leaves can have values."
    return print(io, errmsg)
end
