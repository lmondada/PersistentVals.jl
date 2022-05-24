# PersistentVals

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://lmondada.github.io/PersistentVals.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://lmondada.github.io/PersistentVals.jl/dev)
[![Build Status](https://github.com/lmondada/PersistentVals.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/lmondada/PersistentVals.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/lmondada/PersistentVals.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/lmondada/PersistentVals.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

This package offers persistent values -- essentially mutable variables, but with access to
their historical values throughout time.
The interface is given by `AbstractPVal`:

- `Base.get(v::AbstractPVal{T,D}, d::D)`: get the value of `v` at time `d`.
- `set!(v::AbstractPVal{T,D}, t::T, d::D)`: set the value of `v` to `newv` at time `d`.

Whether one can change values in the past (ie is fully persistent),
and the semantics of that on future versions of the variable is left to the implementation.

## `TreePVal`
Currently, the only implementation of `AbstractPVal` is `TreePVal`. It allows for tree-shaped histories, ie multiple versions of history in parallel. It does not allow
for modifications of the past, but the presents can always be split further.

The timestamps must be `<:TreeOrder` and it must be a partial order under "<=".
`Base.zero` must further be the root of the tree and `children(::TreeOrder)` can be
used to limit the children considered when the history tree is expanded.

A good example of such a `TreeOrder` can be found in the `test/treeordertest.jl` file.