
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function reversible_x()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(1)
    step0 = Step()
    # Apply a Pauli-X gate to the qubit.
    addGate(step0, X(1))

    step1 = Step()
    # Apply a second Pauli-X gate to the qubit.
    addGate(step1, X(1))
    addStep(program, step0)
    addStep(program, step1)
    # Initialise the single qubit with an alpha value of 0.5,
    # which leads to a probability of 25% of measuring 0
    initializeQubit(program, 1, 0.5)

    save("ch09-02-reversiblex-1.png", drawProgram(program))
    save("ch09-02-reversiblex-2.png", drawTrialHistogram(program, 1000))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    reversible_x()
end
