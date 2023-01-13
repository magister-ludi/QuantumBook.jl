
using FileIO
using Random
using StrangelyDisplayed

randomBit(random::AbstractRNG) = rand(random, Bool)

function calculate_twocoins(random::AbstractRNG, count)
    results = zeros(Int, 4)
    for _ = 1:count
        # Create two random bits: each can be true or false,
        # independently of the other
        coinA = randomBit(random)
        coinB = randomBit(random)
        # Based on the values of the two bits, increment one
        # element in the probability vector
        !coinA && !coinB && (results[1] += 1)
        !coinA && coinB && (results[2] += 1)
        coinA && !coinB && (results[3] += 1)
        coinA && coinB && (results[4] += 1)
    end
    return results
end

function two_coins()
    random = Xoshiro()
    count = 1000
    # Invoke the calculation function
    results = calculate_twocoins(random, count)
    println("=================================")
    println("We did ", count, " experiments.")
    println("0 0 occurred ", results[1], " times.")
    println("0 1 occurred ", results[2], " times.")
    println("1 0 occurred ", results[3], " times.")
    println("1 1 occurred ", results[4], " times.")
    println("=================================")
    # Show the outcomes in a histogram
    save(
        "ch05-01-classiccoin.png",
        drawHistogram(results;
                      xlabel = "Bit pattern",
                      ylabel = "Counts",
                      xlabels = lpad.(string.(0:3, base = 2), 2, "0")),
    )
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    two_coins()
end
