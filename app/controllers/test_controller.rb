class TestController < ApplicationController

  DEFAULT_MAX_DEPTH = 5
  DEFAULT_LINK_SIZE = 10

  def index
    @link_size = params.fetch(:link_size, DEFAULT_LINK_SIZE).to_i
    @max_depth = params.fetch(:max_depth, DEFAULT_MAX_DEPTH).to_i
    @depth = params.fetch(:depth, 0).to_i
    
    # Use the combination of page_id and depth as seed
    # so that there won't be any duplicate links
    @next_page_ids = @depth >= @max_depth ? [] : make_page_id_enumerator(params[:page_id]+@depth.to_s).take(@link_size)
    @next_page_params = params.except(:controller, :action, :page_namespace, :page_id).merge(depth: @depth+1)
  end

  private

  def make_page_id_enumerator(seed)
    page_id_enumerator = Enumerator.new do |y|
      curr_page_id = seed
      loop do
        next_page_id = Digest::MD5.hexdigest(curr_page_id)
        y << next_page_id
        curr_page_id = next_page_id
      end
    end
    return page_id_enumerator
  end
end
