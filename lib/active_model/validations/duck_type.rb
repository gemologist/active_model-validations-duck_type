# frozen_string_literal: true

require 'active_model'
require 'active_model/validations/duck_type/version'

module ActiveModel
  module Validations
    class DuckTypeValidator < EachValidator #:nodoc:
      def validate_each(record, attribute, value)
        operator = find_operator(options)
        methods = options[operator]
        return if valid?(methods, operator, value)
        record.errors.add(
          attribute,
          :invalid,
          options.except(operator).merge!(value: value)
        )
      end

      def check_validity!
        return if %i[all any one none].one? { |option| options.key? option }
        raise(
          ArgumentError,
          'Either :all, :any, :one, or, :none must be supplied'
        )
      end

      private

      def valid?(methods, operator, value)
        if methods.respond_to? :key?
          operator = find_operator(methods)
          methods = methods[operator]
        end

        if methods.respond_to? "#{operator}?".to_sym
          methods.send("#{operator}?".to_sym) { |m| valid?(m, operator, value) }
        else
          value.respond_to? methods.to_sym
        end
      end

      def find_operator(hash)
        %i[all any one none].find { |option| hash.key? option }
      end
    end

    module HelperMethods
      # Validates whether the value of the specified attribute is of the correct
      # duck type, going by the method symbolize provided. You can require that
      # the attribute respond to the methods:
      #
      #   class Person < ActiveRecord::Base
      #     validates_duck_type_of :pet, all: %i[house food]
      #   end
      #
      # Alternatively, you can require that the specified attribute does _not_
      # respond to the methods:
      #
      #   class Person < ActiveRecord::Base
      #     validates_duck_type_of :pet, none: :price
      #   end
      #
      # You could also provide operators combination:
      #
      #   class Person < ActiveRecord::Base
      #     validates_duck_type_of :pet,
      #                            all: [:house, :food, any: [:walk, :run]]
      #   end
      #
      # Configuration options:
      # * <tt>:message</tt> - A custom error message (default is: "is invalid").
      # * <tt>:all</tt> - Methods that if the attribute respond_to all will
      #   result in a successful validation.
      # * <tt>:any</tt> - Methods that if the attribute respond_to at least one
      #   will result in a successful validation.
      # * <tt>:one</tt> - Methods that if the attribute respond_to only one will
      #   result in a successful validation.
      # * <tt>:none</tt> - Methods that if the attribute respond_to none will
      #   result in a successful validation.
      #
      # There is also a list of default options supported by every validator:
      # +:if+, +:unless+, +:on+, +:allow_nil+, +:allow_blank+, and +:strict+.
      # See <tt>ActiveModel::Validations#validates</tt> for more information
      def validates_duck_type_of(*attr_names)
        validates_with DuckTypeValidator, _merge_attributes(attr_names)
      end
    end
  end
end
