# Doesn't seem to work so the module is not in use.

module Top
  extend ActiveSupport::Concern

  def topn(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by { |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order.first(n)
  end
end