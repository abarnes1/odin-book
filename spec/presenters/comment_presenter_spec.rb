require 'rails_helper'

RSpec.describe CommentPresenter do
  let(:user) { build_stubbed(:user) }
  let(:post) { build_stubbed(:post, user: user) }
  let(:comment) { build_stubbed(:comment, post: post, user: user) }

  describe '#display_depth' do
    context 'when given a display depth' do
      it 'returns the display depth' do
        display_depth = 99
        presenter = described_class.new(comment, display_depth: display_depth)
        expect(presenter.display_depth).to eq(display_depth)
      end
    end

    context 'when not given a display depth' do
      it 'returns the default display depth' do
        presenter = described_class.new(comment)
        expect(presenter.display_depth).to eq(described_class::DEFAULT_DISPLAY_DEPTH)
      end
    end
  end

  describe '#comment_id' do
    it 'returns the comment id' do
      presenter = described_class.new(comment)
      expect(presenter.comment_id).to eq(comment.id)
    end
  end

  describe '#display_comments_turbo_method' do
    it 'returns append' do
      presenter = described_class.new(comment)
      expect(presenter.display_comments_turbo_method).to eq(:append)
    end
  end

  describe '#max_display_depth?' do
    context 'when display depth is below the maximum' do
      it 'returns false' do
        presenter = described_class.new(comment, display_depth: described_class::MAX_DISPLAY_DEPTH - 1)
        expect(presenter.max_display_depth?).to be(false)
      end
    end

    context 'when display depth is equal to the maximum' do
      it 'returns true' do
        presenter = described_class.new(comment, display_depth: described_class::MAX_DISPLAY_DEPTH)
        expect(presenter.max_display_depth?).to be(true)
      end
    end

    context 'when display depth is above to the maximum' do
      it 'returns true' do
        presenter = described_class.new(comment, display_depth: described_class::MAX_DISPLAY_DEPTH + 1)
        expect(presenter.max_display_depth?).to be(true)
      end
    end
  end

  describe '#load_comments_link_text' do
    context 'when under max display depth' do
      it 'returns the correct string' do
        not_displayed_comments = 99
        presenter = described_class.new(comment)
        allow(presenter).to receive(:not_displayed_comments_count).and_return(not_displayed_comments)
        allow(presenter).to receive(:max_display_depth?).and_return(false)

        expected = "\u2937 #{not_displayed_comments} More Replies"
        expect(presenter.load_comments_link_text).to eq(expected)
      end
    end

    context 'when at max display depth' do
      it 'returns the correct string' do
        presenter = described_class.new(comment)
        allow(presenter).to receive(:max_display_depth?).and_return(true)

        expected = "\u2937 Continue Conversation"
        expect(presenter.load_comments_link_text).to eq(expected)
      end
    end
  end

  describe '#comment_form_id' do
    context 'when comment has an id' do
      it 'returns the comment form id' do
        presenter = described_class.new(comment)
        expected = "comment_#{comment.id}_comment_form"
        expect(presenter.comment_form_id).to eq(expected)
      end
    end

    context 'when comment has no id' do
      context 'when comment has a parent comment id' do
        it 'returns the parent comment form id' do
          presenter = described_class.new(comment)
          allow(presenter).to receive(:id?).and_return false
          allow(presenter).to receive(:parent_comment_id?).and_return true
          allow(presenter).to receive(:parent_comment_id).and_return 99
          expected = "comment_99_comment_form"
          expect(presenter.comment_form_id).to eq(expected)
        end
      end

      context 'when comment has no parent comment id' do
        it 'return the post form id' do
          presenter = described_class.new(comment)
          allow(presenter).to receive(:id?).and_return false
          allow(presenter).to receive(:parent_comment_id?).and_return false
          expected = "post_#{comment.post_id}_comment_form"
          expect(presenter.comment_form_id).to eq(expected)
        end
      end
    end
  end
end
