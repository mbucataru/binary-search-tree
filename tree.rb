require_relative 'node'
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?
    return Node.new(array[0]) if array.length == 1

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
    return if current_node.nil?

    # Recursive calls to go deeper in the tree
    if current_node.value > deletion_value
      delete(deletion_value, current_node.left_child, current_node)
      return
    elsif current_node.value < deletion_value
      delete(deletion_value, current_node.right_child, current_node)
      return
    end

    # This line is reached when we hit the node we want to delete
    delete_node(current_node, parent_node)
  end

  def delete_node(current_node, parent_node)
    if current_node.left_child.nil? && current_node.right_child.nil?
      delete_zero_child(current_node, parent_node)
    elsif current_node.left_child && current_node.right_child
      delete_double_child(current_node)
    else
      delete_single_child(current_node)
    end
  end

  def delete_zero_child(current_node, parent_node)
    @root = nil if parent_node.nil?
    parent_node.left_child = nil if parent_node.value > current_node.value
    parent_node.right_child = nil if parent_node.value < current_node.value
  end

  # Returns [successor, parent_of_successor]
  def find_successor(current_node, parent_node = nil)
    return [current_node, parent_node] if current_node.left_child.nil?

    find_successor(current_node.left_child, current_node)
  end

  def delete_double_child(current_node)
    successor_array = find_successor(current_node.right_child)
    successor, parent_of_successor = successor_array
    current_node.value = successor.value
    parent_of_successor.left_child = successor.right_child
  end

  def delete_single_child(current_node)
    if current_node.left_child
      current_node.value = current_node.left_child.value
      current_node.left_child = nil
    else
      current_node.value = current_node.right_child.value
      current_node.right_child = nil
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

  def level_order(&block)
    return nil if root.nil?

    queue = [root]

    if block
      apply_block(queue, block)
    else
      return_all_values_in_tree(queue)
    end

  end

  def apply_block(queue, block)
    until queue.empty?
      node = queue.shift
      block.call(node)
      queue.push(node.left_child) if node.left_child
      queue.push(node.right_child) if node.right_child
    end
  end

  def return_all_values_in_tree(queue)
    return_array = []
    until queue.empty?
      node = queue.shift
      return_array << node.value
      queue.push(node.left_child) if node.left_child
      queue.push(node.right_child) if node.right_child
    end
    return_array
  end
end

tree = Tree.new([20, 30, 50, 40, 32, 34, 36, 70, 60, 65, 80, 75, 85])
# [1, 2, 3, 4, 5, 6, 9, 12, 13]
tree.pretty_print
p tree.level_order
