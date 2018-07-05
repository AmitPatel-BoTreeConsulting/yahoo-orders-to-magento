class YahooToMagentoOrders
  def self.convert(orders_csv, orders_products_csv, orders_status_csv)
    puts "[START]"
    all_order_items = ""
    rowCount = 1
    orders = SmarterCSV.process(orders_csv)
    puts "orders.csv loaded"
    ordersProducts = SmarterCSV.process(orders_products_csv)
    puts "orders_products.csv loaded"
    ordersStatus = SmarterCSV.process(orders_status_csv)
    puts "orders_status.csv loaded"
    puts "Starting Merge"

    orders.each do |row|

      orderSkuData = ""
      weMatched = false
      ordersProducts.each do |rowProduct|

        if row[:order_id].to_s == rowProduct[:order_id].to_s
          puts "MATCH ROW FOR ORDER #" + row[:order_id].to_s + " PRODUCTS: " + rowProduct[:product_code].to_s
          #build the sku's per order here
          weMatched = true
          orderSkuData << rowProduct[:product_code].to_s + ":" + rowProduct[:quantity].to_s + ":" + rowProduct[:unit_price].gsub("$", "").to_s + ":" + rowProduct[:product_id].to_s + "|"
        else
          #puts "NO MATCH"
          break if weMatched == true
        end

      end
      #puts "DONE MATCHING PRODUCTS"
      #get order totals data
      weMatchedTotal = false
      #puts "DONE MATCHING FOR ORDER TOTAL"

      if row[:shipping].to_s != ""
        shipping_description = row[:shipping].to_s
      else
        shipping_description = ""
      end

      if row[:shipping_charge].to_s != ""
        finalOrderShippingTotal = row[:shipping_charge].gsub("$", "").to_s
      else
        finalOrderShippingTotal = ""
      end

      if row[:promotion_discount].to_s != ""
        finalOrderDiscount = row[:promotion_discount].gsub("$", "").to_s
      else
        finalOrderDiscount = ""
      end

      if row[:total].to_s != ""
        finalOrderGrandTotal = row[:total].gsub("$", "").to_s
      else
        finalOrderGrandTotal = ""
      end

      if row[:tax_charge].to_s != ""
        finalOrderTaxTotal = row[:tax_charge].gsub("$", "").to_s
      else
        finalOrderTaxTotal = ""
      end

      if finalOrderGrandTotal != ""
        finalOrderSubTotal = finalOrderGrandTotal.to_f - finalOrderShippingTotal.to_f - finalOrderTaxTotal.to_f
      else
        finalOrderSubTotal = ""
      end

      #convert status ID to text value

      orders_status_final = ""
      weMatchedStatus = false
      ordersStatus.each do |rowStatus|

        if row[:order_id].to_s == rowStatus[:order_id].to_s
          puts "MATCH ROW FOR ORDER #" + row[:order_id].to_s + " STATUS: " + rowStatus[:statusmark].to_s
          #build the sku's per order here
          weMatchedStatus = true
          if rowStatus[:statusmark].to_s == "OK"
            orders_status_final = "complete"
          end
          if rowStatus[:statusmark].to_s == "Returned"
            orders_status_final = "closed"
          end
          if rowStatus[:statusmark].to_s == "Fraudulent"
            orders_status_final = "canceled"
          end
          if rowStatus[:statusmark].to_s == "Cancelled"
            orders_status_final = "canceled"
          end
        else
          puts "NO MATCH > #{row[:order_id]}"
          break if weMatchedStatus == true
        end

      end

      #looks for tracking number
      orders_trackingcode_final = ""
      orderstrackingmethod = ""
      ordertrackingdate = ""


      #split customer name
      if row[:ship_name].to_s != ""
        customerName = row[:ship_name].to_s.split(" ")
        customerFirstName = customerName[0]
        if customerName[1] != nil
          customerLastName = customerName[1].gsub(/\s+/, "")
        else
          customerLastName = "LastName"
        end
      else
        customerFirstName = "FirstName"
        customerLastName = "LastName"
      end
      #split customer billing name
      if row[:bill_name].to_s != ""
        finalBillingName = row[:bill_name].to_s.split(" ")
        finalBillingFirstName = finalBillingName[0]
        if finalBillingName[1] != nil
          finalBillingLastName = finalBillingName[1].gsub(/\s+/, "")
        else
          finalBillingLastName = customerLastName
        end
      else
        finalBillingFirstName = customerFirstName
        finalBillingLastName = customerLastName
      end
      #split customer shipping name
      if row[:ship_name].to_s != ""
        finalShippingName = row[:ship_name].to_s.split(" ")
        finalShippingFirstName = finalShippingName[0]

        if finalShippingName[1] != nil
          finalShippingLastName = finalShippingName[1].gsub(/\s+/, "")
        else
          finalShippingLastName = customerLastName
        end
      else
        finalShippingFirstName = customerFirstName
        finalShippingLastName = customerLastName
      end


      #convert country code
      finalCountryCode = ""
      if row[:bill_country].to_s == "US United States"
        finalCountryCode = "US"
      elsif row[:bill_country].to_s == "Portugal"
        finalCountryCode = "PT"
      elsif row[:billing_country].to_s == "Sweden"
        finalCountryCode = "SE"
      elsif row[:billing_country].to_s == "United Kingdom"
        finalCountryCode = "GB"
      elsif row[:billing_country].to_s == "Australia"
        finalCountryCode = "AU"
      elsif row[:billing_country].to_s == "Mexico"
        finalCountryCode = "MX"
      elsif row[:billing_country].to_s == "Netherlands"
        finalCountryCode = "NL"
      elsif row[:billing_country].to_s == "Italy"
        finalCountryCode = "IT"
      elsif row[:billing_country].to_s == "Norway"
        finalCountryCode = "NO"
      elsif row[:billing_country].to_s == "France"
        finalCountryCode = "FR"
      elsif row[:billing_country].to_s == "Brazil"
        finalCountryCode = "BR"
      elsif row[:billing_country].to_s == "Japan"
        finalCountryCode = "JP"
      elsif row[:billing_country].to_s == "CA Canada"
        finalCountryCode = "CA"
      elsif row[:billing_country].to_s == "Iraq"
        finalCountryCode = "IQ"
      elsif row[:billing_country].to_s == "India"
        finalCountryCode = "IN"
      elsif row[:billing_country].to_s == "South Africa"
        finalCountryCode = "ZA"
      elsif row[:billing_country].to_s == "Germany"
        finalCountryCode = "DE"
      elsif row[:billing_country].to_s == "Switzerland"
        finalCountryCode = "CH"
      elsif row[:billing_country].to_s == "Puerto Rico"
        finalCountryCode = "PR"
      elsif row[:billing_country].to_s == "Belgium"
        finalCountryCode = "BE"
      elsif row[:billing_country].to_s == "Spain"
        finalCountryCode = "ES"
      elsif row[:billing_country].to_s == "Greece"
        finalCountryCode = "GR"
      elsif row[:billing_country].to_s == "Israel"
        finalCountryCode = "IL"
      elsif row[:billing_country].to_s == "Estonia"
        finalCountryCode = "EE"
      elsif row[:billing_country].to_s == "Finland"
        finalCountryCode = "FI"
      elsif row[:billing_country].to_s == "Denmark"
        finalCountryCode = "DK"
      elsif row[:billing_country].to_s == "Hong Kong"
        finalCountryCode = "HK"
      elsif row[:billing_country].to_s == "Chile"
        finalCountryCode = "CL"
      elsif row[:billing_country].to_s == "Austria"
        finalCountryCode = "AT"
      elsif row[:billing_country].to_s == "New Zealand"
        finalCountryCode = "NZ"
      elsif row[:billing_country].to_s == "Turkey"
        finalCountryCode = "TR"
      elsif row[:billing_country].to_s == "New Caledonia"
        finalCountryCode = "NC"
      elsif row[:billing_country].to_s == "Argentina"
        finalCountryCode = "AR"
      elsif row[:billing_country].to_s == "Thailand"
        finalCountryCode = "TH"
      elsif row[:billing_country].to_s == "Argentina"
        finalCountryCode = "AR"
      elsif row[:billing_country].to_s == "Bahamas"
        finalCountryCode = "BS"
      elsif row[:billing_country].to_s == "Ireland"
        finalCountryCode = "IE"
      elsif row[:billing_country].to_s == "Lithuania"
        finalCountryCode = "LT"
      elsif row[:billing_country].to_s == "Singapore"
        finalCountryCode = "SG"
      elsif row[:billing_country].to_s == "France, Metropolitan"
        finalCountryCode = "FR"
      elsif row[:billing_country].to_s == "Taiwan"
        finalCountryCode = "TW"
      elsif row[:billing_country].to_s == "Colombia"
        finalCountryCode = "CO"
      elsif row[:billing_country].to_s == "Venezuela"
        finalCountryCode = "VE"
      elsif row[:billing_country].to_s == "Cyprus"
        finalCountryCode = "CY"
      elsif row[:billing_country].to_s == "United States Minor Outlying Isl"
        finalCountryCode = "UM"
      elsif row[:billing_country].to_s == "Poland"
        finalCountryCode = "PL"
      elsif row[:billing_country].to_s == "Iceland"
        finalCountryCode = "IS"
      elsif row[:billing_country].to_s == "Malaysia"
        finalCountryCode = "MY"
      elsif row[:billing_country].to_s == "Indonesia"
        finalCountryCode = "ID"
      elsif row[:billing_country].to_s == "Ecuador"
        finalCountryCode = "EC"
      elsif row[:billing_country].to_s == "United Arab Emirates"
        finalCountryCode = "AE"
      elsif row[:billing_country].to_s == "French Guiana"
        finalCountryCode = "GF"
      elsif row[:billing_country].to_s == "Russian Federation"
        finalCountryCode = "RU"
      elsif row[:billing_country].to_s == "Korea, Democratic People's Repub"
        finalCountryCode = "KP"
      elsif row[:billing_country].to_s == "French Southern Territories"
        finalCountryCode = "TF"
      elsif row[:billing_country].to_s == "French Polynesia"
        finalCountryCode = "PF"
      elsif row[:billing_country].to_s == "Reunion"
        finalCountryCode = "RE"
      elsif row[:billing_country].to_s == "Hungary"
        finalCountryCode = "HU"
      elsif row[:billing_country].to_s == "Luxembourg"
        finalCountryCode = "LU"
      elsif row[:billing_country].to_s == "Czech Republic"
        finalCountryCode = "CZ"
      elsif row[:billing_country].to_s == "Haiti"
        finalCountryCode = "HT"
      elsif row[:billing_country].to_s == "Ukraine"
        finalCountryCode = "UA"
      elsif row[:billing_country].to_s == "Slovenia"
        finalCountryCode = "SI"
      elsif row[:billing_country].to_s == "Bosnia and Herzegowina"
        finalCountryCode = "BA"
      elsif row[:billing_country].to_s == "Latvia"
        finalCountryCode = "LV"
      elsif row[:billing_country].to_s == "Korea, Republic of"
        finalCountryCode = "KR"
      elsif row[:billing_country].to_s == "Bermuda"
        finalCountryCode = "BM"
      elsif row[:billing_country].to_s == "Oman"
        finalCountryCode = "OM"
      elsif row[:billing_country].to_s == "Yugoslavia"
        finalCountryCode = "RS"
      elsif row[:billing_country].to_s == "Croatia"
        finalCountryCode = "HR"
      elsif row[:billing_country].to_s == "Jordan"
        finalCountryCode = "JO"
      elsif row[:billing_country].to_s == "Romania"
        finalCountryCode = "RO"
      elsif row[:billing_country].to_s == "Guam"
        finalCountryCode = "GU"
      elsif row[:billing_country].to_s == "Panama"
        finalCountryCode = "PA"
      elsif row[:billing_country].to_s == "Slovakia (Slovak Republic)"
        finalCountryCode = "SK"
      elsif row[:billing_country].to_s == "Virgin Islands (U.S.)"
        finalCountryCode = "VI"
      elsif row[:billing_country].to_s == "Armenia"
        finalCountryCode = "AM"
      elsif row[:billing_country].to_s == "Barbados"
        finalCountryCode = "BB"
      elsif row[:billing_country].to_s == "Peru"
        finalCountryCode = "PE"
      elsif row[:billing_country].to_s == "Bahrain"
        finalCountryCode = "BH"
      elsif row[:billing_country].to_s == "Brunei Darussalam"
        finalCountryCode = "BN"
      elsif row[:billing_country].to_s == "Bulgaria"
        finalCountryCode = "BG"
      elsif row[:billing_country].to_s == "Viet Nam"
        finalCountryCode = "VN"
      elsif row[:billing_country].to_s == "Bangladesh"
        finalCountryCode = "BD"
      elsif row[:billing_country].to_s == "Belarus"
        finalCountryCode = "BY"
      elsif row[:billing_country].to_s == "Saudi Arabia"
        finalCountryCode = "SA"
      elsif row[:billing_country].to_s == "Philippines"
        finalCountryCode = "PH"
      elsif row[:billing_country].to_s == "Trinidad and Tobago"
        finalCountryCode = "TT"
      elsif row[:billing_country].to_s == "Vanuatu"
        finalCountryCode = "VU"
      elsif row[:billing_country].to_s == "Malta"
        finalCountryCode = "MT"
      elsif row[:billing_country].to_s == "Cayman Islands"
        finalCountryCode = "KY"
      elsif row[:billing_country].to_s == "Pakistan"
        finalCountryCode = "PK"
      elsif row[:billing_country].to_s == "Qatar"
        finalCountryCode = "QA"
      elsif row[:billing_country].to_s == "Jamaica"
        finalCountryCode = "JM"
      elsif row[:billing_country].to_s == "El Salvador"
        finalCountryCode = "SV"
      elsif row[:billing_country].to_s == "Guadeloupe"
        finalCountryCode = "GP"
      elsif row[:billing_country].to_s == "Sri Lanka"
        finalCountryCode = "LK"
      elsif row[:billing_country].to_s == "Kuwait"
        finalCountryCode = "KW"
      elsif row[:billing_country].to_s == "Netherlands Antilles"
        finalCountryCode = "AN"

      elsif
      puts "MISSING LOOKUP billing_country order # " + row[:orders_id].to_s + " -- " + row[:billing_country].to_s
      end

      finalCountryCodeShipping = ""
      if row[:ship_country].to_s == "US United States"
        finalCountryCodeShipping = "US"
      elsif row[:ship_country].to_s == "Portugal"
        finalCountryCodeShipping = "PT"
      elsif row[:ship_country].to_s == "Sweden"
        finalCountryCodeShipping = "SE"
      elsif row[:ship_country].to_s == "United Kingdom"
        finalCountryCodeShipping = "GB"
      elsif row[:ship_country].to_s == "Australia"
        finalCountryCodeShipping = "AU"
      elsif row[:ship_country].to_s == "Mexico"
        finalCountryCodeShipping = "MX"
      elsif row[:ship_country].to_s == "Netherlands"
        finalCountryCodeShipping = "NL"
      elsif row[:ship_country].to_s == "Italy"
        finalCountryCodeShipping = "IT"
      elsif row[:ship_country].to_s == "Norway"
        finalCountryCodeShipping = "NO"
      elsif row[:ship_country].to_s == "France"
        finalCountryCodeShipping = "FR"
      elsif row[:ship_country].to_s == "Brazil"
        finalCountryCodeShipping = "BR"
      elsif row[:ship_country].to_s == "Japan"
        finalCountryCodeShipping = "JP"
      elsif row[:ship_country].to_s == "CA Canada"
        finalCountryCodeShipping = "CA"
      elsif row[:ship_country].to_s == "Iraq"
        finalCountryCodeShipping = "IQ"
      elsif row[:ship_country].to_s == "India"
        finalCountryCodeShipping = "IN"
      elsif row[:ship_country].to_s == "South Africa"
        finalCountryCodeShipping = "ZA"
      elsif row[:ship_country].to_s == "Germany"
        finalCountryCodeShipping = "DE"
      elsif row[:ship_country].to_s == "Switzerland"
        finalCountryCodeShipping = "CH"
      elsif row[:ship_country].to_s == "Puerto Rico"
        finalCountryCodeShipping = "PR"
      elsif row[:ship_country].to_s == "Belgium"
        finalCountryCodeShipping = "BE"
      elsif row[:ship_country].to_s == "Spain"
        finalCountryCodeShipping = "ES"
      elsif row[:ship_country].to_s == "Greece"
        finalCountryCodeShipping = "GR"
      elsif row[:ship_country].to_s == "Israel"
        finalCountryCodeShipping = "IL"
      elsif row[:ship_country].to_s == "Estonia"
        finalCountryCodeShipping = "EE"
      elsif row[:ship_country].to_s == "Finland"
        finalCountryCodeShipping = "FI"
      elsif row[:ship_country].to_s == "Denmark"
        finalCountryCodeShipping = "DK"
      elsif row[:ship_country].to_s == "Hong Kong"
        finalCountryCodeShipping = "HK"
      elsif row[:ship_country].to_s == "Chile"
        finalCountryCodeShipping = "CL"
      elsif row[:ship_country].to_s == "Austria"
        finalCountryCodeShipping = "AT"
      elsif row[:ship_country].to_s == "New Zealand"
        finalCountryCodeShipping = "NZ"
      elsif row[:ship_country].to_s == "Turkey"
        finalCountryCodeShipping = "TR"
      elsif row[:ship_country].to_s == "New Caledonia"
        finalCountryCodeShipping = "NC"
      elsif row[:ship_country].to_s == "Argentina"
        finalCountryCodeShipping = "AR"
      elsif row[:ship_country].to_s == "Thailand"
        finalCountryCodeShipping = "TH"
      elsif row[:ship_country].to_s == "Argentina"
        finalCountryCodeShipping = "AR"
      elsif row[:ship_country].to_s == "Bahamas"
        finalCountryCodeShipping = "BS"
      elsif row[:ship_country].to_s == "Ireland"
        finalCountryCodeShipping = "IE"
      elsif row[:ship_country].to_s == "Lithuania"
        finalCountryCodeShipping = "LT"
      elsif row[:ship_country].to_s == "Singapore"
        finalCountryCodeShipping = "SG"
      elsif row[:ship_country].to_s == "Taiwan"
        finalCountryCodeShipping = "TW"
      elsif row[:ship_country].to_s == "Colombia"
        finalCountryCodeShipping = "CO"
      elsif row[:ship_country].to_s == "Venezuela"
        finalCountryCodeShipping = "VE"
      elsif row[:ship_country].to_s == "Cyprus"
        finalCountryCodeShipping = "CY"
      elsif row[:ship_country].to_s == "France, Metropolitan"
        finalCountryCodeShipping = "FR"
      elsif row[:ship_country].to_s == "United States Minor Outlying Isl"
        finalCountryCodeShipping = "UM"
      elsif row[:ship_country].to_s == "Poland"
        finalCountryCodeShipping = "PL"
      elsif row[:ship_country].to_s == "Iceland"
        finalCountryCodeShipping = "IS"
      elsif row[:ship_country].to_s == "Malaysia"
        finalCountryCodeShipping = "MY"
      elsif row[:ship_country].to_s == "Indonesia"
        finalCountryCodeShipping = "ID"
      elsif row[:ship_country].to_s == "Ecuador"
        finalCountryCodeShipping = "EC"
      elsif row[:ship_country].to_s == "United Arab Emirates"
        finalCountryCodeShipping = "AE"
      elsif row[:ship_country].to_s == "French Guiana"
        finalCountryCodeShipping = "GF"
      elsif row[:ship_country].to_s == "Russian Federation"
        finalCountryCodeShipping = "RU"
      elsif row[:ship_country].to_s == "Korea, Democratic People's Repub"
        finalCountryCodeShipping = "KP"
      elsif row[:ship_country].to_s == "French Southern Territories"
        finalCountryCodeShipping = "TF"
      elsif row[:ship_country].to_s == "French Polynesia"
        finalCountryCodeShipping = "PF"
      elsif row[:ship_country].to_s == "Reunion"
        finalCountryCodeShipping = "RE"
      elsif row[:ship_country].to_s == "Hungary"
        finalCountryCodeShipping = "HU"
      elsif row[:ship_country].to_s == "Luxembourg"
        finalCountryCodeShipping = "LU"
      elsif row[:ship_country].to_s == "Czech Republic"
        finalCountryCodeShipping = "CZ"
      elsif row[:ship_country].to_s == "Haiti"
        finalCountryCodeShipping = "HT"
      elsif row[:ship_country].to_s == "Ukraine"
        finalCountryCodeShipping = "UA"
      elsif row[:ship_country].to_s == "Slovenia"
        finalCountryCodeShipping = "SI"
      elsif row[:ship_country].to_s == "Bosnia and Herzegowina"
        finalCountryCodeShipping = "BA"
      elsif row[:ship_country].to_s == "Latvia"
        finalCountryCodeShipping = "LV"
      elsif row[:ship_country].to_s == "Korea, Republic of"
        finalCountryCodeShipping = "KR"
      elsif row[:ship_country].to_s == "Bermuda"
        finalCountryCodeShipping = "BM"
      elsif row[:ship_country].to_s == "Oman"
        finalCountryCodeShipping = "OM"
      elsif row[:ship_country].to_s == "Yugoslavia"
        finalCountryCodeShipping = "RS"
      elsif row[:ship_country].to_s == "Croatia"
        finalCountryCodeShipping = "HR"
      elsif row[:ship_country].to_s == "Jordan"
        finalCountryCodeShipping = "JO"
      elsif row[:ship_country].to_s == "Romania"
        finalCountryCodeShipping = "RO"
      elsif row[:ship_country].to_s == "Guam"
        finalCountryCodeShipping = "GU"
      elsif row[:ship_country].to_s == "Panama"
        finalCountryCodeShipping = "PA"
      elsif row[:ship_country].to_s == "Slovakia (Slovak Republic)"
        finalCountryCodeShipping = "SK"
      elsif row[:ship_country].to_s == "Virgin Islands (U.S.)"
        finalCountryCodeShipping = "VI"
      elsif row[:ship_country].to_s == "Armenia"
        finalCountryCodeShipping = "AM"
      elsif row[:ship_country].to_s == "Barbados"
        finalCountryCodeShipping = "BB"
      elsif row[:ship_country].to_s == "Peru"
        finalCountryCodeShipping = "PE"
      elsif row[:ship_country].to_s == "Bahrain"
        finalCountryCodeShipping = "BH"
      elsif row[:ship_country].to_s == "Brunei Darussalam"
        finalCountryCodeShipping = "BN"
      elsif row[:ship_country].to_s == "Bulgaria"
        finalCountryCodeShipping = "BG"
      elsif row[:ship_country].to_s == "Viet Nam"
        finalCountryCodeShipping = "VN"
      elsif row[:ship_country].to_s == "Bangladesh"
        finalCountryCodeShipping = "BD"
      elsif row[:ship_country].to_s == "Belarus"
        finalCountryCodeShipping = "BY"
      elsif row[:ship_country].to_s == "Saudi Arabia"
        finalCountryCodeShipping = "SA"
      elsif row[:ship_country].to_s == "Philippines"
        finalCountryCodeShipping = "PH"
      elsif row[:ship_country].to_s == "Trinidad and Tobago"
        finalCountryCodeShipping = "TT"
      elsif row[:ship_country].to_s == "Vanuatu"
        finalCountryCodeShipping = "VU"
      elsif row[:ship_country].to_s == "Malta"
        finalCountryCodeShipping = "MT"
      elsif row[:ship_country].to_s == "Cayman Islands"
        finalCountryCodeShipping = "KY"
      elsif row[:ship_country].to_s == "Pakistan"
        finalCountryCodeShipping = "PK"
      elsif row[:ship_country].to_s == "Qatar"
        finalCountryCodeShipping = "QA"
      elsif row[:ship_country].to_s == "Jamaica"
        finalCountryCodeShipping = "JM"
      elsif row[:ship_country].to_s == "El Salvador"
        finalCountryCodeShipping = "SV"
      elsif row[:ship_country].to_s == "Guadeloupe"
        finalCountryCodeShipping = "GP"
      elsif row[:ship_country].to_s == "Sri Lanka"
        finalCountryCodeShipping = "LK"
      elsif row[:ship_country].to_s == "Kuwait"
        finalCountryCodeShipping = "KW"
      elsif row[:delivery_country].to_s == "Netherlands Antilles"
        finalCountryCodeShipping = "AN"
      elsif
      puts "MISSING LOOKUP ship_country order # " + row[:orders_id].to_s + " -- " + row[:ship_country].to_s
      end

      finalCountryCode = finalCountryCodeShipping

     if row[:bill_phone].to_s != ""
        finalBillingTelephone = row[:bill_phone].to_s
      else
        finalBillingTelephone = "000-000-0000"
      end

     if row[:ship_phone].to_s != ""
        finalDeliveryTelephone = row[:ship_phone].to_s
      else
        finalDeliveryTelephone = "000-000-0000"
      end

      if row[:ship_zip].to_s != ""
        finalDeliveryPostcode = row[:ship_zip].to_s
      else
        finalDeliveryPostcode = ""
      end

      #convert NJ to New Jersey
      fullStateLookup = [["AL","Alabama"],["AK","Alaska"],["AZ","Arizona"],["AR","Arkansas"],["CA","California"],["CO","Colorado"],["CT","Connecticut"],["DE","Delaware"],["DC","District Of Columbia"],["FL","Florida"],["GA","Georgia"],["HI","Hawaii"],["ID","Idaho"],["IL","Illinois"],["IN","Indiana"],["IA","Iowa"],["KS","Kansas"],["KY","Kentucky"],["LA","Louisiana"],["ME","Maine"],["MD","Maryland"],["MA","Massachusetts"],["MI","Michigan"],["MN","Minnesota"],["MS","Mississippi"],["MO","Missouri"],["MT","Montana"],["NE","Nebraska"],["NV","Nevada"],["NH","New Hampshire"],["NM","New Mexico"],["NJ","New Jersey"],["NY","New York"],["NC","North Carolina"],["ND","North Dakota"],["OH","Ohio"],["OK","Oklahoma"],["OR","Oregon"],["PA","Pennsylvania"],["RI","Rhode Island"],["SC","South Carolina"],["SD","South Dakota"],["TN","Tennessee"],["TX","Texas"],["UT","Utah"],["VT","Vermont"],["VA","Virginia"],["WA","Washington"],["WV","West Virginia"],["WI","Wisconsin"],["WY","Wyoming"],["AS","American Samoa"],["FM","Federated States Of Micronesia"],["GU","Guam"],["MH","Marshall Islands"],["MP","Northern Mariana Islands"],["PW","Palau"],["PR","Puerto Rico"],["VI","Virgin Islands"],["AE","Armed Forces Africa"],["AA","Armed Forces Americas"],["AE","Armed Forces Europe"],["AB","Alberta"],["BC","British Columbia"],["MB","Manitoba"],["NB","New Brunswick"],["NL","Newfoundland and Labrador"],["NT","Northwest Territories"],["NS","Nova Scotia"],["NU","Nunavut"],["ON","Ontario"],["PE","Prince Edward Island"],["QC","Quebec"],["SK","Saskatchewan"],["YT","Yukon"]]

      if row[:ship_state].to_s != ""
        finalDeliveryState = row[:ship_state].to_s
        fullStateLookup.each do |(abbvstate,fullstate)|
          if row[:ship_state].to_s == abbvstate.to_s
            finalDeliveryState = fullstate.to_s
          end
        end
      else
        finalDeliveryState = ""
      end

      if row[:ship_city].to_s != ""
        finalDeliveryCity = row[:ship_city].to_s
      else
        finalDeliveryCity = ""
      end

      if row[:ship_address_1].to_s != ""
        finalDeliveryStreetAddress = row[:ship_address_1].to_s
      else
        finalDeliveryStreetAddress = ""
      end

      if row[:ship_company].to_s != ""
        finalDeliveryCompany = row[:ship_company].to_s
      else
        finalDeliveryCompany = ""
      end

      if row[:bill_zip].to_s != ""
        #finalBillingPostcode = row[:bill_zip].to_s
        finalBillingPostcode = finalDeliveryPostcode
      else
        #finalBillingPostcode = ""
        finalBillingPostcode = finalDeliveryPostcode
      end

      if row[:bill_state].to_s != ""
        finalBillingState = finalDeliveryState
        #finalBillingState = row[:bill_state].to_s
        #fullStateLookup.each do |(abbvstate,fullstate)|
        #if row[:bill_state].to_s == abbvstate.to_s
        #finalBillingState = fullstate.to_s
        #end
        #end
      else
        #finalBillingState = ""
        finalBillingState = finalDeliveryState
      end

      if row[:bill_city].to_s != ""
        #finalBillingCity = row[:bill_city].to_s
        finalBillingCity = finalDeliveryCity
      else
        #finalBillingCity = ""
        finalBillingCity = finalDeliveryCity
      end

      if row[:bill_address_1].to_s != ""
        #finalBillingStreetAddress = row[:bill_address_1].to_s
        finalBillingStreetAddress = finalDeliveryStreetAddress
      else
        #finalBillingStreetAddress = ""
        finalBillingStreetAddress = finalDeliveryStreetAddress
      end

      if row[:bill_company].to_s != ""
        #finalBillingCompany = row[:bill_company].to_s
        finalBillingCompany = finalDeliveryCompany
      else
        #finalBillingCompany = ""
        finalBillingCompany = finalDeliveryCompany
      end

      if row[:date].to_s != ""
        finalDatePurchased = row[:date].to_s
      else
        finalDatePurchased = ""
      end

      if row[:payment_method].to_s != ""
        finalPaymetMethod = row[:payment_method].to_s
      else
        finalPaymetMethod = ""
      end

      if row[:email].to_s != ""
        finalCustomerEmailAddress = row[:email].to_s
      else
        finalCustomerEmailAddress = ""
      end

      if row[:order_id].to_s != ""
        finalOrderId = row[:order_id].to_s
      else
        finalOrderId = ""
      end

      #output one row per order
      all_order_items << "\"" + finalOrderId + "\",\"base\",\"" + finalCustomerEmailAddress + "\",\"0\",\"" + finalPaymetMethod + "\",\"" + orderSkuData.chop + "\",\"" + orders_status_final + "\",\"" + ordertrackingdate + "\",\"" + orderstrackingmethod + "\",\"" + orders_trackingcode_final + "\",\"0\",\"1\",\"General\",\"\",\"" + customerFirstName + "\",\"\",\"" + customerLastName + "\",\"\",\"0\",\"0\",\"" + finalDatePurchased + "\",\"\",\"" + finalBillingFirstName + "\",\"\",\"" + finalBillingLastName + "\",\"\",\"" + finalBillingCompany + "\",\"" + finalBillingStreetAddress + "\",\"" + finalBillingCity + "\",\"" + finalCountryCode + "\",\"" + finalBillingState + "\",\"" + finalBillingPostcode + "\",\"" + finalBillingTelephone + "\",\"\",\"\",\"" + finalShippingFirstName + "\",\"\",\"" + finalShippingLastName + "\",\"\",\"" + finalDeliveryCompany + "\",\"" + finalDeliveryStreetAddress + "\",\"" + finalDeliveryCity + "\",\"" + finalCountryCodeShipping + "\",\"" + finalDeliveryState + "\",\"" + finalDeliveryPostcode + "\",\"" + finalDeliveryTelephone + "\",\"\",\"" + finalOrderSubTotal.to_s + "\",\"" + finalOrderGrandTotal + "\",\"flatrate_flatrate\",\"" + shipping_description + "\",\"" + finalOrderDiscount + "\",\"" + finalOrderShippingTotal + "\",\"" + finalOrderShippingTotal + "\",\"" + finalOrderTaxTotal +"\",\"0\", \n"
      rowCount +=1
    end

