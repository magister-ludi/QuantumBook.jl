
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function simple_example()
    dim = 4
    program = Program(dim)
    step0 = Step(Hadamard(1), X(4))
    step1 = Step(Cnot(1, 2))

    addSteps(program, step0, step1)

    qee = SimpleQuantumExecutionEnvironment()
    result = runProgram(qee, program)
    qubits = getQubits(result)
    for i in eachindex(qubits)
        println("Qubit[", i, "]: ", measure(qubits[i]))
    end
    save("ch07-01-example.png", drawProgram(program))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    simple_example()
end
