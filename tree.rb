require_relative 'node'
class Tree
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    array.uniq!.sort!
    root = array[array.length / 2]

    # Build right side of tree
    build_tree(array[0...root])
    # Build left side of tree
    build_tree(array[root + 1...array.length])

    root
  end
end
