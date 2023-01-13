
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function add_example2()
    for i = 0:1
        for j = 0:1
            sum = add_w_carry(i, j)
            println("Adding ", i, " + ", j, " = ", sum)
        end
    end
end

function add_w_carry(a, b)
    program = Program(3)
    prep = Step()
    a > 0 && addGate(prep, X(1))
    b > 0 && addGate(prep, X(2))
    # The Toffoli gate flips its third bit if the first
    # and second bits are both 1
    step0 = Step(Toffoli(1, 2, 3))
    step1 = Step(Cnot(1, 2))
    addSteps(program, prep, step0, step1)
    qee = SimpleQuantumExecutionEnvironment()
    result = runProgram(qee, program)
    if a == 1 && b == 1
        save("ch07-04-add2.png", drawProgram(program))
    end
    qubits = getQubits(result)
    return measure(qubits[2]) + (measure(qubits[3]) << 1)
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    add_example2()
end
