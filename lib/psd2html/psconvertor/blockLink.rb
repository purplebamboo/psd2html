module Psd2html
	module PsConvertor
	  	class BlockLink < ::Psd2html::PsConvertor::Block
	  		def guid
		    	"link-" + super
		    end
		    def html_skeleton
		    	htmlRenderData = {
		    		"attributes" => {
		  				"class" => "block-#{guid}",
		  				"href" => "#"
		  			},
		  			"tag" => "a",
		    	}
		    	htmlRenderData = HTML_HASH_BASE.merge(htmlRenderData)
		    end
	  		
	  	end
  	end

end