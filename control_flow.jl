function syntax_1()
    z = begin
        x = 1; y = 2;
        return x + y
    end
    return z
end

function syntax_2()
    return (x = 1; y = 2; x + y)
end



z = syntax_1()
@info z

x = syntax_2()
@info x