#payment_method_additional_data
#a:2:{s:16:"Credit Card Type";s:2:"VI";s:18:"Credit Card Number";s:4:"6133";}
    puts "now writing magento store file..."
    File.open(Rails.root.join('tmp', 'magento_orders_import.csv'), "w") do |final_magento_file|
      final_magento_file.puts "\"order_id\",\"website\",\"email\",\"is_guest\",\"payment_method\",\"products_ordered\",\"order_status\",\"tracking_date\",\"tracking_ship_method\",\"tracking_codes\",\"tax_percent\",\"store_id\",\"group_id\",\"prefix\",\"firstname\",\"middlename\",\"lastname\",\"suffix\",\"default_billing\",\"default_shipping\",\"created_at\",\"billing_prefix\",\"billing_firstname\",\"billing_middlename\",\"billing_lastname\",\"billing_suffix\",\"billing_company\",\"billing_street_full\",\"billing_city\",\"billing_country\",\"billing_region\",\"billing_postcode\",\"billing_telephone\",\"billing_fax\",\"shipping_prefix\",\"shipping_firstname\",\"shipping_middlename\",\"shipping_lastname\",\"shipping_suffix\",\"shipping_company\",\"shipping_street_full\",\"shipping_city\",\"shipping_country\",\"shipping_region\",\"shipping_postcode\",\"shipping_telephone\",\"shipping_fax\",\"subtotal\",\"grand_total\",\"shipping_method\",\"shipping_description\",\"discount_amount\",\"base_shipping_amount\",\"shipping_amount\",\"tax_amount\",\"customer_is_guest\" \n"
      final_magento_file.puts all_order_items
    end

    puts "[DONE] \n"
    puts "process complete"
  end
end
