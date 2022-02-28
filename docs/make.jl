push!(LOAD_PATH, "../")

using Documenter, JavisViewer

makedocs(sitename = "JavisViewer.jl")

makedocs(;
    modules = [JavisViewer],
    authors = "Giovanni Puccetti <g.puccetti92@gmail.com>, Jacob Zelko <jacobszelko@gmail.com> and contributors",
    repo = "https://github.com/JuliaAnimators/JavisNB.jl/blob/{commit}{path}#L{line}",
    sitename = "JavisViewer.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://JuliaAnimators.github.io/JavisViewer.jl",
        assets = String[],
    ),
    pages = ["Home" => "index.md", "References" => "references.md"],
)

deploydocs(;
    repo = "github.com/JuliaAnimators/JavisViewer.jl",
    push_preview = true,
    devbranch = "main",
)
