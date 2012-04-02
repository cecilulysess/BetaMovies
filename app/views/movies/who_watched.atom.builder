atom_feed do |feed|
	feed.title "谁正在追 #{@movie.title}"
	
	latest_tracking_item = @movie.tracking_items.sort_by(&:updated_at).last
	feed.updated( latest_tracking_item && latest_tracking_item.updated_at )
	
	@movie.tracking_items.each do |item|
		feed.entry(item) do |entry|
			entry.title "item_id #{item.id}"
		end
	end
end