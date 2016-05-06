require 'ast'
require 'parser/ruby23'

::Parser::AST::Node.class_eval do
  attr_reader :meta

  alias_method :old_assign_properties, :assign_properties
  def assign_properties(properties)
    if meta = properties[:meta]
      meta = meta.dup if meta.frozen?
      @meta.merge!(meta)
    else
      @meta ||= {}
    end

    old_assign_properties(properties)
  end

  def line
    loc.line if loc
  end

  def column
    loc.column if loc
  end
end

module Opal
  class Parser < ::Parser::Ruby23
    def parse(source, file = '(string)')
      # Legacy support
      if String === source
        warn 'this method is deprecated from the public API'
        buffer        = ::Parser::Source::Buffer.new(file)
        buffer.source = source
      else
        buffer = source
      end

      super(buffer)
    end
  end
end
