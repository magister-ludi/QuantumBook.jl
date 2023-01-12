
using FileIO
using Random
using StrangelyDisplayed
using StrangelyQuantum

function superpos_example(key_length::Integer)
    random = Xoshiro()

    # Create a key containing random bits.
    aliceBits = [rand(random, Bool) for _ = 1:key_length]

    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(key_length)
    prepareStep = Step()
    superPositionStep = Step()
    superPositionStep2 = Step()
    measureStep = Step()
    for i = 1:key_length
        # Initialize the qubits according to the random bits.
        # A random bit of 0 will lead to a |0⟩ qubit;
        # a random bit of 1 will lead to a |1⟩ qubit.
        aliceBits[i] && addGate(prepareStep, X(i))
        # perform a Hadamard transformation to bring the
        # qubit into a superposition and send it over the network.
        addGate(superPositionStep, Hadamard(i))
        # Perform a second Hadamard transformation on the received qubit.
        addGate(superPositionStep2, Hadamard(i))
        # Measure the qubit.
        addGate(measureStep, Measurement(i))
    end

    addStep(program, prepareStep)
    addStep(program, superPositionStep)
    addStep(program, superPositionStep2)
    addStep(program, measureStep)

    result = runProgram(simulator, program)
    qubit = getQubits(result)

    measurement = Vector{Int}(undef, key_length)
    bobBits = Vector{Bool}(undef, key_length)
    for i = 1:key_length
        measurement[i] = measure(qubit[i])
        bobBits[i] = measurement[i] == 1
        println(
            "Alice sent ",
            aliceBits[i] ? '1' : '0',
            " and Bob received ",
            bobBits[i] ? '1' : '0',
        )
    end

    save("ch08-03-superposition.png", drawProgram(program))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    superpos_example(4)
end
