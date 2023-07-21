require_relative 'kd-functions'



/An Entry in our data set/
class Datum

    attr_accessor :coordinates, :code

    def initialize(coordinates, code)
        @coordinates = coordinates
        @code = code
    end

    def to_s
        "Coordinates: #{coordinates}, Code: #{code}"
    end

    def compareTo(datum, index)

        while (self.coordinates.size > index)
            
            if(self.coordinates[index] > datum.coordinates[index])
                return 1

            elsif(self.coordinates[index] < datum.coordinates[index])
                return -1

            end

            index += 1
        end 

        i = 0

        while(i < index)

            if(self.coordinates[i] > datum.coordinates[i])
                return 1

            elsif(self.coordinates[i] < datum.coordinates[i])
                return -1

            end

            i += 1
        end

        return 0

    end

end

/Internal Node is a guide post meant to lead us to the leaf, contains a spliting value at a specific index dimension/
/Left and right childs are either more internal nodes or leaf nodes/
class NodeInternal

    attr_accessor :splitIndex, :splitValue, :leftchild, :rightchild


    def initialize(splitIndex, splitValue, leftchild = nil, rightchild = nil)

        @splitIndex = splitIndex
        @splitValue = splitValue
        @leftchild = leftchild
        @rightchild = rightchild

    end

end

/A leaf node with contains a list of Datum, this list will be less than or eqaul to leafsize /
class NodeLeaf

    attr_accessor :data

    def initialize(data)
        @data = data
    end


end

/This is the actual structure of the tree defining how many dimensions there are as well as max size of each node/
/The root is either a leaf or internal node/
class KDTree

    attr_accessor :dimensions, :leafsize, :root

    def initialize(dimensions, leafsize)
        @dimensions = dimensions
        @leafsize = leafsize
        @root = nil
    end

    def toString()
        return printing(root)
    end


    def insert(coordinate, code)

        @root = insertion(coordinate, code, @root, @dimensions, leafsize)

    end
    
    def delete(coordinate, code)
        @root = deletion(coordinate, code, @root)
    end

    
    def knn(numberofNeighbors, points)
        (checks, result) = knearestNeighbors(@root, points, @dimensions, numberofNeighbors, 0, [])
        return result, checks
    end


end



 


