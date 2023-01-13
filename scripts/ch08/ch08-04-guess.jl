
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function guess(key_length::Integer)
    aliceBits = falses(key_length)

    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(key_length)
    prepareStep = Step()
    superPositionStep = Step()
    superPositionStep2 = Step()
    measureStep = Step()
    for i = 1:key_length
        i > (key_length ÷ 2) && addGate(prepareStep, X(i))
        ((i - 1) ÷ 2) % 2 == 1 && addGate(superPositionStep, Hadamard(i))
        (i - 1) % 2 == 1 && addGate(superPositionStep2, Hadamard(i))
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

    save("ch08-04-guess.png", drawProgram(program))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    guess(8)
end
