class CommentsRepliesCache < CommentsCache
  private

  def fetch_comments(limit = 3)
    comments =
      Comment.joins(
        "INNER JOIN (
        #{Comment.select('id, row_number() OVER (PARTITION BY parent_comment_id
        ORDER BY created_at DESC) as date_order').to_sql}
        ) by_date
        ON by_date.id = comments.id"
      )
             .where(parent_comment_id: ids_to_query)
             .where("by_date.date_order <= #{limit}")
             .order(:post_id, created_at: :desc)

    comments.group_by(&:parent_comment_id)
  end
end