
using StrangelyQuantum

function paulix_demo()
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
    q1 = qubits[1]
    value = measure(q1)
    println("Value = ", value)
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    paulix_demo()
end
