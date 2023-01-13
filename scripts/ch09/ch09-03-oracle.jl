
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function oracle_example1()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(2)
    step1 = Step()
    # Apply a Hadamard gate to the second qubit.
    addGate(step1, Hadamard(2))
    # Create a matrix containing complex numbers.
    matrix = ComplexF64[
        1 0 0 0
        0 1 0 0
        0 0 0 1
        0 0 1 0
    ]
    # Create an oracle based on the matrix
    oracle = Oracle(matrix)

    # Create a second step in which the oracle is applied
    step2 = Step()
    addGate(step2, oracle)

    addStep(program, step1)
    addStep(program, step2)

    save("ch09-03-oracle-1.png", drawProgram(program))
    save("ch09-03-oracle-2.png", drawTrialHistogram(program, 1000))

end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    oracle_example1()
end
