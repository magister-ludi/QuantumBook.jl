
using Random
using Sockets

function runSender(port)
    b = rand(UInt8)
    println("[Sender] Create a connection to port ", port)
    # The sender opens a network socket.
    socket = connect(port)
    println("[Sender] Write a byte: ", b)
    # The sender writes a specific byte to the socket.
    write(socket, b)
    # The value of the transferred byte can still be used
    # (such as printed) by the sender
    println("[Sender] Wrote a byte: ", b)
    close(socket)
end

function runReceiver(port)
    # The receiver opens a network socket,
    # listening for incoming requests.
    server = listen(port)
    println("[Receiver] Starting to listen for incoming data at port ", port)
    while true
        b = nothing
        # When a connection is discovered, a direct socket connection
        # is created between the sender and the receiver.
        sock = accept(server)
        while isopen(sock)
            # The receiver reads a byte from the connection.
            b = read(sock, UInt8)
            break
        end
        # The receiver prints the value of the byte
        println("[Receiver] Got a byte ", b)
        break
    end
end

function main()
    port = 9755
    sender = @task runSender(port)
    receiver = @task runReceiver(port)
    schedule(sender)
    schedule(receiver)
    wait(receiver)
end

if endswith(PROGRAM_FILE, "run_debugger.jl") || abspath(PROGRAM_FILE) == @__FILE__
    main()
end
