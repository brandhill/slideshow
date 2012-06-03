module Slideshow

class Config
  
  def initialize
    @hash = {}
  end

  def []( key )
    value = @hash[ normalize_key( key ) ]
    if value.nil?
      puts "** Warning: config key '#{key}' undefined (returning nil)"
    end
    
    value
  end

  def load   
    # load builtin config file @  <gem>/config/slideshow.yml
    config_file         = "#{Slideshow.root}/config/slideshow.yml"
    config_builtin_file = "#{Slideshow.root}/config/slideshow.builtin.yml"

    # run through erb        
    config_txt = File.read( config_file )
    config_txt = ERB.new( config_txt ).result( binding() )
    
    @hash = YAML.load( config_txt )
    
    # for now builtin has no erb processing; add builtin hash to main hash 
    @hash[ 'builtin' ] = YAML.load_file( config_builtin_file )
    
    # todo/fix: merge config files
    #   check more locations

    # check for user settings in working folder (check for slideshow.yml)
    
    config_user_file = "./slideshow.yml"
    if File.exists?( config_user_file )
      puts "Loading settings from '#{config_user_file}'..."
      @hash[ 'user' ] = YAML.load_file( config_user_file )   
    end    
     
  end
  
  def markdown_post_processing?( lib )
    @hash.fetch( 'user', {} ).fetch( lib, {} ).fetch( 'post-processing', true )
  end
  
  def known_rest_extnames
    @hash[ 'builtin' ][ 'rest' ][ 'extnames' ]
  end
  
  def known_textile_extnames
    # returns an array of known file extensions e.g.
    # [ '.textile', '.t' ]
    #
    # using nested key
    # textile:
    #   extnames:  [ .textile, .t ]
    
    @hash[ 'textile' ][ 'extnames' ] + @hash[ 'builtin' ][ 'textile' ][ 'extnames' ] 
  end

  def known_markdown_extnames
    @hash[ 'markdown' ][ 'extnames' ] + @hash[ 'builtin' ][ 'markdown' ][ 'extnames' ]   
  end
  
  def known_extnames
    # ruby check: is it better self. ?? or more confusing
    #  possible conflict only with write access (e.g. prop=) 
    
    known_textile_extnames + known_markdown_extnames + known_rest_extnames
  end
  
  def text_filters
    @hash[ 'builtin' ][ 'filters' ] + @hash[ 'filters' ]
  end
  
  def helper_renames
     @hash[ 'builtin' ][ 'helper' ][ 'renames' ] + @hash[ 'helper' ][ 'renames' ]
  end

  def helper_unparsed
    # use unparsed params (passed along a single string)
    @hash[ 'builtin' ][ 'helper' ][ 'unparsed' ]
  end
  
  def helper_exprs
    # allow expression as directives (no need for %end block)
    # by default directives are assumed statements (e.g. %mydir  %end)
    @hash[ 'builtin' ][ 'helper' ][ 'exprs' ] + @hash[ 'helper' ][ 'exprs' ]
  end

  def google_analytics_code
    @hash[ 'analytics' ][ 'google' ]
  end
  
  def map_fetch_shortcut( key )
    @hash[ 'fetch' ][ key ]
  end
  
private

  def normalize_key( key )
    #  make key all lower case/downcase (e.g. Content-Type  => content-type)
    #  replace _ with -                 (e.g. gradient_color => gradient-color)
    #  todo: replace space(s) with -  ??
    #  todo: strip leading and trailing spaces - possible use case ??
    
    key.to_s.downcase.tr( '_', '-' )
  end

end # class Config

end # module Slideshow