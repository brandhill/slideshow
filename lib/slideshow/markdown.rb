module MarkdownEngines

  def rdiscount_to_html( content )
    RDiscount.new( content ).to_html
  end
  
  def rpeg_markdown_to_html( content )
    PEGMarkdown.new( content ).to_html
  end
  
  def maruku_to_html( content )
    Maruku.new( content, {:on_error => :raise} ).to_html
  end
  
  def bluecloth_to_html( content )
    BlueCloth.new( content ).to_html
  end
  
  def kramdown_to_html( content )
    Kramdown::Document.new( content ).to_html
  end

end   # module MarkdownEngines

class Slideshow::Gen
  include MarkdownEngines
end