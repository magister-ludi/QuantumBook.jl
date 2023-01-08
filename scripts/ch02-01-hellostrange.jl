
using StrangelyQuantum

"""
    hello()
This is the Julia equivalent of Listing 2.3
"""
function hello()
    println("Using high-level Strange API to generate random bits")
    println("----------------------------------------------------")
    # Call the high-level API to generate one random bit
    randomBit = Classic.randomBit()
    println("Generate one random bit, which can be 0 or 1. Result = ", randomBit)
    cntZero = 0
    cntOne = 0
    # Generate 10,000 random bits
    for _ = 1:10000
        if Classic.randomBit() > 0
            cntOne += 1
        else
            cntZero += 1
        end
    end
    println("Generated 10000 random bits, ", cntZero, " of them were 0, and ", cntOne, " were 1.")
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    hello()
end
