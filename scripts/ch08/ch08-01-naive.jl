
using FileIO
using Random
using StrangelyDisplayed
using StrangelyQuantum

function naive_transmission()
    key_size = 4
    random = Xoshiro()

    aliceBits = [rand(random, Bool) for _ = 1:key_size]

    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(key_size)
    step1 = Step()
    step2 = Step()
    for i = 1:key_size
        aliceBits[i] && addGate(step1, X(i))
        addGate(step2, Measurement(i))
    end

    addStep(program, step1)
    addStep(program, step2)

    result = runProgram(simulator, program)
    qubit = getQubits(result)

    measurement = Vector{Int}(undef, key_size)
    bobBits = Vector{Bool}(undef, key_size)
    for i = 1:key_size
        measurement[i] = measure(qubit[i])
        bobBits[i] = measurement[i] == 1
        println(
            "Alice sent ",
            aliceBits[i] ? '1' : '0',
            " and Bob received ",
            bobBits[i] ? '1' : '0',
        )
    end
    save("ch08-01-naive.png", drawProgram(program))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    naive_transmission()
end
