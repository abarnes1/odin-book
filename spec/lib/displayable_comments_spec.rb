require 'rails_helper'

class DisplayableCommentsTestClass
  def initialize
    extend DisplayableComments
  end

  def comments_count; end
  def likes; end
end

RSpec.describe DisplayableComments do
  subject!(:dummy_class) { DisplayableCommentsTestClass.new }

  let(:displayed_comment) { double('fake displayed comment') }
  let(:not_displayed_comment) { double('fake not displayed comment') }

  describe '#display_comments' do
    context 'when has no display comments' do
      it 'returns an empty array' do
        expect(dummy_class.display_comments).to eq([])
      end
    end

    context 'when assigned a single object' do
      it 'returns an array of objects' do
        dummy_class.display_comments = displayed_comment
        expect(dummy_class.display_comments).to eq([displayed_comment])
      end
    end

    context 'when assigned an array of objects' do
      it 'returns an array of comments' do
        comments = [displayed_comment, 'anything']
        dummy_class.display_comments = comments
        expect(dummy_class.display_comments).to eq(comments)
      end
    end
  end

  describe '#display_comments?' do
    context 'when has no display comments' do
      it 'returns false' do
        expect(dummy_class.display_comments?).to be false
      end
    end

    context 'when has display comments' do
      it 'returns true' do
        dummy_class.display_comments = displayed_comment
        expect(dummy_class.display_comments?).to be true
      end
    end
  end

  describe '#displayed_comments_count' do
    context 'when has no display comments' do
      it 'returns 0' do
        expect(dummy_class.displayed_comments_count).to eq(0)
      end
    end

    context 'when only some post comments are displayed' do
      it 'returns the correct count' do
        dummy_class.display_comments = displayed_comment
        allow(dummy_class).to receive(:comments_count).and_return(2)
        expect(dummy_class.displayed_comments_count).to eq(1)
      end
    end
  end

  describe '#not_displayed_comments_count' do
    before do
      dummy_class.display_comments = displayed_comment
    end

    context 'when all comments are displayed' do
      it 'returns 0' do
        allow(dummy_class).to receive(:comments_count).and_return(1)
        expect(dummy_class.not_displayed_comments_count).to eq(0)
      end
    end

    context 'when only some post comments are displayed' do
      it 'returns the correct count' do
        allow(dummy_class).to receive(:comments_count).and_return(2)
        expect(dummy_class.not_displayed_comments_count).to eq(1)
      end
    end
  end

  describe '#all_comments_displayed?' do
    before do
      dummy_class.display_comments = displayed_comment
    end

    context 'when all post comments are displayed' do
      it 'returns true' do
        allow(dummy_class).to receive(:comments_count).and_return(1)
        expect(dummy_class.all_comments_displayed?).to be true
      end
    end

    context 'when all post comments are not displayed' do
      it 'returns false' do
        allow(dummy_class).to receive(:comments_count).and_return(2)
        expect(dummy_class.all_comments_displayed?).to be false
      end
    end
  end

  describe '#oldest_display_comment' do
    context 'when no display comments' do
      it 'returns nil' do
        expect(dummy_class.oldest_display_comment).to be nil
      end
    end

    context 'when multiple display comments' do
      let!(:newer_comment) { double('Comment', created_at: 1.minute.ago) }
      let!(:older_comment) { double('Comment', created_at: 5.minutes.ago) }

      it 'returns the oldest comment' do
        dummy_class.display_comments = [newer_comment, older_comment]
        expect(dummy_class.oldest_display_comment).to eq(older_comment)
      end
    end
  end
end
