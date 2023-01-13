
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function cnot_demo(qubit1, qubit2)
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(2)
    step1 = Step()
    # Apply a Pauli-X gate to a qubit if its
    # initial state should be 1
    qubit1 && addGate(step1, X(1))
    qubit2 && addGate(step1, X(2))
    addStep(program, step1)
    step2 = Step()
    # Add a CNot gate to the second step in the program. Because the
    # CNot gate operates on two qubits, we need to specify which ones. So,
    # the CNot constructor takes two arguments: the control qubit (in
    # this case, the first one) and the target qubit (the second one).
    addGate(step2, Cnot(1, 2))
    addStep(program, step2)
    result = runProgram(simulator, program)
    qubits = getQubits(result)
    q1 = qubits[1]
    q2 = qubits[2]
    v1 = measure(q1)
    v2 = measure(q2)
    println("IN = |11>\tOUT= |", v2, "", v1, ">")

    # Save images of the circuit and a sampling histogram
    save(string("ch05-03-cnot-", Int(qubit1), Int(qubit2), "a.png"), drawProgram(program))
    save(
        string("ch05-03-cnot-", Int(qubit1), Int(qubit2), "b.png"),
        drawTrialHistogram(program, 1000),
    )
end

function cnot_example()
    cnot_demo(false, false)
    cnot_demo(false, true)
    cnot_demo(true, false)
    cnot_demo(true, true)
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    cnot_example()
end
