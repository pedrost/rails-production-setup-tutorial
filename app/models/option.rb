class Option < ApplicationRecord
  belongs_to :poll

  def vote!
    self.increment!(:voted_times)
  end
end
