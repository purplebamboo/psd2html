require "mustache"
require 'digest/md5'
require_relative '../until.rb'
module Psd2html
  	class Convertor
  		attr_accessor :psNode, :index, :childrenConvertors,:parentConvertor

  		CSS_TPL = "\.{{classname}}\{ \n{{#styles}} {{key}}:{{value}};\n{{/styles}}  \}"
  		CSS_HASH_BASE = {
  			"classname" => 'root-container',
  			"styles" => {
  				"position" => "relative"
  			}
  		}
  		@@css_dictory = {

  		}
  		
  		HTML_TPL = "<{{tag}} {{#attributes}} {{key}}=\"{{value}}\" {{/attributes}}>{{{content}}}</{{tag}}>"
  		HTML_HASH_BASE = {
  			"attributes" => {
  				"class" => "root-container"
  			},
  			"tag" => "div",
  			"content" => ""
  		}
  		def initialize(psNode,index,dstPath)
		    @psNode = psNode
		    @index = index
		    @parentConvertor = nil
		    @childrenConvertors = []
        @dstPath = dstPath
	    end
	    def guid
        if @psNode.name.include?("|")
	    	  className = @psNode.name.split("|")[-2]
        else
          className = @psNode.name
        end
	    	guidStr = className+@index.to_s
	    	if /\p{Han}+/u.match(className)
	    		Digest::MD5.hexdigest(guidStr)
	    	else
	    		guidStr
	    	end
	    	
	    end

      def curleft
        wrapleft = @parentConvertor.psNode.respond_to?("left") ? parentConvertor.psNode.left : 0
        "#{@psNode.left-wrapleft}px"
      end
      def curtop
        wraptop = @parentConvertor.psNode.respond_to?("top") ? parentConvertor.psNode.top : 0
        "#{@psNode.top-wraptop}px"
      end
	    #需要被重写，用于生成css的对象hash
	    def css_skeleton
	    	CSS_HASH_BASE
	    end
	    #需要被重写，用于生成html的模板渲染对象
	    def html_skeleton
	    	HTML_HASH_BASE
	    end
	    def get_css_tpl
	    	CSS_TPL
	    end
	    def get_html_tpl
	    	HTML_TPL
	    end
	    #为了处理css的同名问题，需要使用一个hash来去重
	    def css_map
        Until.log("start generate css of #{@psNode.name}...")
	    	return unless css_skeleton
	    	data = css_skeleton.clone
	    	data["styles"] = hash_to_array(data["styles"])
	    	data["convertnode"] = self
	    	@@css_dictory[data["classname"]] = data
	    	@childrenConvertors.each do |node|
	    		node.css_map
	    	end
	    end
	    def render_css
	    	css_map()
	    	cssStr = ""
	    	@@css_dictory.values.each do |cssData|
	    		cssStr += "\n" + Mustache.render(cssData['convertnode'].get_css_tpl,cssData)
	    	end
	    	@@css_dictory = {}
	    	cssStr = sync_css(cssStr)
	    end
	    
	    def render_html
        Until.log("start generate html of #{@psNode.name}...")
	    	return "" unless html_skeleton
	    	data = html_skeleton.clone
	    	data["attributes"] = hash_to_array(data["attributes"])
				
				@childrenConvertors.each do |node|
	    		data["content"] += node.render_html
	    	end
	    		    	
	    	htmlStr = Mustache.render(get_html_tpl,data)
	    	htmlStr = sync_html(htmlStr)
	    end
	    def sync_css(cssstr)
	    	cssstr
	    end
	    def sync_html(htmlstr)
	    	htmlstr
	    end
	    protected
	      def hash_to_array(originHash)
		    	dstArray = []
		    	originHash.each do |key,value| 
		    		dstArray << {"key"=>key,"value"=>value}
		    	end
		    	dstArray
	      end 
	      def css_hook(style)
	      	hookHash = {
	      		"pt" => "px",
	      		"MicrosoftYaHei" => "microsoft yahei",
            "rgba\\((\\s*\\d+,\\s*\\d+,\\s*\\d+),\\s*\\d+\\)" => -> { '#' + $1.split(',').map { |v| v.to_i.to_s(16) }.join }
	      	}
	      	hookHash.each do |key,value|
            if value.is_a?(Proc)
              
              style = style.gsub(Regexp.new(key)) { value.call }
            else
              style = style.gsub(Regexp.new(key), value)
            end
	      	end
	      	style
	      end
  	end

end