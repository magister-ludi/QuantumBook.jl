
using StrangelyQuantum

function add_example1()
    for i = 0:1
        for j = 0:1
            sum = add(i, j)
            println("Adding ", i, " + ", j, " = ", sum)
        end
    end
end

function add(a, b)
    # There are two qubits in this program. Initially, they hold the
    # input values. After execution, the first qubit still has its
    # original value, while the second qubit has the sum.
    program = Program(2)
    prep = Step()
    # If a bit represents a 1, apply an X gate
    a > 0 && addGate(prep, X(1))
    b > 0 && addGate(prep, X(2))
    step0 = Step(Cnot(1, 2))
    addSteps(program, prep, step0)
    qee = SimpleQuantumExecutionEnvironment()
    result = runProgram(qee, program)
    qubits = getQubits(result)
    return measure(qubits[2])
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    add_example1()
end
