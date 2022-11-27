require 'rails_helper'

RSpec.describe CommentablePresenterBase do
  let(:thing) { double(class: Object, id: 99) }

  describe '#commentable' do
    it 'returns the commentable' do
      presenter = described_class.new(thing)
      expect(presenter.commentable).to be(thing)
    end
  end

  context 'when given a displayed count' do
    it 'returns the correct count' do
      display_count = 99
      presenter = described_class.new(thing, displayed_count: display_count)
      expect(presenter.displayed_comments_count).to eq(display_count)
    end
  end

  describe '#display_depth' do
    it 'returns nil' do
      presenter = described_class.new(thing)
      expect(presenter.display_depth).to be_nil
    end
  end

  describe '#comments_container_id' do
    it 'returns the correct id' do
      presenter = described_class.new(thing)
      expect(presenter.comments_container_id).to eq("object_99_comments")
    end
  end

  describe '#new_comments_container_id' do
    it 'returns the correct id' do
      presenter = described_class.new(thing)
      expect(presenter.new_comments_container_id).to eq("object_99_new_comments")
    end
  end

  describe '#comments_counter_container_id' do
    it 'returns the correct id' do
      presenter = described_class.new(thing)
      expect(presenter.comments_counter_container_id).to eq("object_99_comments_counter")
    end
  end

  describe '#load_comments_link_id' do
    it 'returns the correct id' do
      presenter = described_class.new(thing)
      expect(presenter.load_comments_link_id).to eq("object_99_load_comments")
    end
  end

  describe '#comment_form_id' do
    it 'returns the correct id' do
      presenter = described_class.new(thing)
      expect(presenter.comment_form_id).to eq("object_99_comment_form")
    end
  end
end