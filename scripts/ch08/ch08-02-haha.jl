
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function haha()
    program = Program(2)
    step0 = Step()
    # Use an X gate to put the first qubit in state 1,
    # leave the second in state 0
    addGate(step0, X(1))

    step1 = Step()
    addGate(step1, Hadamard(1))
    addGate(step1, Hadamard(2))

    step2 = Step()
    # Apply Hadamard gates to both qubits
    addGate(step2, Hadamard(1))
    addGate(step2, Hadamard(2))

    addStep(program, step0)
    # Apply Hadamard gates to both qubits a second time
    addStep(program, step1)
    addStep(program, step2)

    save("ch08-02-haha.png", drawProgram(program))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    haha()
end
