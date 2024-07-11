module X3p1
  module Value
    module_function

    # forward
    def next(x)
      x.odd? ? x * 3 + 1 : x / 2
    end

    # backward from odd
    def prev1(x)
      value = (x - 1) / 3
      value.odd? && value if (x - 1).fdiv(3) == value
    end

    # backward from even
    def prev2(x)
      x * 2
    end
  end
end

#
# todo ruby bug
# why it is not equal to prev1:
# (value = (x - 1) / 3).odd? && value if (x - 1).fdiv(3) == value
#
