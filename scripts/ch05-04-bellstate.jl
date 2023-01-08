
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function entanglement()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(2)
    step1 = Step()
    addGate(step1, Hadamard(1))
    addStep(program, step1)
    step2 = Step()
    addGate(step2, Cnot(1, 2))
    addStep(program, step2)
    result = runProgram(simulator, program)
    qubits = getQubits(result)
    q1 = qubits[1]
    q2 = qubits[2]
    v1 = measure(q1)
    v2 = measure(q2)
    save("ch05-04-bellstate-1.png", drawProgram(program))
    save("ch05-04-bellstate-2.png", drawTrialHistogram(program, 1000))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    entanglement()
end
