# ActiveModel::Validations::DuckType

Duck type validators for active model.

`ActiveModel::Validations` was sorely lacking a system to validate the type. To respect Ruby, duck type.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_model-validations-duck_type'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model-validations-duck_type

## Usage

```ruby
    class Person
      include ActiveModel::Validations

      attr_accessor :pet

      validates :pet, duck_type: { all: %i[house food] }
    end

    person = Person.new
    person.pet = 'house'
    person.valid?  # => false
    
    class Parrot
      attr_accessor :house, :food
    end
    
    person.pet = Parrot.new
    person.valid?  # => true
```    

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/gemologist/active_model-validations-duck_type).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
