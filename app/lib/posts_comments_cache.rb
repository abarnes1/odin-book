class PostsCommentsCache < CommentsCache
  private

  def fetch_comments(limit = 3)
    comments =
      Comment.joins(
        "INNER JOIN (
        #{Comment.top_level.select('id, row_number() OVER (PARTITION BY post_id
        ORDER BY created_at DESC) as date_order').to_sql}
        ) by_date
        ON by_date.id = comments.id"
      )
             .where(post_id: ids_to_query)
             .where("by_date.date_order <= #{limit}")
             .order(created_at: :desc)

    comments.group_by(&:post_id)
  end
end
