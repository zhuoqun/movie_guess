class ShowCategory
  def initialize
    @categories = ['screenshot', 'lines']
  end

  def matches?(request)
    @categories.include?(request.params[:category])
  end
end
