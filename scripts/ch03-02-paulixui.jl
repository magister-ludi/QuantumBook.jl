
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function paulix_img()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(1)
    step = Step()
    addGate(step, X(1))
    addStep(program, step)
    result = runProgram(simulator, program)
    qubits = getQubits(result)
    qubit_1 = qubits[1]
    value = measure(qubit_1)
    println("Value = ", value)
    img = drawProgram(program)
    save("ch03-02-paulixui.png", img)
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    paulix_img()
end
