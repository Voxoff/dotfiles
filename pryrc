if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

if false

begin
  require 'rubygems'
  require 'awesome_print'
  require 'awesome_print_colors'

  # AwesomePrint.defaults={
  #               :theme=>:solorized,
  #               :indent => 2,
  #               :sort_keys => true,
  #               :color => {
  #                 :args       => :greenish,
  #                 :array      => :pale,
  #                 :bigdecimal => :blue,
  #                 :class      => :yellow,
  #                 :date       => :greenish,
  #                 :falseclass => :red,
  #                 :fixnum     => :blue,
  #                 :float      => :blue,
  #                 :hash       => :pale,
  #                 :keyword    => :cyan,
  #                 :method     => :purpleish,
  #                 :nilclass   => :red,
  #                 :string     => :yellowish,
  #                 :struct     => :pale,
  #                 :symbol     => :cyanish,
  #                 :time       => :greenish,
  #                 :trueclass  => :green,
  #                 :variable   => :cyanish
  #             }
  #          }



  AwesomePrint.defaults={:theme=>:solorized}

  # The following line enables awesome_print for all pry output,
  # and it also enables paging
  Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}

  # If you want awesome_print without automatic pagination, use the line below
  # Pry.config.print = proc { |output, value| output.puts value.ai }
rescue LoadError => err
  puts "gem install awesome_print  # <-- highly recommended"
end



# === COLOR CUSTOMIZATION ===
# Everything below this line is for customizing colors, you have to use the ugly
# color codes, but such is life.
CodeRay.scan("example", :ruby).term # just to load necessary files
# Token colors pulled from: https://github.com/rubychan/coderay/blob/master/lib/coderay/encoders/terminal.rb
TERM_TOKEN_COLORS = {
        :attribute_name => '33',
        :attribute_value => '31',
        :binary => '1;35',
        :char => {
          :self => '36', :delimiter => '34'
        },
        :class => '1;35',
        :class_variable => '36',
        :color => '32',
        :comment => '37',
        :complex => '34',
        :constant => ['34', '4'],
        :decoration => '35',
        :definition => '1;32',
        :directive => ['32', '4'],
        :doc => '46',
        :doctype => '1;30',
        :doc_string => ['31', '4'],
        :entity => '33',
        :error => ['1;33', '41'],
        :exception => '1;31',
        :float => '1;35',
        :function => '1;34',
        :global_variable => '42',
        :hex => '1;36',
        :include => '33',
        :integer => '1;34',
        :key => '35',
        :label => '1;15',
        :local_variable => '33',
        :octal => '1;35',
        :operator_name => '1;29',
        :predefined_constant => '1;36',
        :predefined_type => '1;30',
        :predefined => ['4', '1;34'],
        :preprocessor => '36',
        :pseudo_class => '34',
        :regexp => {
          :self => '31',
          :content => '31',
          :delimiter => '1;29',
          :modifier => '35',
          :function => '1;29'
        },
        :reserved => '1;31',
        :shell => {
          :self => '42',
          :content => '1;29',
          :delimiter => '37',
        },
        :string => {
          :self => '36',
          :modifier => '1;32',
          :escape => '1;36',
          :delimiter => '1;32',
        },
        :symbol => '1;31',
        :tag => '34',
        :type => '1;34',
        :value => '36',
        :variable => '34',

        :insert => '42',
        :delete => '41',
        :change => '44',
        :head => '45'
}

module CodeRay
    module Encoders
        class Terminal < Encoder
            # override old colors
            TERM_TOKEN_COLORS.each_pair do |key, value|
                TOKEN_COLORS[key] = value
            end
        end
    end
end

end
