using PersistentVals
using Documenter

DocMeta.setdocmeta!(PersistentVals, :DocTestSetup, :(using PersistentVals); recursive=true)

makedocs(;
    modules=[PersistentVals],
    authors="Luca Mondada <luca@mondada.net>",
    repo="https://github.com/lmondada/PersistentVals.jl/blob/{commit}{path}#{line}",
    sitename="PersistentVals.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://lmondada.github.io/PersistentVals.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/lmondada/PersistentVals.jl",
    devbranch="main",
)
