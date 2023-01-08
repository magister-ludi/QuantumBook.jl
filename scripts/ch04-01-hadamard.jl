
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function singleHadamardExecution()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(1)
    # Ready to add gates.
    step = Step()
    # Add a Hadamard gate
    addGate(step, Hadamard(1))
    addStep(program, step)
    # Excecute Program
    result = runProgram(simulator, program)
    qubits = getQubits(result)
    q1 = qubits[1]
    # Measure the qubit. It will have a value of 0 or 1.
    value = measure(q1)
    println("Value = ", value)
    save("ch04-01-hadamard.png", drawProgram(program))
end

function manyHadamardExecution()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(1)
    step = Step()
    addGate(step, Hadamard(1))
    addStep(program, step)
    cntZero = 0
    cntOne = 0
    # Run the circuit 1000 times
    for _ = 1:1000
        result = runProgram(simulator, program)
        qubits = getQubits(result)
        q1 = qubits[1]
        # Measure
        value = measure(q1)
        # Add to tallies
        value == 0 && (cntZero += 1)
        value == 1 && (cntOne += 1)
    end
    println("Applied Hadamard circuit 1000 times, got ", cntZero, " zeros and ", cntOne, " ones.")
end

function hadamard_example1()
    println("==================================================")
    println("Single run of a Quantum Circuit with Hadamard Gate")
    singleHadamardExecution()
    println("==================================================")
    println("\n\n")
    println("==================================================")
    println("1000 runs of a Quantum Circuit with Hadamard Gate")
    manyHadamardExecution()
    println("==================================================")
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    hadamard_example1()
end
