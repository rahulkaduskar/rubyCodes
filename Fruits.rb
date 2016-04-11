require "yaml"

class Fruit
  attr_accessor :name, :quantity, :cost

  def initialize(item)
     @name = item[:name]
     @quantity = item[:quantity]
     @cost = item[:cost]
  end

  def self.suggest(fruits_list,amount)    
      suggested_items = []      
      fruits = fruits_list.sort_by{|fruit| fruit.cost}
      #finding fruit that can be purchased in the given amount
      suggested_items  << self.find_fruit_quantity(fruits,amount)
      puts suggested_items.flatten.join(" ")
  end

  def to_s
      "#{self.quantity}kg #{self.name} "
  end

  private

  def self.find_fruit_quantity(fruits,amount)        
    total_cost_each_one = fruits.inject(0){|sum,fruit| sum + fruit.cost }
    suggested_items = []
    fruit = fruits.shift
    min_cost_fruit = fruits.min_by{|fruit| fruit.cost}
    min_cost = (min_cost_fruit.nil? || (amount - fruit.cost) <= min_cost_fruit.cost  )   ? 0 : min_cost_fruit.cost
    quantity = ((amount - min_cost)/fruit.cost)
    if total_cost_each_one < amount
      quantity = ((amount - total_cost_each_one )/fruit.cost) 
      quantity = 1 if quantity == 0   
    end
    if (quantity < fruit.quantity)        
      if quantity >0        
        suggested_items << Fruit.new({name: fruit.name ,quantity: quantity, cost: fruit.cost  })  
        amount =  amount - (fruit.cost * quantity)
      end
      #finding fruit again form ramaining amount
      if !fruits.empty? && min_cost > 0
         suggested_items << self.find_fruit_quantity(fruits,amount)
      end
    end
    return suggested_items
  end

end

fruits = []
#reading fruits catalogue via yml file and creating list of fruits (list having fruit object)
data = YAML.load_file('fruits.yml')["fruits"]
data.each{ |item| fruits << Fruit.new(item.inject({}){|h,(k,v)| h.merge({ k.to_sym => v}) })}

#Calling suggest method of fruit class by passing fruits list and amount "
Fruit.suggest(fruits,20)
puts ">>>>>>>>>>>>>>>>>>>>>>>>>"
Fruit.suggest(fruits,16)
puts ">>>>>>>>>>>>>>>>>>>>>>>>>"
Fruit.suggest(fruits,51)
puts "=========================="
