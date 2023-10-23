function test_map_with_do_block_syntax()
    return map(
        x-> begin
                if x == 1
                    @info "x == 1"
                elseif x == 2
                    @info "x == 2"
                else
                    @warn "broken"
                end
            end,
        [1, 2, 3]
    )
end

function test_map_with_do_block_syntax2()
    return map([1, 2, 3]) do x
            if x == 1
                @info "x == 1"
            elseif x == 2
                @info "x == 2"
            else
                @warn "broken"
            end
        end
    end
    
function write_file_with_do_block_syntax()
    touch("file.txt")
    open("file.txt", "w") do io
        write(io, "Hello Julia")
    end
end

function composition_functions()

    @info """example from map: map(first ∘ reverse ∘ uppercase, split("you can compose functions like this"))"""
    map(first ∘ reverse ∘ uppercase, split("you can compose functions like this"))

    @info "(sqrt ∘ +)(3, 6)-> Result: 3, cos 3+6=9 and sqrt(9) = 3."

    @info "(sqrt ∘ sum)(1:10) is equal to 1:10 |> sum |> sqrt"
    @info "Running...: 1:10 |> sum |> sqrt"
    result = 1:10 |> sum |> sqrt
    @info "result: $result"
    return result
end

function pipeoperators()
    result = ["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]
    @info """["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]"""
    @info result
end


test_map_with_do_block_syntax()
test_map_with_do_block_syntax2()
write_file_with_do_block_syntax()
composition_functions()
pipeoperators()