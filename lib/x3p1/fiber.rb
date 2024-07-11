require_relative 'value'

module X3p1
  class Fiber
    Cycle = Class.new Exception
    NewCycle = Class.new Exception

    def call(x)
      generate([x], { x => true })
    end

    private

    def generate(values, has)
      for x in values
        raise Cycle if has[value = Value.next(x)]
        values << value
        has[value] = true
      end
    rescue Cycle
      raise NewCycle, "#{x}..#{value}" unless values.last == 1 || values.first == 1
      values
    end
  end
end
