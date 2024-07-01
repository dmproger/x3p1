# 3x + 1 generator in Ruby

It's a numbers generator for not solved  __`3x + 1` mathematics problem__

[![Explanation](https://img.youtube.com/vi/094y1Z2wpJg/0.jpg)](https://www.youtube.com/watch?v=094y1Z2wpJg)

Allows to get fiber values for `x` or a hole values tree, that includes x.

It's very fast, becase of single loop implementation (recursion like)

# Install
```bash
git clone https://github.com/dmproger/x3p1.git 
cd x3p1
bundle
```

# Usage (terminal)
```bash
#
# some ENV's for use main.rb
#
# FIBER for fiber output
# TREE for tree output
# SHOW - how many results you want to display
# SORT - sorts result values
# X - start value
#
```

## Fiber
```bash
# set x and get results
X=7 FIBER=1 ruby main.rb
[7, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1]
-----
count: 17
-----
max value: 52

# try that one
X=3333333333333333333333333333333333333333333333333333333333333333 FIBER=1 ruby main.rb
```

## Tree
```bash
# set count and get results
COUNT=20 TREE=1 ruby main.rb 
[1, 2, 4, 8, 16, 32, 5, 64, 10, 128, 21, 20, 3, 256, 42, 40, 6, 512, 85, 84]
-----
show: 20, min: 0, max: 512
-----
max value: 512

# there is some interesting math moments
# first 638 (from 1 to 638) values tree must have 2037249 numbers with 9007199254740992 max value
COUNT=2037249 SHOW=638 SORT=1 ruby main.rb
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ... 636, 637, 638]
-----
show: 638, min: 0, max: 638
-----
max value: 9007199254740992

# you can also start from another x (mindblow huge max value output)
X=374662789498737752398765345678 COUNT=100000 SHOW=100 SORT=1 ruby main.rb
```

# Usage (code)

## X3p1.fiber(x)

Classic __forward way__ values generator. Choose `x` for start, and get results. If program finds new cycle different from `4,2,1` - it raises an exception, and you are gonna be famous.

it's implements via __single `for` iterator__.

### Interface
```ruby
require 'x3p1'

X3p1.fiber(3)
```

### Implementation
```ruby
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
      raise NewCycle, "#{x}..#{value}" unless values.last == 1
      values
    end
  end
end
```

## X3p1.tree(x, count:)

### Interface
```ruby
require 'x3p1'

X3p1.tree(1, count: 10000)
```

### Implementation

it's builds values in a __backward way__. Starts from `x` (default is 1) and generate all possible values, that can be. You must set values `count` in a tree before (default is 1 also). if you want infinity tree - set `count` to `Float::INFINITY`)

it's implements via __single `for` iterator__.

```ruby
module X3p1
  class Generator
    def call(x, count)
      Counter.apply(values = [], on: :<<, count:)
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
      values
    end
  end
end
```

See `lib` folder for more info


# Spec

there is spec for `X3p1::Value` module, that calculating next or previos values

```bash
bundle exec rspec
```

see `spec` folder for more info.

# Zipped code

just for fun. tree generator can be very compact:

```ruby
module X3p1
  class Generator
    def call(x, count)
      for x in values = Counter.apply([], on: :<<, count:) << ((has = { x => true }) && x)
        !has[value = Value.prev2(x)] && has[value] = true && values << value
        !has[value = Value.prev1(x) || next] && has[value] = true && values << value
      end
    rescue Counter::Stop
      values
    end
  end
end
```
