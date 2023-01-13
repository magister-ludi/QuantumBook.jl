
using StrangelyQuantum

function oracle_example2()
    println("Use 00 as input")
    apply_oracle(0, 0)
    println("\nUse 01 as input")
    apply_oracle(0, 1)
    println("\nUse 10 as input")
    apply_oracle(1, 0)
    println("\nUse 11 as input")
    apply_oracle(1, 1)
end

function construct_oracle_program(qubit1, qubit2, choice)
    program = Program(2)

    prepareStep = Step()
    qubit1 == 1 && addGate(prepareStep, X(1))
    qubit2 == 1 && addGate(prepareStep, X(2))
    addStep(program, prepareStep)

    oracleStep = Step()
    oracle = createOracle(choice)
    addGate(oracleStep, oracle)
    addStep(program, oracleStep)
    return program
end

function apply_oracle(qubit1, qubit2)
    simulator = SimpleQuantumExecutionEnvironment()
    for choice = 1:4
        program = construct_oracle_program(qubit1, qubit2, choice)

        result = runProgram(simulator, program)
        qubits = getQubits(result)

        constant = choice == 1 || choice == 4

        println(constant ? "C" : "B", ", measured = |", measure(qubits[1]), measure(qubits[2]), ">")
    end
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
        matrix[2, 2] = 1
        matrix[3, 4] = 1
        matrix[4, 3] = 1
        return Oracle(matrix)
    elseif f == 3
        matrix[1, 2] = 1
        matrix[2, 1] = 1
        matrix[3, 3] = 1
        matrix[4, 4] = 1
        return Oracle(matrix)
    elseif f == 4
        matrix[1, 2] = 1
        matrix[2, 1] = 1
        matrix[3, 4] = 1
        matrix[4, 3] = 1
        return Oracle(matrix)
    else
        throw("Wrong index in oracle construction")
    end
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    oracle_example2()
end
