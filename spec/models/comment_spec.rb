require 'rails_helper'
require_relative 'concerns/shared/pageable'

RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it_behaves_like Pageable
end
