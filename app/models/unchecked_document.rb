class UncheckedDocument < ApplicationRecord
  belongs_to :document
  belongs_to :client
end