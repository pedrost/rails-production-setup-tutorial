class Option < ApplicationRecord
  belongs_to :poll

  def vote!
    self.increment_counter(:voted_times)
  end
end
