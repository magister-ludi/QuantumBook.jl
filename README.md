# QuantumBook.jl
This is a Julia port of the [code](https://github.com/johanvos/quantumjava) from the book "[Quantum Computing in Action](https://www.manning.com/books/quantum-computing-in-action)".

Most of the code is provided as notebooks and as stand alone scripts.

## Setup

`QuantumBook.jl` is unregistered and uses two unregistered packages, [StrangelyQuantum.jl](https://github.com/magister-ludi/StrangelyQuantum.jl), and  [StrangelyDisplayed.jl](https://github.com/magister-ludi/StrangelyDisplayed.jl). To install everything, do the following:

1. Clone `QuantumBook.jl`

    `git clone https://github.com/magister-ludi/QuantumBook.jl`

2. Open a command prompt, change directory to the location created in step 1, and run the setup script

    `cd /directory/containing/QuantumBook.jl`
    `julia setup.jl`

This will install the two packages, and packages that they depend on.
