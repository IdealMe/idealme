module TimeAgoHelper

  def abbreviated_time_ago(from)
    out = time_ago_in_words(from, include_seconds: true)
    out.sub!(/(inute|our|ay|ear|onth)s*/, "")
    out.sub!(/about/, '')
    out.gsub!(/ /, '')
  end

end
