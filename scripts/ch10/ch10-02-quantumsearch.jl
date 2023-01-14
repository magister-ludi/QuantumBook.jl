
using Random
using StrangelyQuantum

struct Person
    name::String
    age::Int
    country::String
end

function quantumSearch()
    for _ = 1:10
        persons = prepareDatabase()
        shuffle!(persons)
        target = Classic.search(persons) do p
            p.age == 29 && p.country == "Mexico" ? 1 : 0
        end
        println("Result of function search = ", target.name)
    end
end

function findPersonByFunction(func::Function, persons)
    idx = 1
    while idx ≤ length(persons)
        target = persons[idx]
        if func(target) == 1
            println("Got result after ", idx, " tries")
            return persons[idx]
        end
        idx += 1
    end
    return nothing
end

prepareDatabase() = [
    Person("Alice", 42, "Nigeria"),
    Person("Bob", 36, "Australia"),
    Person("Eve", 85, "USA"),
    Person("Niels", 18, "Greece"),
    Person("Albert", 29, "Mexico"),
    Person("Roger", 29, "Belgium"),
    Person("Marie", 15, "Russia"),
    Person("Janice", 52, "China"),
]

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    quantumSearch()
end
