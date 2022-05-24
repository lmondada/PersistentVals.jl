"""
Abstract type for a persistent value.

A persistent value can be set at a timestamp::D and recovered later using
that timestamp. Updates at different timestamps may or may not change the result
at other (eg future) timestamps.

# Interface
- Base.get(v::AbstractVal{T,D}, d::D): value at timestanp `d`.
- set!(v::AbstractVal{T,D}, newv::T, d::D): set value to `newv` at timestamp `d`.
"""
abstract type AbstractPVal{T,D} end

struct _NotDefinedPVal <: Exception
    funcname::String
    vartype::DataType
end

function Base.showerror(io::IO, e::_NotDefinedPVal)
    errmsg = "Interface function $(e.funcname) is not defined for $(e.vartype)"
    return print(io, errmsg)
end

"""
    get(v::AbstractPVal{T,D}, d::D)

Get value of persistent data `v` at time `d`.
"""
Base.get(v::AbstractPVal{T,D}, ::D) where {T,D} = throw(_NotDefinedPVal("get", typeof(v)))

"""
    set!(v::AbstractPVal{T,D}, newv::T, d::D)

Set value `v` to `newv` at time `d`.
"""
set!(v::AbstractPVal{T,D}, ::T, ::D) where {T,D} = throw(_NotDefinedPVal("set!", typeof(v)))
