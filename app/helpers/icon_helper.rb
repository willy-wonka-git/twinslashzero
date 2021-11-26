module IconHelper
  def icon_svg(path, html_options = {})
    content_tag :i, html_options.merge(class: "#{html_options[:class]} d-inline-block") do
      inline_svg_tag path, class: "inline-icon d-inline-block", preserve_aspect_ratio: "xMaxYMax meet"
    end
  end
end
