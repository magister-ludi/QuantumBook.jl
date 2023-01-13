
using FileIO
using Random
using StrangelyDisplayed
using StrangelyQuantum

function qteleport()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(3)
    # randomly choose whether to set the first bit to 1
    r = rand(Bool)
    # if r is true, set the first bit to 1
    if r
        step0 = Step()
        addGate(step0, X(1))
        addStep(program, step0)
    end
    step1 = Step()
    addGate(step1, Hadamard(2))
    step2 = Step()
    addGate(step2, Cnot(2, 3))
    step3 = Step()
    addGate(step3, Cnot(1, 2))
    step4 = Step()
    addGate(step4, Hadamard(1))
    step5 = Step()
    addGate(step5, Measurement(1))
    addGate(step5, Measurement(2))
    # If qubit q[2] is measured as 1, apply a Pauli-X gate to q[3]
    step6 = Step()
    addGate(step6, Cnot(2, 3))
    # If qubit q[1] is measured as 1, apply a Pauli-X gate to q[3]
    step7 = Step()
    addGate(step7, Cz(1, 3))
    addStep(program, step1)
    addStep(program, step2)
    addStep(program, step3)
    addStep(program, step4)
    addStep(program, step5)
    addStep(program, step6)
    addStep(program, step7)

    result = runProgram(simulator, program)
    qubits = getQubits(result)
    q3 = qubits[3]
    v3 = measure(q3)
    println("sent: ", Int(r), ", received: ", v3)
    save("ch06-03-teleport-1.png", drawProgram(program))
    save("ch06-03-teleport-2.png", drawTrialHistogram(program, 1000))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    qteleport()
end
