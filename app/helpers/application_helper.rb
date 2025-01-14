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
end
