
using FileIO
using Random
using StrangelyDisplayed
using StrangelyQuantum

function qrepeater()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(5)
    # randomly choose whether to set the first bit to 1
    r = rand(Bool)

    # The first steps are the same as in the teleport example
    # if r is true, set the first bit to 1
    if r
        step0 = Step()
        addGate(step0, X(1))
        addStep(program, step0)
    end
    step1 = Step()
    addGate(step1, Hadamard(2))
    addGate(step1, Hadamard(4))
    step2 = Step()
    addGate(step2, Cnot(2, 3))
    addGate(step2, Cnot(4, 5))
    step3 = Step()
    addGate(step3, Cnot(1, 2))
    step4 = Step()
    addGate(step4, Hadamard(1))
    step5 = Step()
    addGate(step5, Measurement(1))
    addGate(step5, Measurement(2))
    step6 = Step()
    addGate(step6, Cnot(2, 3))
    step7 = Step()
    addGate(step7, Cz(1, 3))

    # The following steps represent the repeater element
    step8 = Step()
    addGate(step8, Cnot(3, 4))
    step9 = Step()
    addGate(step9, Hadamard(3))
    step10 = Step()
    addGate(step10, Measurement(3))
    addGate(step10, Measurement(4))
    step11 = Step()
    addGate(step11, Cnot(4, 5))
    step12 = Step()
    addGate(step12, Cz(3, 5))
    addStep(program, step1)
    addStep(program, step2)
    addStep(program, step3)
    addStep(program, step4)
    addStep(program, step5)
    addStep(program, step6)
    addStep(program, step7)
    addStep(program, step8)
    addStep(program, step9)
    addStep(program, step10)
    addStep(program, step11)
    addStep(program, step12)
    initializeQubit(program, 1, 0.4)
    result = runProgram(simulator, program)
    qubits = getQubits(result)
    q3 = qubits[3]
    v3 = measure(q3)
    println("sent: ", Int(r), ", received: ", v3)
    save("ch06-04-repeater-1.png", drawProgram(program))
    save("ch06-04-repeater-2.png", drawTrialHistogram(program, 1000))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    qrepeater()
end
