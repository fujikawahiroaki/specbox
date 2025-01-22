module ApplicationHelper
  # ソート昇順・降順の切り替え
  def toggle_direction(field)
    if params[:sort] == field && params[:direction] == "asc"
      "desc"
    else
      "asc"
    end
  end

  def sort_icon(field)
    if params[:sort] == field && params[:direction] == "asc"
      # 昇順の場合は ▲ を表示
      content_tag(:span, "▲", class: "ml-2")
    elsif params[:sort] == field && params[:direction] == "desc"
      # 降順の場合は ▼ を表示
      content_tag(:span, "▼", class: "ml-2")
    else
      # それ以外の場合は何も表示しない
      ""
    end
  end

  def tours_url_with_ranmemory(options = {})
    ranmemory_state = session[:ranmemory_tours_index_html] || {}

    logger.debug(ranmemory_state)

    sort = options[:sort] || session[:tours_index_sort]
    direction = options[:direction] || session[:tours_index_direction]
    page = options[:page] || session[:tours_index_page]

    options = options.merge({
      sort: sort,
      direction: direction,
      page: page
    })

    tours_url(options.merge(ranmemory_state))
  end
end
