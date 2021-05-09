module RailsPlus::Helpers::FrameContainerTag
  def frame_container_tag(use_container = @use_container, &block)
    content_tag :div, class: 'frame' do
      content_tag :div, block_given? ? capture(&block) : nil, class: ('container' if use_container == true)
    end
  end
end
