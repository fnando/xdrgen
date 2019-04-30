require 'slop'

module Xdrgen
  module CLI
    def self.run(args)
      args = args.dup
      opts = Slop.parse! args do
        banner 'Usage: xdrgen -o OUTPUT_DIR INPUT --gen=ruby'
        on 'o', 'output=', 'The output directory'
        on 'l', 'language=', 'The output language', default: 'ruby'
        on 'n', 'namespace=', '"namespace" to generate code within (language-specific)'
      end

      fail(opts) if args.blank?
      fail(opts) if opts[:output].blank?

      source_paths = args.map {|path| Dir[path] }
                         .compact
                         .flatten

      compilation = Compilation.new(
        source_paths,
        output_dir: opts[:output],
        language:   opts[:language].to_sym,
        namespace:  opts[:namespace]
      )
      compilation.compile
    end

    def self.fail(slop, code=1)
      STDERR.puts slop
      exit(code)
    end
  end
end
