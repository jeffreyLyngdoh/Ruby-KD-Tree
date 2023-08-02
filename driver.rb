require_relative 'kd-functions'
require 'securerandom'



def driver()
    prompt = "0 - Quit, 1 - Create Tree, 2 - Insert Single, 3 - Insert Mass random, 4 - Delete Entry, 5 - K-Nearest Neighbor, 6 - Print JSON"

    puts prompt
    option = gets.chomp.to_i

    tree = nil

    while (option != 0)

        case option

        when 1
            puts "Please select a leaf size"
            leafsize = gets.chomp.to_i

            while leafsize <= 0
                puts "Please Select a valid leaf size greater than 0 less than 100"
                leafsize = gets.chomp.to_i

            end

            puts "Please select how many dimentions you want"
            dimensions = gets.chomp.to_i

            while dimensions <= 0
                puts "Please Select a valid number of dimensions greater than 0 less than 100"
                leafsize = gets.chomp.to_i

            end

            tree = KDTree.new(dimensions, leafsize)
        
        when 2

            if(tree == nil)
                puts "Please create a tree first"

            else 
                puts "Please Insert list of coordinates seperted by comma, must be of size #{tree.dimensions} ex 6,4,2,..."
                coord = gets.chomp.split(",").map(&:to_i)

                puts "Assign a code to this entry, must be a string"
                code = gets.chomp


            end

        when 3

            if tree == nil
                puts "Create a tree first"
            
            else 
                puts "How many entries do you want to insert"
                size = gets.chomp.to_i

                while size <= 0
                    puts "Invaild mass insertion size must be postive"
                    size = gets.chomp.to_i

                end


    
                for i in 1..size
                    coord = Array.new(tree.dimensions) { rand(1000) } 
                    code = SecureRandom.hex(5)

                    puts "Inserting Coordintates #{coord}, with code #{code}"
                    tree.insert(coord, code)
                end

            end

        when 4
            if tree == nil
                puts "Create a tree first"
            else 
                puts "Please Insert list of coordinates seperted by comma, must be of size #{tree.dimensions} ex 6,4,2,..."
                coord = gets.chomp.split(",").map(&:to_i)

                puts "Assign a code to this entry, must be a string"
                code = gets.chomp

                tree.delete(coord, code)
            end
            
        when 5

            if tree == nil
                puts "Create a tree first"
            else
                puts "Which coordintates are you looking for (must be size #{tree.dimensions} seperated by commas) ex 6,4,2,..."
                coord = gets.chomp.split(",").map(&:to_i)
    
                puts "How many neigbor points are you looking for"
                neigbor = gets.chomp.to_i
                
                while neigbor <= 0 || neigbor > 100
                    puts "Invalid number of neigbor keep between 1 and 100"
                    neigbor = gets.chomp.to_i

                end


                result, checks = tree.knn(neigbor, coord)
    
                puts "Checked #{checks} leaves"
                
                result.each do |hash|
                    hash.each_pair do |key, value|
                      puts "#{key} => Squared distance: #{value}"
                    end
                end
            end

        when 6
            if tree == nil
                puts "Create a tree first"
            else
                puts tree.toString()

            end

    
        else 
            puts "Invalid Option"
        end

        puts prompt
        option = gets.chomp.to_i
    end

    puts "Thank you for testing!"

end


driver()





