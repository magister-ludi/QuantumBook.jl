
using Random

struct Person
    name::String
    age::Int
    country::String
end

function classicsearch()
    println("Hello, classical search")
    complexSearch()
    functionSearch()
end

function complexSearch()
    for _ = 1:10
        persons = prepareDatabase()
        shuffle!(persons)
        target = findPersonByAgeAndCountry(persons, 29, "Mexico")
        println("Result of complex search = ", target.name)
    end
end

function findPersonByAgeAndCountry(
    persons::AbstractVector{Person},
    age::Integer,
    country::AbstractString,
)
    idx = 1
    while idx ≤ length(persons)
        target = persons[idx]
        if target.age == age && target.country == country
            println("Got result after ", idx, " tries")
            return persons[idx]
        end
        idx += 1
    end
    return nothing
end

function functionSearch()
    f29Mexico = p -> p.age == 29 && p.country == "Mexico" ? 1 : 0
    for _ = 1:10
        persons = prepareDatabase()
        shuffle!(persons)
        target = findPersonByFunction(f29Mexico, persons)
        println("Result of function Search = ", target.name)
    end
end

function findPersonByFunction(func::Function, persons::AbstractVector{Person})
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
    classicsearch()
end
