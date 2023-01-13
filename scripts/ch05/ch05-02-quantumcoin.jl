
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function quantum_coin()
    # `results` collects the occurrences for the different
    # possible outcomes.
    results = zeros(Int, 4)
    count = 1000
    # Create a quantumExecutionEnvironment, and construct
    # the program
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(2)
    step1 = Step()
    addGate(step1, Hadamard(1))
    addGate(step1, Hadamard(2))
    addStep(program, step1)
    # Execute the program 1,000 times, and measure the results
    for _ = 1:count
        result = runProgram(simulator, program)
        qubits = getQubits(result)
        q1 = qubits[1]
        q2 = qubits[2]
        coinA = measure(q1) == 1
        coinB = measure(q2) == 1
        # Depending on the outcome, increment one of the counters
        !coinA && !coinB && (results[1] += 1)
        !coinA && coinB && (results[2] += 1)
        coinA && !coinB && (results[3] += 1)
        coinA && coinB && (results[4] += 1)
    end
    println("=======================================")
    println("We did ", count, " experiments.")
    println("[AB]: 0 0 occurred ", results[1], " times.")
    println("[AB]: 0 1 occurred ", results[2], " times.")
    println("[AB]: 1 0 occurred ", results[3], " times.")
    println("[AB]: 1 1 occurred ", results[4], " times.")
    println("=======================================")

    # Save images of the circuit and of a histogram
    # constructed from the circuit
    save("ch05-02-quantumcoin-1.png", drawProgram(program))
    save("ch05-02-quantumcoin-2.png", drawTrialHistogram(program, 1000))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    quantum_coin()
end
