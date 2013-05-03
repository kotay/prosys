# ProSys Ruby Client

##This is an attempt at a Ruby client for ProVu's ProSys API
```ruby
require 'prosys'

client = Prosys::Client.new(:username =>"username", :password => "password", :debug => true, :testing => true)
```
##Methods
```ruby
## Create an order
# setting the :testing => true will not create a real order
order = {
  :order_ref    => "TESTING",
  :name         => "TESTING",
  :c_name       => "Happy House",
  :address      => "41 Nevison avenue Chelmsford",
  :postcode     => "CY22 6EB",
  :phone        => "+4423239281",
  :rj_adaptors  => "on",
  :saturday     => "no",
  :lines        => [
    {:item => "PVSnom360", :quantity => "0"}
  ]
}
client.create_order(order)
# => "000 - success"

## Price list
client.price_list
# => {"item"=>"extwar3/T32G", "description"=>"3 years extended warranty on the Yealink T32G", "class"=>"yealinkserv", "subclass"=>"extwarr", "retail_price"=>"11.48", "price_each"=>"9.18", "free_stock"=>nil, "weight"=>nil, "ean"=>nil, "mpn"=>nil}, {"item"=>"extwar3/T38G", "description"=>"3 years extended warranty on the Yealink T38G", "class"=>"yealinkserv", "subclass"=>"extwarr", "retail_price"=>"14.02", "price_each"=>"11.21", "free_stock"=>nil, "weight"=>nil, "ean"=>nil, "mpn"=>nil}, {"item"=>"extwar3/VP2009PE", "description"=>"3 years extended warranty on the Yealink VP2009PE", "class"=>"yealinkserv", "subclass"=>"extwarr", "retail_price"=>"23.03", "price_each"=>"18.43", "free_stock"=>nil, "weight"=>nil, "ean"=>nil, "mpn"=>nil} 

## Order History
client.order_history
# => {"ordid"=>"25220", "date"=>"2011-09-19", "cusRefnum"=>"20110919", "delName"=>nil, "delCName"=>nil, "Address"=>nil, "Postcode"=>nil, "done"=>"yes"}

## Stock
item = "PVSnom370"
client.item(item)
# => {"item"=>"PVSnom370", "description"=>"Snom 370 VoIP Telephone (with PoE and UK PSU)", "class"=>"snom", "subclass"=>nil, "retail_price"=>"__", "price_each"=>"__", "free_stock"=>"80", "weight"=>"1.585", "ean"=>"4260059580144", "mpn"=>"00003039"}
client.in_stock?(item)
# => true
client.weight?(item)
# => "1.585"
client.price?(item)
# => "179.00"

## Orders
order_id = "42095"

client.order(order_id)
# => "ordid"=>"42095", "acode"=>"__", "contact"=>"Mr Happy", "DateTime"=>"2013 May 03  14:51:09", "type"=>"fulfil", "total"=>nil, "lui"=>nil, "currency"=>"UK", "VATRate"=>"20", "delivery"=>nil, "done"=>"cancelled", "released"=>"yes", "cusRefNum"=>"286", "delName"=>"Mr Happy", "delCName"=>"Happy House", "delAddress"=>"__", "delPostcode"=>"__", "delPhone"=>"+4423239281", "Saturday"=>"no", "Collection"=>"no", "Orderlines"=>{"line"=>{"item"=>"PVSnom360", "description"=>"Snom360 VoIP Telephone (with PoE and UK PSU)", "quantity"=>"1", "price"=>"__", "total"=>"__", "ordlid"=>"73227", "quantity_outstand"=>"1"}}, "deliveries"=>nil}
client.order_status(order_id)
# => "cancelled"
client.order_released(order_id)
# => "yes"

cust_ref_id = "286"
client.order_by_ref(cust_ref_id)
# => [same as client.order(order_id) but using the ref you provide]
