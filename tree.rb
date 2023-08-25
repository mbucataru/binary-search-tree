require_relative 'node'
class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
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

  def find(value)
    current_node = root
    loop do
      return nil if current_node.nil?
      return current_node if current_node.value == value

      current_node = if value > current_node.value
                       current_node.right_child
                     else
                       current_node.left_child
                     end
    end
    current_node
  end

  def level_order
    return nil if root.nil?

    queue = [root]

    if block_given?
      apply_block(queue)
    else
      return_all_values_in_tree(queue)
    end

  end

  def inorder(node = root, arr = [], &block)
    return arr if node.nil?

    inorder(node.left_child, arr, &block)

    if block_given?
      block.call(node)
    else
      arr << node.value
    end

    inorder(node.right_child, arr, &block)

    arr
  end

  def preorder(node = root, arr = [], &block)
    return arr if node.nil?

    if block_given?
      block.call(node)
    else
      arr << node.value
    end

    preorder(node.left_child, arr, &block)
    preorder(node.right_child, arr, &block)


  end

  def postorder(node = root, arr = [], &block)
    return arr if node.nil?

    postorder(node.left_child, arr, &block)
    postorder(node.right_child, arr, &block)

    if block_given?
      block.call(node)
    else
      arr << node.value
    end
  end

  def height(node)
    return -1 if node.nil?
    return 0 if node.left_child.nil? && node.right_child.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)

    left_height > right_height ? left_height + 1 : right_height + 1
  end

  def depth(target_node)
    current_node = root
    depth = 0
    loop do
      return nil if current_node.nil?
      return depth if current_node == target_node

      current_node = if target_node.value > current_node.value
                       current_node.right_child
                     else
                       current_node.left_child
                     end
      depth += 1
    end
  end

  def balanced?(node = root)
    return true if node.nil?

    left_height = height(node.left_child)
    right_height = height(node.right_child)

    return false if (left_height - right_height).abs > 1

    balanced?(node.left_child) && balanced?(node.right_child)
  end

  def rebalance
    array_of_node_values = inorder
    @root = build_tree(array_of_node_values)
  end

  private

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

  def apply_block(queue)
    until queue.empty?
      node = queue.shift
      yield(node)
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
