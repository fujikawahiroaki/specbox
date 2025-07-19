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

  def collection_settings_url_with_ranmemory(options = {})
    ranmemory_state = session[:ranmemory_collection_settings_index_html] || {}

    sort = options[:sort] || session[:collection_settings_index_sort]
    direction = options[:direction] || session[:collection_settings_index_direction]
    page = options[:page] || session[:collection_settings_index_page]

    options = options.merge({
      sort: sort,
      direction: direction,
      page: page
    })

    collection_settings_url(options.merge(ranmemory_state))
  end

  def collect_points_url_with_ranmemory(options = {})
    ranmemory_state = session[:ranmemory_collect_points_index_html] || {}

    sort = options[:sort] || session[:collect_points_index_sort]
    direction = options[:direction] || session[:collect_points_index_direction]
    page = options[:page] || session[:collect_points_index_page]

    options = options.merge({
      sort: sort,
      direction: direction,
      page: page
    })

    collect_points_url(options.merge(ranmemory_state))
  end

  def custom_taxa_url_with_ranmemory(options = {})
    ranmemory_state = session[:ranmemory_custom_taxa_index_html] || {}

    sort = options[:sort] || session[:custom_taxa_index_sort]
    direction = options[:direction] || session[:custom_taxa_index_direction]
    page = options[:page] || session[:custom_taxa_index_page]

    options = options.merge({
      sort: sort,
      direction: direction,
      page: page
    })

    custom_taxa_url(options.merge(ranmemory_state))
  end

  def default_taxa_url_with_ranmemory(options = {})
    ranmemory_state = session[:ranmemory_default_taxa_index_html] || {}

    sort = options[:sort] || session[:default_taxa_index_sort]
    direction = options[:direction] || session[:default_taxa_index_direction]
    page = options[:page] || session[:default_taxa_index_page]

    options = options.merge({
      sort: sort,
      direction: direction,
      page: page
    })

    default_taxa_url(options.merge(ranmemory_state))
  end

  def specimens_url_with_ranmemory(options = {})
    ranmemory_state = session[:ranmemory_specimens_index_html] || {}

    sort = options[:sort] || session[:specimens_index_sort]
    direction = options[:direction] || session[:specimens_index_direction]
    page = options[:page] || session[:specimens_index_page]

    options = options.merge({
      sort: sort,
      direction: direction,
      page: page
    })

    specimens_url(options.merge(ranmemory_state))
  end
end
