module Psd2html
	module PsConvertor
  	class TextLink < ::Psd2html::PsConvertor::Text
  		def guid
	    	"link-" + super
	    end

	    def html_skeleton
	    	htmlRenderData = {
	    		"attributes" => {
	  				"class" => "text-#{guid}",
	  				"href" => "#"
	  			},
	  			"tag" => "a",
	  			"content" => @psNode.text[:value]
	    	}
	    	htmlRenderData = HTML_HASH_BASE.merge(htmlRenderData)
	    end
  	end
  end

end