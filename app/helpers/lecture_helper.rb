module LectureHelper

  def lecture_icon(lecture)
    icon = case lecture.lecture_type
           when :document
             "icon-book"
           when :video
             "icon-film"
           when :archive
             "icon-archive"
           when :audio
             "icon-music"
           else
             "icon-expand"
           end

    content_tag :i, "", class: icon
  end

end
