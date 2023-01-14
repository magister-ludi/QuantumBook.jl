
using Random

const MAX_TRIES = 100

function semi_classic()
    target = rand(0:9999)
    cnt = 0
    f = -1
    while cnt < MAX_TRIES
        f = factorise(target)
        f > 0 && break
        cnt += 1
    end
    if cnt < MAX_TRIES
        println("Factored ", target, " in ", f, " and ", target ÷ f)
    else
        println(
            "Failed to factor ",
            target,
            " after ",
            MAX_TRIES,
            " tries. Might be a prime number?",
        )
    end
end

function factorise(n::Integer)
    # PREPROCESSING
    # Here, the preprocessing part begins.
    println("We need to factor ", n)

    # Pick a random number `a` between 1 and `n`
    a = rand(1:n-1)
    println("Pick a random number 1 ≤ a < $n: ", a)

    # Calculate the greatest common denominator (GCD) between `a` and `n`
    gcdan = gcd(n, a)
    println("calculate gcd(a, n): ", gcdan)

    # In case this GCD is not `1`, we are done, since that means the GCD is a factor of `n`
    gcdan != 1 && return gcdan

    # Find the periodicity of the modular exponentiatio function.
    p = findPeriod(a, n)
    println("period of f = ", p)
    if isodd(p)
        # If the period turns out to be an odd number, we can't use it and have to repeat the process
        println("bummer, odd period, restart.")
        return -1
    end
    # Perform some minor mathematical operations on the period to obtain a factor of `n`.
    md = 1
    for i = 1:(p ÷ 2)
        md = (md * a) % n
    end
    md = md + 1
    m2 = md % n
    if m2 == 0
        println("bummer, m^p/2 + 1 = 0 mod n, restart")
        return -1
    end
    factor = gcd(n, md)
    return factor
end

function findPeriod(a::Integer, n::Integer)
    r = 1
    bn = big(n)
    bi = big(a)
    mp = Int64(bi^r % n)
    while mp != 1
        r += 1
        mpd = bi^r
        mpb = mod(mpd, bn)
        mp = Int64(mpb)
    end
    return r
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    semi_classic()
end
