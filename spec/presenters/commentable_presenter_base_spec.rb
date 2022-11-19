require 'rails_helper'

RSpec.describe CommentablePresenterBase do
  let(:thing) { double(class: Object, id: 99) }

  describe '#commentable' do
    it 'returns the commentable' do
      presenter = described_class.new(thing)
      expect(presenter.commentable).to be(thing)
    end
  end

  describe '#comments_container_id' do
    it 'returns the correct id' do
      presenter = described_class.new(thing)
      expect(presenter.comments_container_id).to eq("object_99_comments")
    end
  end

  describe '#load_comments_link_id' do
    it 'returns the correct id' do
      presenter = described_class.new(thing)
      expect(presenter.load_comments_link_id).to eq("object_99_load_comments")
    end
  end
end