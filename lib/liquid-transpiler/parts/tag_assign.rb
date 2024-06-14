module LiquidTranspiler
  module Parts
    class TagAssign < Part
      def add( part)
        error( @offset, 'Internal error')
      end

      def find_arguments( names)
        @expression.find_arguments( names)
        names.assign( @variable)
      end

      def generate( context, indent, io)
        io.print ' ' * indent
        io.print context.variable( @variable)
        io.puts " = #{@expression.generate( context)}"
      end

      def setup( source)
        @variable = source.expect_name
        source.skip_space
        unless source.next('=')
          source.error( @offset, 'Expecting =')
        end

        @expression, term = Expression.parse( source)
        term
      end
    end
  end
end