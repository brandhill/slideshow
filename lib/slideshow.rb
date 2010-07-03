$KCODE = 'utf'

LIB_PATH = File.expand_path( File.dirname(__FILE__) )
$LOAD_PATH.unshift(LIB_PATH) 

# core and stlibs
require 'optparse'
require 'erb'
require 'logger'
require 'fileutils'
require 'pp'
require 'uri'
require 'net/http'
require 'ostruct'
require 'date'
require 'yaml'

# required gems
require 'redcloth'  # default textile library
require 'kramdown'  # default markdown library


# our own code
require 'slideshow/opts'
require 'slideshow/config'
require 'slideshow/gen'
require 'slideshow/slide'
require 'slideshow/textile'
require 'slideshow/markdown'

module Slideshow

  VERSION = '0.9'

  # version string for generator meta tag (includes ruby version)
  def Slideshow.generator
    "Slide Show (S9) #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def Slideshow.main
    
    # allow env variable to set RUBYOPT-style default command line options
    #   e.g. -o slides -t <your_template_manifest_here>
    slideshowopt = ENV[ 'SLIDESHOWOPT' ]
    
    args = []
    args += slideshowopt.split if slideshowopt
    args += ARGV.dup
    
    Gen.new.run(args)
  end

end # module Slideshow

# load built-in (required) helpers/plugins
require 'slideshow/helpers/text_helper.rb'
require 'slideshow/helpers/capture_helper.rb'

# load built-in (optional) helpers/plugins
#   If a helper fails to load, simply ingnore it
#   If you want to use it install missing required gems e.g.:
#     gem install coderay
#     gem install ultraviolet etc.
BUILTIN_OPT_HELPERS = [
  'slideshow/helpers/uv_helper.rb',
  'slideshow/helpers/coderay_helper.rb',
]

BUILTIN_OPT_HELPERS.each do |helper| 
  begin
    require(helper)
  rescue Exception => e
    ;
  end
end

Slideshow.main if __FILE__ == $0