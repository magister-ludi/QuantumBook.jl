
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function paulix_img()
    # Construct simulation environment
    simulator = SimpleQuantumExecutionEnvironment()
    # Construct a Program operating on one qubit
    program = Program(1)
    # Construct and add a step with a Pauli-X gate
    step = Step()
    addGate(step, X(1))
    addStep(program, step)
    # Execute the Program
    result = runProgram(simulator, program)
    # Examine and show the output
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
