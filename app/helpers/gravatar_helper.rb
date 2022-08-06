module GravatarHelper
  # Use helper due to unresolved bug in gem
  # https://github.com/mdeering/gravatar_image_tag/pull/35
  def gravatar_url(email, size = 80, default = 'retro')
    hash = Digest::MD5.hexdigest(email)
    "https://secure.gravatar.com/avatar/#{hash}.png?size=#{size}&default=#{default}"
  end

  def gravatar_tag(email = 'nothing', size: 80)
    "<img alt='Gravatar' src='#{gravatar_url(email)}' width='#{size}' height='#{size}'>".html_safe
  end
end