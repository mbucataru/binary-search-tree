require_relative 'node'
class Tree
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return Node.new(array[0]) if array.length <= 1

    array.uniq!
    array.sort!
    midpoint = array.length / 2
    root = Node.new(array[midpoint])
    # Build left side of tree
    root.left_child = build_tree(array[0...midpoint])
    # Build right side of tree
    root.right_child = build_tree(array[midpoint + 1...array.length])
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

tree = Tree.new([1, 2, 3, 4])
# [0, 1, 3, 4, 5, 9]
tree.pretty_print
