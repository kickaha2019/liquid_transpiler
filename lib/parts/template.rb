require_relative 'part'

module LiquidTranspiler
  module Parts
    class Template < Part
      class Names
        def initialize( arguments = {}, cycles={}, decrements={}, variables = {})
          @arguments  = arguments
          @cycles     = cycles
          @decrements = decrements
          @variables  = variables
          @locals     = {}
        end

        def arguments
          @arguments.keys
        end

        def assign( name)
          unless known?( name)
            @variables[name] = true
            @locals[name]    = true
          end
        end

        def cycle( name)
          @cycles[name] = true
        end

        def cycles
          @cycles.keys
        end

        def decrement( name)
          @decrements[name] = true
        end

        def decrements
          @decrements.keys
        end

        def known?( name)
          @arguments[name] || @variables[name]
        end

        def local?( name)
          @locals[name]
        end

        def locals
          @locals.each_key {|name| yield name}
        end

        def reference( name)
          @arguments[name] = true unless known?( name)
        end

        def spawn
          Names.new( @arguments,
                     @cycles,
                     @decrements,
                     Hash.new {|h,k| h[k] = @variables[k]})
        end
      end

      def initialize
        super( 0, nil)
      end

      def add( part)
        if part.is_a?( EndOfFile)
          return self
        end
        super( part)
      end

      def deduce_names
        Names.new().tap do |names|
          find_arguments( names)
        end
      end
    end
  end
end
