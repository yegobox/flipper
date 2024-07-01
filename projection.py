products = [
    {"id": 1, "name": "T-Shirt", "cost": 10.0, "price": 20.0},
    {"id": 2, "name": "Jeans", "cost": 50.0, "price": 100.0},
    {"id": 3, "name": "Hat", "cost": 5.0, "price": 15.0},
]

stock = {
    1: 100,  # 100 T-shirts in stock
    2: 50,   # 50 Jeans in stock
    3: 200,  # 200 Hats in stock
}

def calculate_inventory_value():
    total_value = 0
    for product in products:
        stock_quantity = stock.get(product["id"], 0)  # Get stock quantity
        value = stock_quantity * product["price"]
        total_value += value
    return total_value

def calculate_gross_profit():
    total_profit = 0
    for product in products:
        profit_margin = product["price"] - product["cost"]
        total_profit += profit_margin
    return total_profit

def calculate_projected_revenue(sales_rate):
    total_revenue = 0
    for product in products:
        revenue = sales_rate.get(product["id"], 0) * product["price"]
        total_revenue += revenue
    return total_revenue

# Example usage
inventory_value = calculate_inventory_value()
print("Total Inventory Value:", inventory_value)

gross_profit = calculate_gross_profit()
print("Gross Profit Margin:", gross_profit)

# Assume a daily sales rate
daily_sales_rate = {
    1: 20,  # 20 T-shirts per day
    2: 5,   # 5 Jeans per day
    3: 10,  # 10 Hats per day
}
projected_revenue = calculate_projected_revenue(daily_sales_rate)
print("Projected Daily Revenue:", projected_revenue)