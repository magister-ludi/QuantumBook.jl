
using Pkg

Pkg.activate(@__DIR__)
Pkg.add([PackageSpec(url="https://github.com/magister-ludi/StrangelyDisplayed.jl.git"),
         PackageSpec(url="https://github.com/magister-ludi/StrangelyQuantum.jl.git")])
