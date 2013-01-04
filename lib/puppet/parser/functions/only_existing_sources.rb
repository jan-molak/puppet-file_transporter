module Puppet::Parser::Functions
  newfunction(:only_existing_sources, :type => :rvalue) do |args|
    sources = []

    args.flatten.each do | source |
      unless Puppet::Util.absolute_path?(source)
        uri = URI.parse(URI.escape(source))
        raise Puppet::ParseError, ("Cannot use relative URLs '#{source}'") unless uri.absolute?
        raise Puppet::ParseError, ("Cannot use opaque URLs '#{source}'") unless uri.hierarchical?
        raise Puppet::ParseError, ("Cannot use URLs of type '#{uri.scheme}' as source for fileserving") unless %w{puppet}.include?(uri.scheme)

        sources << source unless Puppet::FileServing::Content.indirection.find(source).nil?
      else
        sources << source if Pathname.new(source).exist?
      end
    end

    sources
  end
end