
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function grover_oracle()
    print("Use 00 as input")
    testOracle(0, 0)
    print("\nUse 01 as input")
    testOracle(0, 1)
    print("\nUse 10 as input")
    testOracle(1, 0)
    print("\nUse 11 as input")
    testOracle(1, 1)
end

function testOracle(w::Integer)
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(2)

    prepareStep = Step()
    w -= 1
    ((w >> 0) & 1) == 1 && addGate(prepareStep, X(1))
    ((w >> 1) & 1) == 1 && addGate(prepareStep, X(2))
    addStep(program, prepareStep)

    oracleStep = Step()
    oracle = createOracle()
    addGate(oracleStep, oracle)
    addStep(program, oracleStep)

    result = runProgram(simulator, program)
    qubits = getQubits(result)

    println("input: ", lpad(string(w, base = 2), 2, "0"),
            ", measured = |", measure(qubits[1]), measure(qubits[2]), ">")
    save("ch10-03-groveroracle-$w.png", drawProgram(program))
end

function createOracle()
    matrix = zeros(ComplexF64, 4, 4)

    matrix[1, 1] = 1
    matrix[2, 2] = 1
    matrix[3, 3] = -1
    matrix[4, 4] = 1

    return Oracle(matrix)
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    grover_oracle()
end
