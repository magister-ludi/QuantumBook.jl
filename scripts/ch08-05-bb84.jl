
using FileIO
using Random
using StrangelyDisplayed
using StrangelyQuantum

function bb84()
    # Alice and Bob will exchange SIZE qubits, hence the resulting
    # key will be maximum SIZE bits.
    SIZE = 8
    random = Xoshiro()

    aliceBits = Vector{Bool}(undef, SIZE)  # random bits chosen by Alice
    bobBits = Vector{Bool}(undef, SIZE)  # bits measured by Bob
    aliceBase = Vector{Bool}(undef, SIZE) # random bases chosen by Alice
    bobBase = Vector{Bool}(undef, SIZE) # random bases chosen by Bob

    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(SIZE)
    prepareStep = Step()
    superPositionStep = Step()
    superPositionStep2 = Step()
    measureStep = Step()

    for i = 1:SIZE
        aliceBits[i] = rand(Bool, random)
        # if Alice's bit is 1, apply a X gate to the |0> state
        aliceBits[i] && addGate(prepareStep, X(i))
        aliceBase[i] = rand(Bool, random)
        # if Alice's base for this bit is 1, apply a H gate
        aliceBase[i] && addGate(superPositionStep, Hadamard(i))
        bobBase[i] = rand(Bool, random)
        # if Bob decides to measure in base 1, apply a H gate
        bobBase[i] && addGate(superPositionStep2, Hadamard(i))
        # Finally, Bob measures the result
        addGate(measureStep, Measurement(i))
    end

    addStep(program, prepareStep)
    addStep(program, superPositionStep)
    addStep(program, superPositionStep2)
    addStep(program, measureStep)

    result = runProgram(simulator, program)
    qubit = getQubits(result)

    measurement = Vector{Int}(undef, SIZE)
    key = IOBuffer()
    for i = 1:SIZE
        measurement[i] = measure(qubit[i])
        bobBits[i] = measurement[i] == 1
        if aliceBase[i] != bobBase[i]
            # If the random bases chosen by Alice and Bob for this bit
            # are different, ignore values
            println("Different bases used, ignore values ", aliceBits[i], " and ", bobBits[i])
        else
            # Alice and Bob picked the same bases. The inital value from
            # Alice matches the measurement from Bob.
            # this bit now becomes part of the secret key
            println(
                "Same bases used. Alice sent ",
                aliceBits[i] ? '1' : '0',
                " and Bob received ",
                bobBits[i] ? '1' : '0',
            )
            print(key, aliceBits[i] ? "1" : "0")
        end
    end
    println("Secret key = ", String(take!(key)))

    save("ch08-05-bb84", drawProgram(program))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    bb84()
end
