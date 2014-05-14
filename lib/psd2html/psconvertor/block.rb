module Psd2html
	module PsConvertor
	  	class Block < ::Psd2html::Convertor
	  		
	  		def css_skeleton

	  			cssRenderData = {
	  				"classname" => "block-#{guid}",
		  			"styles" => {
		  				"position"=> "absolute",
		  				"display" => "inline-block",
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
		    	"<{{tag}} {{#attributes}} {{key}}=\"{{value}}\" {{/attributes}}><div style=\"position:relative;\">{{{content}}}</div></{{tag}}>"
		    end
		    def html_skeleton
		    	htmlRenderData = {
		    		"attributes" => {
		  				"class" => "block-#{guid}"
		  			},
		  			"tag" => "div"
		    	}
		    	htmlRenderData = HTML_HASH_BASE.merge(htmlRenderData)
		    end
	  		
	  	end
  	end

end