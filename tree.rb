require_relative 'node'
class Tree
  attr_reader :root

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

  def insert(value)
    current_root = root
    loop do
      if value > current_root.value && current_root.right_child.nil?
        current_root.right_child = Node.new(value)
        return
      elsif value > current_root.value
        current_root = current_root.right_child
      elsif current_root.left_child.nil?
        current_root.left_child = Node.new(value)
        return
      else
        current_root = current_root.left_child
      end
    end
  end

  # Scenario one: No children:
  #   Simply set deletion node to nil
  # Scenario two: One Child:
  #   Copy the value of the child to the deletion node
  #   Set old child to null and blank out its parent's child
  # Scenario three: Two children:
  #   Find its order successor
  #   Copy the value of the order successor to the deletion node
  #   Set the old child to null and blank out its parent's child
  def delete(deletion_value, current_node = @root, parent_node = nil)
    return current_node if current_node.nil?

    # Recursive calls to go deeper in the tree
    if current_node.value > deletion_value
      current_node.left_child = delete(deletion_value, current_node.left_child, current_node)
      return current_node
    elsif current_node.value < deletion_value
      current_node.right_child = delete(deletion_value, current_node.right_child, current_node)
      return current_node
    end
    # We exit the if else statement when we hit the value

    # If the deletion node has no children
    if current_node.left_child.nil? && current_node.right_child.nil?
      parent_node.left_child = nil if parent_node.value > current_node.value
      parent_node.right_child = nil if parent_node.value < current_node.value
      # If deletion node has two children
    elsif current_node.left_child && current_node.right_child

      # If deletion node has one child
    else
      if current_node.left_child
        current_node.value = current_node.left_child.value
        current_node.left_child = nil
      else
        current_node.value = current_node.right_child.value
        current_node.right_child = nil
      end
    end
    current_node
  end

  def find(value)
    current_node = root
    loop do
      return current_node if current_node.value == value
      return nil if current_node.nil?

      current_node = if value > current_node.value
                       current_node.right_child
                     else
                       current_node.left_child
                     end
    end
    current_node
  end
end

tree = Tree.new([3, 6])
# [0, 1, 3, 4, 5, 9]
tree.insert(2)
tree.insert(1)
tree.pretty_print
tree.delete(2)
tree.pretty_print
