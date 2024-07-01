require_relative 'counter'
require_relative 'value'

module X3p1
  class Tree
    def call(x, count)
      Counter.apply(values = [], on: :<<, count: count + 1) # zero value artefact
      generate(values << x, { x => true })
    end

    private

    def generate(values, has)
      for x in values
        unless has[value = Value.prev2(x)]
          values << value
          has[value] = true
        end
        unless has[value = Value.prev1(x) || next]
          values << value
          has[value] = true
        end
      end
    rescue Counter::Stop
      values.delete(0) # that one
      values
    end
  end
end
