module X3p1
  module Value
    module_function

    # forward
    def next(x)
      x.odd? ? x * 3 + 1 : x / 2
    end

    # backward from odd
    def prev1(x)
      val = (x - 1) / 3
      (val if val.odd?) if (x - 1).fdiv(3) == val
    end

    # backward from even
    def prev2(x)
      x * 2
    end
  end
end
