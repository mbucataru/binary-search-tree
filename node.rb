class Node
  include Comparable

  attr_accessor :value, :left_child, :right_child

  def initialize(value = nil)
    @value = value
    @left_child = nil
    @right_child = nil
  end
end
