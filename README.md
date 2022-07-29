# Sales & Inventory Analyst Project

This is my proof of work as a Sales & Inventory Analyst at a footwear &amp; accessories company. Includes SQL queries and Excel dashboards. 

The company stocks over 4000+ items across 700+ products and 21 product categories. Their products are largely sold on e-commerce platforms such as Shopee, Lazada & Qoo10, bringing in on average $20,000 in weekly sales. 

The client found limitations in analysis arising from the following: 
* Limitations of the Shopee's Business Insights Platform to view data beyond basic trends and performances metrics
* Due to UI limitations, the platform does not make it easy to view items, products & categories at a glance. One has to click multiple times to obtain the desired information
* Stock ordering strategies the company takes is largely based on a top-down approach where more can be done to integrate the value that the data provides

I was brought in to provide an analysis on the following: 
* Identify sales trend across different SKUs, products, and categories
* Identify best performing and worst performing items 
* Provide recommendations on which items to push for, and which items to ramp down orders 
* Identify ways to speed up stock-ordering times

## Dataset Used & Limitations

The data provided by the client are .csv files:

### Weekly Sales Data 
* Sales data that is released weekly on Mondays. Unfortunately, Shopee does not provide sales data by day or time of day. Limiting analysis from  identifying day-of-week and time-of-day trends.
* Sales data provided from Nov 21' - Present. This limits the level of analysis from including time series forecasting methods such as SARIMA. 
* Columns include Product, Item ID, Variation Name, SKU, Parent SKU, Product Visitors, Product Page Views, Product Bounce Rate, Likes, Product Visitors (Add to Cart), Units (Add to Cart), Conversion Rate (Add to Cart), Buyers (Placed Order), Units (Placed Order), Sales (Placed Order), Conversion Rate (Visit to Placed), Buyers (Paid Orders), Units (Paid Orders), Sales (Paid Orders), Conversion (Visit to Paid)

### Weekly Remaining Stock Data
* The table consists of stocks remaining for each SKU. The table can be pulled from the Shopee Business Insight platform on-demand. 
* Columns include Product ID, Product Name, Variation ID, Variation Name, Parent SKU, SKU, Price, Stock (remaining)


