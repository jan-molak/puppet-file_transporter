module Puppet::Parser::Functions
  newfunction(:only_existing_sources, :type => :rvalue) do | args |
    sources = []

    args.flatten.each do | source |
      path = Pathname.new(source)
      sources << source unless path.absolute? and not path.exist?
    end

    sources
  end
end