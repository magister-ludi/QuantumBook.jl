
using FileIO
using Random
using StrangelyDisplayed
using StrangelyQuantum

function deutsch()
    simulator = SimpleQuantumExecutionEnvironment()
    random = Xoshiro()
    program = nothing
    for i = 1:10
        program = Program(2)
        step0 = Step()
        addGate(step0, X(2))

        step1 = Step()
        addGate(step1, Hadamard(1))
        addGate(step1, Hadamard(2))

        step2 = Step()
        choice = rand(random, 1:4)

        oracle = createOracle(choice)
        addGate(step2, oracle)

        step3 = Step()
        addGate(step3, Hadamard(1))

        addStep(program, step0)
        addStep(program, step1)
        addStep(program, step2)
        addStep(program, step3)
        result = runProgram(simulator, program)
        qubits = getQubits(result)
        println("f = ", choice, ", val = ", measure(qubits[1]))
    end
    save("ch09-05-deutsch.png", drawProgram(program))
end

function createOracle(f)
    matrix = zeros(ComplexF64, 4, 4)

    if f == 1
        matrix[1, 1] = 1
        matrix[2, 2] = 1
        matrix[3, 3] = 1
        matrix[4, 4] = 1
        return Oracle(matrix)
    elseif f == 2
        matrix[1, 1] = 1
        matrix[2, 4] = 1
        matrix[3, 2] = 1
        matrix[4, 3] = 1
        return Oracle(matrix)
    elseif f == 3
        matrix[1, 3] = 1
        matrix[2, 2] = 1
        matrix[3, 1] = 1
        matrix[4, 4] = 1
        return Oracle(matrix)
    elseif f == 4
        matrix[1, 3] = 1
        matrix[2, 4] = 1
        matrix[3, 1] = 1
        matrix[4, 2] = 1
        return Oracle(matrix)
    else
        throw("Wrong index in oracle")
    end
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    deutsch()
end
