module DisplayComments
  extend ActiveSupport::Concern

  included do
    attr_writer :display_comments

    def display_comments
      @display_comments || []
    end
  end

  # class_methods do
  # end
end
