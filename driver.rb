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

            puts "Please select how many dimentions you want"
            dimensions = gets.chomp.to_i

            tree = KDTree.new(dimensions, leafsize)
        
        when 2

            if(tree == nil)
                puts "Please create a tree first"

            else 
                puts "Please Insert list of coordinates seperted by comma, must be of size #{tree.dimensions}"
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
                puts "Please Insert list of coordinates seperted by comma, must be of size #{tree.dimensions}"
                coord = gets.chomp.split(",").map(&:to_i)

                puts "Assign a code to this entry, must be a string"
                code = gets.chomp

                tree.delete(coord, code)
            end
            
        when 5
            puts "Which coordintates are you looking for (must be size #{tree.dimensions} seperated by commas)"
            coord = gets.chomp.split(",").map(&:to_i)

            puts "How many neigbor points are you looking for"
            neigbor = gets.chomp.to_i

            result, checks = tree.knn(neigbor, coord)

            puts "Checked #{checks} leaves"
            
            result.each do |hash|
                hash.each_pair do |key, value|
                  puts "#{key} => Squared distance: #{value}"
                end
            end

        when 6
            puts tree.toString()
    
        else 
            puts "Invalid Option"
        end

        puts prompt
        option = gets.chomp.to_i
    end

    puts "Thank you for testing!"

end


driver()





