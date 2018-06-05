using Documenter, NameToGender

makedocs(;
    modules=[NameToGender],
    format=:html,
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/JuliaText/NameToGender.jl/blob/{commit}{path}#L{line}",
    sitename="NameToGender.jl",
    authors="Lyndon White (aka oxinabox)",
    assets=[],
)

deploydocs(;
    repo="github.com/JuliaText/NameToGender.jl",
    target="build",
    julia="0.6",
    deps=nothing,
    make=nothing,
)
