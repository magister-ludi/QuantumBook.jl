
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function debug_example()
    dim = 4
    program = Program(dim)
    p0 = Step(ProbabilitiesGate(1))
    step0 = Step(Hadamard(1), X(4))
    p1 = Step(ProbabilitiesGate(1))
    step1 = Step(Cnot(1, 2))
    p2 = Step(ProbabilitiesGate(1))

    addSteps(program, p0, step0, p1, step1, p2)

    qee = SimpleQuantumExecutionEnvironment()
    result = runProgram(qee, program)
    qubits = getQubits(result)
    for i in eachindex(qubits)
        println("Qubit[", i, "]: ", measure(qubits[i]))
    end
    save("ch07-02-debugexample.png", drawProgram(program))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    debug_example()
end
