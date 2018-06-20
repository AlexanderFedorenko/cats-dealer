class CatsPresenter
  def initialize(cat = nil)
    @cat = cat
  end

  def location
    @cat[:location]
  end

  def type
    @cat[:type]
  end

  def price
    @cat[:price]
  end

  def image
    @cat[:image]
  end
end
