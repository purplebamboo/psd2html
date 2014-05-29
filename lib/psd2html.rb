require 'psd'
require_relative './until.rb'
require_relative 'psd2html/convertor.rb'
Dir.glob( File.expand_path( "psd2html/psconvertor/*.rb", File.dirname(__FILE__) ) ) do |convertor|
  require convertor
end

class Psd2Html
	CONVERTING_MAP = {
		"text" => ::Psd2html::PsConvertor::Text,
		"text-link" => ::Psd2html::PsConvertor::TextLink,
		"block" => ::Psd2html::PsConvertor::Block,
		"block-link" => ::Psd2html::PsConvertor::BlockLink,
		"img" => ::Psd2html::PsConvertor::Img,
		"img-link" => ::Psd2html::PsConvertor::ImgLink,
		"img-bg" => ::Psd2html::PsConvertor::ImgBackground,
		"root" => ::Psd2html::PsConvertor::Root
	}
	def initialize(psdPath,dstHtmlPath)
    @dstHtmlPath = dstHtmlPath
		psd = PSD.new(psdPath)
		psd.parse! 
		blockRoot = psd.tree
		rootConvertor = get_convertor(blockRoot,1)
		@treeRoot = format_tree(rootConvertor)
    Until.log("start generate psd tree....")
  end

  def render_css
    Until.log("start render css....")
  	return @treeRoot.render_css
  end
  def render_html
    Until.log("start render html....")
  	return @treeRoot.render_html
  end

  def render
  	return <<-STR
			<meta charset="utf-8" />
			<style type="text/css">
			#{@treeRoot.render_css}
			</style>
			#{@treeRoot.render_html}
		STR

  end

  protected
    def get_convertorname(node)
      type = node.to_hash[:type]
      if node.name.include?("|")
        convertorName = node.name.split('|').last.to_s
      elsif type == :group
        convertorName = "block"
      elsif type == :layer && !node.text.nil?
        convertorName = "text"
      else
        convertorName = "img"
      end 
      
    end
  	def get_convertor(node,index)

  		return CONVERTING_MAP["root"].new(node,index,@dstHtmlPath) if node.root? 

  		#return unless node.name.include?("|") 
      #if node.name.include?("|")
        #convertorName = node.name.split('|').last.to_s
      #end
  		convertorName = get_convertorname(node)
  		unless CONVERTING_MAP.include?(convertorName)
  			return
  		end
  		CONVERTING_MAP[convertorName].new(node,index,@dstHtmlPath)
		end
		def format_tree(convertor)
			if convertor.psNode.has_children?
				convertor.psNode.children.each_with_index do |node,index|
					childConvertor = get_convertor(node,index)
					if childConvertor
						childConvertor.parentConvertor = convertor
						convertor.childrenConvertors << format_tree(childConvertor)
					end
				end
			end
			convertor
		end

end






