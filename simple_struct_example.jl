struct Square
    side::Float64
    function Square(side)
        return side ^ 2
    end
end


square = Square(2)
println(square)