
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function deutschjosza()
    n = 3
    simulator = SimpleQuantumExecutionEnvironment()
    program = nothing
    for choice in (false, true)
        # Create a program with N + 1 qubits. We need N qubits
        # for the input bits and an additional ancilla qubit.
        program = Program(n + 1)
        step0 = Step()
        # Apply a Pauli-X gate to the ancilla qubit
        addGate(step0, X(n + 1))

        step1 = Step()
        # Apply a Hadamard gate to all qubits, bringing
        # them into superposition
        for j = 1:(n + 1)
            addGate(step1, Hadamard(j))
        end

        step2 = Step()
        # Fetch and apply an oracle to the circuit
        oracle = createOracle(n, choice)
        addGate(step2, oracle)

        step3 = Step()
        # Apply a Hadamard gate to all input qubits (not
        # to the ancilla qubit)
        for j = 1:n
            addGate(step3, Hadamard(j))
        end

        addStep(program, step0)
        addStep(program, step1)
        addStep(program, step2)
        addStep(program, step3)
        # Execute the program and measure the first qubit
        result = runProgram(simulator, program)
        qubits = getQubits(result)
        println("f = ", choice, ", val = ", measure(qubits[1]))
    end
    save("ch09-06-deutschjozsa.png", drawProgram(program))
end

function createOracle(n::Integer, f::Bool)
    dim = 2 << n
    half = dim ÷ 2

    matrix = zeros(ComplexF64, dim, dim)

    if !f
        for i = 1:dim
            matrix[i, i] = 1
        end
        return Oracle(matrix)
    elseif f
        for i = 1:dim
            if isodd(i)
                matrix[i, i] = 1
            else
                if i <= half
                    matrix[i, i + half] = 1
                else
                    matrix[i, i - half] = 1
                end
            end
        end
        return Oracle(matrix)
    end
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    deutschjosza()
end
