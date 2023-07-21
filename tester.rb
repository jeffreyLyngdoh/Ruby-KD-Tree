require_relative 'kd-functions'
require 'securerandom'


tree = KDTree.new(4, 4)

tree.insert([12,4,2,1], 'kjasdiuash')
tree.insert([100,7,1,10], 'kjasdiuash')
tree.insert([42,2,7,1], 'kjasdiuash')
tree.insert([1,2,7,1], 'kjasdiuash')
tree.insert([7,2,56,1], 'kjasdiuash')


puts tree.toString()


puts tree.knn(6,[1,4,6,2])

