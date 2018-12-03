require "pry"

def consolidate_cart(cart) #cart is array of hashes in this method !!!
  consolidated_cart = {}

  cart.each do |item| #item is a hash
    item.each do |food, info| # e.g. {"TEMPEH"=>{:price=>3.0, :clearance=>true}}
      if consolidated_cart[food]
        consolidated_cart[food][:count] += 1
      else
        consolidated_cart[food] = info #set info for new item
        consolidated_cart[food][:count] = 1 #add count key and value
      end
    end
  end
  consolidated_cart #return cart
end

def apply_coupons(cart, coupons) #cart is hash of hashes !!! coupons is array of hashes
  coupons.each do |coupon|
    name = coupon[:item] # so you can refer to couponed_item by name
    if cart[name] && coupon[:num] <= cart[name][:count] # if coupon item exists in cart and the num of
        #THAT item in the cart is <= number of coupons for that iten
        if cart["#{name} W/COUPON"] #if a coupon has already been applied
          cart["#{name} W/COUPON"][:count] += 1 # just increment count of that particular couponed item
        else
          #create new couponed_item in cart if it does not already exist
          cart["#{name} W/COUPON"] = {count: 1, price: coupon[:cost], clearance: cart[name][:clearance]}
        end
        cart[name][:count] -= coupon[:num] # decrease count of item to just reflect non-couponed ones
    end
    #don't do anything if those base conditions aren't met
  end
  cart
end

def apply_clearance(cart) #returns cart with clearance items reduced by 20%
  #cart is hash of hashes!

  cart.each do |keys, values|
    if values[:clearance] == true
     new_price = values[:price] * 0.8
      values[:price] = new_price.round(2)
    end
  end
  cart
  # cart.each do |item| #a hash representing food item  => thought I was dealing with an array
  #   if item[1][:clearance]
  #     item[1][:price] = item[1][:price]*80/100
  #   end
  # end
  # cart
end

def checkout(cart, coupons)   # cart is array of hashes here !!!
   consolidated_cart = consolidate_cart(cart)   #consolidate cart
   couponed_cart = apply_coupons(consolidated_cart, coupons) # apply discount from coupons
   final_cart = apply_clearance(couponed_cart) # apply clearance

   total = 0
   final_cart.each do |name, properties| #final cart is a hash
     total += properties[:price] * properties[:count]
   end
   total = total * 0.9 if total > 100 #   #if total is over 100, apply 10% discount
   total
end
