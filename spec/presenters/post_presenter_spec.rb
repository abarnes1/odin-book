require 'rails_helper'

RSpec.describe PostPresenter do
  let(:user) { build_stubbed(:user) }
  let(:post) { build_stubbed(:post, user: user) }

  describe '#post_id' do
    it 'returns the post id' do
      presenter = described_class.new(post)
      expect(presenter.post_id).to eq(post.id)
    end
  end

  describe '#comment_id' do
    it 'returns nil' do
      presenter = described_class.new(post)
      expect(presenter.comment_id).to be_nil
    end
  end

  describe '#load_comments_link_text' do
    it 'returns the correct string' do
      not_displayed_count = 99
      presenter = described_class.new(post)
      allow(presenter).to receive(:not_displayed_comments_count).and_return(not_displayed_count)
      
      expected = "View Comments (#{not_displayed_count})"
      expect(presenter.load_comments_link_text).to eq(expected)
    end
  end
end
