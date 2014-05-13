require 'psd'
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
	def initialize(psdPath)
		psd = PSD.new(psdPath)
		psd.parse! 
		blockRoot = psd.tree
		rootConvertor = get_convertor(blockRoot,1)
		@treeRoot = format_tree(rootConvertor)
  end

  def render_css
  	return @treeRoot.render_css
  end
  def render_html
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
  	def get_convertor(node,index)

  		return CONVERTING_MAP["root"].new(node,index) if node.root? 

  		return unless node.name.include?("|") 

  		convertorName = node.name.split('|').last.to_s
  		unless CONVERTING_MAP.include?(convertorName)
  			return
  		end
  		CONVERTING_MAP[convertorName].new(node,index)
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






