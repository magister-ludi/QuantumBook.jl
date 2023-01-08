
using Plots

# Take an iterable list of functions, and plot
# them on a single set of axes
function plotFunction(functions, xStart, xEnd)
    steps = 500
    x0 = xStart
    x1 = xEnd
    step = 1.0 / steps * (x1 - x0)
    xs = x0:step:x1
    p = plot(;
        xlabel = "number of bits",
        ylabel = "time required to factor",
        title = "Time Complexity",
        legend = :topleft,
    )
    plot!(xs, functions[1]; label = "classic")
    plot!(xs, functions[2]; label = "shor")
    return p
end

# Classical computation to factorise a b-bit number requires
# a time proportional to
# $$t_C(b)\approx \exp((64 / 9)^{(1 / 3)}b \log^2{b}).$$
classic(b) = exp((64 / 9 * b * log(b)^2)^(1 / 3))

# Shor's algorithm to factorise a b-bit number requires
# a time proportional to
shor(b) = b^3.0

# Plot the two complexity functions for comparison
function show_times()
    functions = (classic, shor)
    p = plotFunction(functions, 0.000001, 20)
    savefig(p, "ch01-01-time.png")
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    show_times()
end
