require_relative 'tree'

tree = Tree.new((Array.new(15) { rand(1..100) }))
p tree.balanced?
p tree.level_order
p tree.inorder
p tree.preorder
p tree.postorder
10.times do |num|
  tree.insert(num + 100)
end
p tree.balanced?
tree.rebalance
p tree.balanced?
p tree.level_order
p tree.inorder
p tree.preorder
p tree.postorder
