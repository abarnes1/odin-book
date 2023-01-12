class ApplicationController < ActionController::Base
  def render_flash_turbo
    render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash')
  end
end
