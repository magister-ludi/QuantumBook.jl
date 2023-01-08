
using FileIO
using StrangelyDisplayed
using StrangelyQuantum

function hcz_example()
    simulator = SimpleQuantumExecutionEnvironment()
    program = Program(2)
    step1 = Step()
    addGate(step1, Hadamard(1))
    addStep(program, step1)
    step2 = Step()
    addGate(step2, Cz(1, 2))
    addStep(program, step2)
    save("ch06-02-hczmeasure-1.png", drawProgram(program))
    save("ch06-02-hczmeasure-2.png", drawTrialHistogram(program, 1000))
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    hcz_example()
end
