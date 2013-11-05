module ExpandingTextHelper

  def expandable_text(text, limit = 100)

    content_tag(:div, class: 'expandable-text') do
      if text.length > limit
        concat(long_text(text))
        concat less_link
        concat(short_text(text.truncate(limit)))
        concat more_link
      else
        concat text
      end
    end.html_safe
  end

  def long_text(text)
    content_tag(:span, "#{text} ".html_safe, class: "hidden long-text")
  end

  def short_text(text)
    content_tag(:span, "#{text} ".html_safe, class: "short-text")
  end

  def more_link
    content_tag :span, "more", class: 'more-link'
  end

  def less_link
    content_tag :span, "less", class: 'less-link hidden'
  end

end