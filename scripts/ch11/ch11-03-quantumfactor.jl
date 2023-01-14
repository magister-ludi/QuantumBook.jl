
using StrangelyQuantum

function test_quantum_factor()
    target = 15
    f = Classic.qfactor(target)
    println("Factored ", target, " in ", f, " and ", target ÷ f)
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    test_quantum_factor()
end
