# 3x + 1 generator in Ruby

It's a numbers generator for  __`3x + 1` mathematics problem__.

Allows to get fiber values for `x` or a hole possible values tree, that related with x. It's pretty fast, because of single loop implementation. Actualy, __recursion like loop__ - it's a feature of that generators.

Click here for more info about a problem:

[![Explanation](https://img.youtube.com/vi/094y1Z2wpJg/0.jpg)](https://www.youtube.com/watch?v=094y1Z2wpJg)

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

# or maybe that one
X=1824374248357843142499024881034285372949085937280148297491804289574809028573\
579248012579480127959740812759794825768279480257948597794825779480257928401259\
794810257294825736592804537659820459736748235743984205727948057947801275948012\
125794180257980142579841025798014527914802579841025735284537695824057365982405\
057984102579845979845794812597804125978014592780152798105279801527958105297580 FIBER=1 ruby main.rb
```

## Tree
```bash
# set count and get results
COUNT=20 TREE=1 ruby main.rb 
[1, 2, 4, 8, 16, 32, 5, 64, 10, 128, 21, 20, 3, 256, 42, 40, 6, 512, 85, 84]
-----
show: 20, min: 1, max: 512
-----
max value: 512

# there is some interesting math moments. for example:
# values tree with first 638 numbers filled from 1 to 638 must contain a 2037249 values with 9007199254740992 max one
COUNT=2037249 SHOW=638 SORT=1 TREE=1 ruby main.rb
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, ... 636, 637, 638]
-----
show: 638, min: 1, max: 638
-----
max value: 9007199254740992

# you can also build tree, starting with another x, for example with a big one.
# you will get a mindblow huge max value in an output, try that one:
X=374662789498737752398765345678 COUNT=100000 SHOW=100 SORT=1 TREE=1 ruby main.rb
```

# Usage (code)

## Interface
```ruby
module X3p1
  module_function

  def fiber(x = 1)
    Fiber.new.call(x)
  end

  def tree(x = 1, count: 1)
    Tree.new.call(x, count)
  end
end

X3p1.fiber(7)
# [7, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1]

X3p1.tree(count: 20)
# [1, 2, 4, 8, 16, 32, 5, 64, 10, 128, 21, 20, 3, 256, 42, 40, 6, 512, 85, 84]
```

## Implementation

### X3p1.fiber(x)

Classic __forward way__ values generator. Choose `x` for start, and get results. If program finds new cycle different from `4,2,1` - it raises an exception, and you are gonna be famous.

It's implements via __single `for` iterator__.

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

### X3p1.tree(x, count)

It's builds values in a __backward way__. Starts from `x` (default is 1) and generate all possible values, that can be. You must set values `count` in a tree before (default is 1 also). if you want infinity tree - set `count` to `Float::INFINITY`)

It's implements via __single `for` iterator__ too.

```ruby
module X3p1
  class Tree
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

# Benefits of code

## Separation of logics

- Counting values delegated to `Counter` module, wich applied on array before start. So, generate process becomes free from any other logic, except generating the values and store it in array. So, any rules that stops collecting values - it's not his matter and area of responsibillity. Make sense.
- Matematics operations delegated to `Value` module, wich provides any logic for getting values. Like `next`, `prev1` and `prev2` in a __3x + 1__ tree. So, generator also don't know, what a mathematics is - this is not his matter too.

## Recursion like loop

It's a bad idea to do that in a real world tasks - but here it's seem to be a great and compact solution. Array, wich iterated in a single loop and __growing during that iteration__. It becomes possible, because Ruby does not affects the same element twice in a `for` cycle. But any new element wich appears in an array becomes a new target of next iteration step. Because of that - it very similar to recursion, but with no function and no stackoverflow. Just a loop.

Ruby VM has some optimization for `tail recurscion`, so, it also can be fast and no stackoverflow. But making tree with a single loop it's more efficient, compact and fun. Just in this case.

# Specs

There is spec for `X3p1::Value` module, that calculating next or previos values

```bash
bundle exec rspec
```

See `spec` folder for more info.

# Zipped code

Just for fun. Tree generator can be very compact:

```ruby
module X3p1
  class Tree
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
