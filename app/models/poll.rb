class Poll < ApplicationRecord
  has_many :options

  def viewed!
    self.increment!(:views)
  end
end
