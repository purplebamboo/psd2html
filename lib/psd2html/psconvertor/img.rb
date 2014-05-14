module Psd2html
	module PsConvertor
  	class Img < ::Psd2html::Convertor
  		def css_skeleton
	    	cssRenderData = {
  				"classname" => "img-#{guid}",
	  			"styles" => {
	  				"position" => "absolute",
  					"display" => "inline-block",
            "border" => "none",
	  				"width" => "#{@psNode.width}px",
	  				"height" => "#{@psNode.height}px",
	  				"left" => curleft,
	  				"top" => curtop,
	  				"z-index" => "#{@psNode.depth}#{@parentConvertor.childrenConvertors.length - @index.to_i}"
	  			}
  			}
	    	cssRenderData = CSS_HASH_BASE.merge(cssRenderData)
	    end
	    def get_html_tpl
	    	"<{{tag}} {{#attributes}} {{key}}=\"{{value}}\" {{/attributes}} />"
	    end
	    def html_skeleton
        

	    	imgUrl = "#{File.dirname(@dstPath)}/img-source-#{guid}-#{Time.now.to_i}.png"
        @psNode.image.save_as_png(imgUrl)
	    	htmlRenderData = {
	    		"attributes" => {
	  				"class" => "img-#{guid}",
	  				"src" => imgUrl
	  			},
	  			"tag" => "img"
	    	}
	    	htmlRenderData = HTML_HASH_BASE.merge(htmlRenderData)
	    end
  	end
  end

end