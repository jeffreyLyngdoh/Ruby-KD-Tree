require_relative 'kd-tree'



def printing(root)

    result = ""

    if root.instance_of?(NodeLeaf)

        result = "{\"Data\" : ["

        for entry in root.data
            result += "{\"Coordinates\":\"(#{entry.coordinates.join(',')})\", \"Code\":\"#{entry.code}\"},"

        end

        result = result.chop()
        
        result += ']'
        result += '}'

    elsif root.instance_of?(NodeInternal)
        result = "{\"SplitIndex\" : #{root.splitIndex}, \"SplitValue\" : #{root.splitValue}, \"LeftChild\" : #{printing(root.leftchild)}, \"RightChild\" : #{printing(root.rightchild)}}"
    
    else
        result = "{}"
    end


    return result
end


def insertion(coordinate, code, root, dimensions, leafsize)

    if root.instance_of?(NodeLeaf)
        root.data.push(Datum.new(coordinate, code))
        
        if (root.data.size > leafsize)
            root = split(root, dimensions)

        end

    elsif root.instance_of?(NodeInternal)
        if(coordinate[root.splitIndex] >= root.splitValue)
            root.rightchild = insertion(coordinate, code, root.rightchild, dimensions, leafsize)

        else
            root.leftchild = insertion(coordinate, code, root.leftchild, dimensions, leafsize)

        end
    
    else
        root = NodeLeaf.new([])
        root.data.push(Datum.new(coordinate, code))
    end

    return root
end

/Splits based on largest spread/
def split(root, dimensions)
    
    /Determine column with largest spread/
    points = root.data.map { |entry| entry.coordinates }

    largest_spread_index = 0
    largest_spread = 0
    
    transposed_array = points.transpose
    
    transposed_array.each_with_index do |column, index|
      min = column.min
      max = column.max
      spread = max - min
    
      if spread > largest_spread
        largest_spread = spread
        largest_spread_index = index
      end
    end
    
    /Sorting based on this column index/
    root.data = root.data.sort{ |a,b| a.compareTo(b, largest_spread_index)}
    
    /Splitting/
  
    n = root.data.size
    mid = n / 2
    median = 0

    if (n % 2 == 0)

        median = (root.data[mid].coordinates[largest_spread_index] + root.data[mid - 1].coordinates[largest_spread_index]) / 2
        
    else
        median = root.data[mid].coordinates[largest_spread_index]

    end

    parent = NodeInternal.new(largest_spread_index, median)
    parent.leftchild = NodeLeaf.new(root.data.slice(0,mid))
    parent.rightchild = NodeLeaf.new(root.data.slice(mid, n))

    return parent
end


def deletion(coordinate, code, root)

    if root.instance_of?(NodeLeaf)

        root.data.delete_if do |entry|
            entry.code == code && entry.coordinates == coordinate
        end

        if root.data.size <= 0
            root = nil
        end

    elsif root.instance_of?(NodeInternal)

        if (coordinate[root.splitIndex] > root.splitValue)

            root.rightchild = deletion(coordinate, code, root.rightchild)

        elsif (coordinate[root.splitIndex] < root.splitValue)

            root.leftchild = deletion(coordinate, code, root.leftchild)

        else 
            root.rightchild = deletion(coordinate, code, root.rightchild)
            root.leftchild = deletion(coordinate, code, root.leftchild)

        end

        
        if root.leftchild == nil
            return root.rightchild

        elsif root.rightchild == nil
            return root.leftchild

        end


    end

    return root

end

def boxdistance(box, point)

    sum = 0
    index = 0

    for entry in box 

        min, max = entry

        if point[index] < min
            sum += (min - point[index]) ** 2

        elsif point[index] > max
            sum += (point[index] - max) ** 2    

        end


        index += 1
    end

    return sum
end


def boundingBox(root, dimension)

    result = []

    if root.instance_of?(NodeLeaf)
       
        for i in 0..dimension - 1
            list = []

            for entry in root.data
                list.push(entry.coordinates[i])
            end
            
            result.push([list.min, list.max])

        end
    
    elsif root.instance_of?(NodeInternal)

        leftbox = boundingBox(root.leftchild, dimension)
        rightbox = boundingBox(root.rightchild, dimension)

        for i in 0..dimension - 1
            a = [leftbox[i][0], rightbox[i][0]].min
            b = [leftbox[i][1], rightbox[i][1]].max

            result.append([a, b])
        end

    
    end

    return result
end

def knearestNeighbors(root, points, dimension, numberofNeighbors, checks, result)

    if root.instance_of?(NodeLeaf)
        
        for entry in root.data

            dictionary = {}
            dictionary[entry] = distancePoint(entry.coordinates, points, dimension)
            result.push(dictionary)
        end
        result = result.sort_by { |item| item.values.first }
        result = result.take(numberofNeighbors)
        checks += 1

    elsif root.instance_of?(NodeInternal)
        leftbox = boundingBox(root.leftchild, dimension)
        rightbox = boundingBox(root.rightchild, dimension)

        leftdistance = boxdistance(leftbox, points)
        rightdistance = boxdistance(rightbox, points)
        
        distance = result.size == 0 ? 0 : result[-1].values.first

        if(result.size >= numberofNeighbors && distance < leftdistance && distance < rightdistance)
            return checks, result

        elsif (leftdistance <= rightdistance)
            checks, result = knearestNeighbors(root.leftchild, points, dimension, numberofNeighbors, checks, result)
            distance = result.size == 0 ? 0 : result[-1].values.first
            
            if(result.size < numberofNeighbors || rightdistance <= distance)
                checks, result = knearestNeighbors(root.rightchild, points, dimension, numberofNeighbors, checks, result)
            end

        else
            checks, result = knearestNeighbors(root.rightchild, points, dimension, numberofNeighbors, checks, result)
            distance = result.size == 0 ? 0 : result[-1].values.first

            if(result.size < numberofNeighbors || leftdistance <= distance)
                checks, result = knearestNeighbors(root.leftchild, points, dimension, numberofNeighbors, checks, result)
            end
        end
    end

    return checks, result
end

def distancePoint(rootpoints, points, dimension)

    sum = 0
    for index in 0..(dimension - 1)
        
        sum += (rootpoints[index] - points[index]) ** 2
    end

    return sum

end
