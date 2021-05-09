module RailsPlus::Helpers::Dashed
  def dashed(word)
    word.tr('_', '-')
  end
end
