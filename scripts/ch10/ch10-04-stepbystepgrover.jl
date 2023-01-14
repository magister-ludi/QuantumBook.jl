
using FileIO
using LinearAlgebra
using StrangelyDisplayed
using StrangelyQuantum

function doGrover(dim, solution)
    sqee = SimpleQuantumExecutionEnvironment()
    nn = 1 << dim
    cnt = π * sqrt(nn) / 4
    p = Program(dim)
    s0 = Step()
    for i = 1:dim
        addGate(s0, Hadamard(i))
    end
    addStep(p, s0)
    oracle = createOracle(dim, solution)
    setCaption(oracle, "O")
    dif = createDiffMatrix(dim)
    difOracle = Oracle(dif)
    setCaption(difOracle, "D")
    i = 1
    while i < cnt
        s0prob = Step("Prob $i")
        addGate(s0prob, ProbabilitiesGate(1))
        s1 = Step("Oracle $i")
        addGate(s1, oracle)
        s1prob = Step("Prob $i")
        addGate(s1prob, ProbabilitiesGate(1))
        s2 = Step("Diffusion $i")
        addGate(s2, difOracle)
        s3 = Step("Prob $i")
        addGate(s3, ProbabilitiesGate(1))
        addStep(p, s0prob)
        addStep(p, s1)
        addStep(p, s1prob)
        addStep(p, s2)
        addStep(p, s3)
        i += 1
    end
    println(" n = ", dim, ", steps = ", cnt)

    res = runProgram(sqee, p)
    i = 1
    while i < cnt
        ip0 = getIntermediateProbability(res, 3 * i + 1)
        println("results after step ", i, ": ", sum(abs2, ip0[solution]))
        i += 1
    end
    println("\n")
    save("ch10-05-stepbystepgrover.png", drawProgram(p))
end

function createDiffMatrix(dim)
    nn = 1 << dim
    g = Hadamard(1)
    matrix = g.matrix
    h2 = matrix
    for i = 2:dim
        h2 = kron(h2, matrix)
    end
    I2 = Matrix{ComplexF64}(I, nn, nn)
    I2[1, 1] = -1
    nd = dim << 1

    inter1 = h2 * I2
    dif = inter1 * h2
    return dif
end

# solution must be < dim*dim
function createOracle(dim, solution)
    nn = 1 << dim
    println("dim = ", dim, " hence N = ", nn)
    matrix = Matrix{ComplexF64}(I, nn, nn)
    matrix[solution, solution] = -1
    return Oracle(matrix)
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    doGrover(2, 3)
end
