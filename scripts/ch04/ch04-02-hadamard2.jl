
using StrangelyQuantum

function hadamard2_example()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(1)
    step = Step()
    # add a Hadamard gate as in earlier examples
    addGate(step, Hadamard(1))
    addStep(program, step)
    step2 = Step()
    # add a second Hadamard gate acting on the output of the first
    addGate(step2, Hadamard(1))
    addStep(program, step2)
    cntZero = 0
    cntOne = 0
    for _ = 1:1000
        result = runProgram(simulator, program)
        qubits = getQubits(result)
        q1 = qubits[1]
        value = measure(q1)
        value == 0 && (cntZero += 1)
        value == 1 && (cntOne += 1)
    end
    println(
        "Applied H-H circuit and evaluated 1000 times, got ",
        cntZero,
        " zeros and ",
        cntOne,
        " ones.",
    )
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    hadamard2_example()
end
