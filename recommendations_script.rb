@recommendations = []

looked_nodes = []
queue = [current_user]
costs = { current_user.uuid => 0 }

known_nodes = neighbour_nodes(current_user).map(&:first) << current_user

begin
  current_node = queue.delete_at(0)
  current_cost = costs[current_node.uuid]

  looked_nodes << current_node.uuid

  if current_node.class.in?(RECOMMENDATION_TYPES) && !current_node.in?(known_nodes)
    @recommendations << current_node
    break if @recommendations.size == RECOMMENDATIONS_LIMIT
  end

  neighbour_nodes(current_node).each do |node_with_cost|
    node, cost = node_with_cost

    next if node.uuid.in? looked_nodes

    if costs[node.uuid]
      costs[node.uuid] += (current_cost + cost) / 2
    else
      queue << node
      costs[node.uuid] = current_cost + cost
    end
  end

  queue.sort! { |a, b| costs[b.uuid] <=> costs[a.uuid] }
end while queue.any?

if @recommendations.empty?
  @recommendations = Neo4j::Session.query(
      "MATCH n,
                 (i { uuid: {my_id} }),
                 (n)-[r]-(x)
            WHERE ((NOT (i)-[]-(n)) OR ((x = i) AND (TYPE(r) = 'sent_message_to'))) AND
                  n <> i AND
                  n._classname in {recommendation_types}
            WITH n, COUNT(x) as rate
            ORDER BY rate DESC
            LIMIT {recommendations_count}
            RETURN n",
      my_id: current_user.id,
      recommendation_types: RECOMMENDATION_TYPES.map(&:name),
      recommendations_count: RECOMMENDATIONS_LIMIT
  ).map(&:first)
end
