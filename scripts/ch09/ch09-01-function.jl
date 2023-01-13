
using Random

f1(t) = false

f2(t) = t == false ? false : true

f3(t) = t == false ? true : false

f4(t) = true

const functions = [f1, f2, f3, f4]

function function_test()
    random = Xoshiro()
    for i = 1:10
        rnd = rand(random, 1:4)
        f = functions[rnd]
        y0 = f(false)
        y1 = f(true)
        println("f", rnd, " is a ", y0 == y1 ? "constant" : "balanced", " function")
    end
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    function_test()
end
