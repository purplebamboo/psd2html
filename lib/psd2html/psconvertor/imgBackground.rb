module Psd2html
	module PsConvertor
  	class ImgBackground < ::Psd2html::Convertor
  		#对父转换对象进行了css注入
	    def css_map
	    	imgUrl = "./img-source-#{guid}-#{Time.now.to_i}.png"
  			@psNode.image.save_as_png(imgUrl)
  			parentConvertorClassName = @parentConvertor.css_skeleton()["classname"]
  			if @@css_dictory.has_key?(parentConvertorClassName)
	    		@@css_dictory[parentConvertorClassName]['styles'] << {"key" => "background","value" => "url(#{imgUrl}) center center"}
	    	end
	    end
	    def html_skeleton
	    	return nil
	    end
	    def get_html_tpl
	    	return ""
	    end
	    
  	end
  end

end