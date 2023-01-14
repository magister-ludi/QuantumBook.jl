
using Random

function classic_factor()
    target = rand(0:9999)
    f = factor(target)
    println("Factored ", target, " in ", f, " and ", target ÷ f)
end

function factor(n::Integer)
    i = 1
    maxtest = isqrt(n)
    while i < maxtest
        i += 1
        n % i == 0 && return i
    end
    return n
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    classic_factor()
end
