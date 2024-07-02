import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
import matplotlib.pyplot as plt
import numpy as np
import openpyxl
import io
from openpyxl import Workbook
from openpyxl.drawing.image import Image

# --- Data ---
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

# --- Time Series Data (Example for T-Shirt) ---
sales_data = {
    1: {
        'date': pd.to_datetime(['2023-01-01', '2023-01-02', '2023-01-03', 
                                '2023-01-04', '2023-01-05', '2023-01-06',
                                '2023-01-07']),
        'sales': [15, 22, 18, 25, 30, 28, 35]
    }
}

# --- Functions ---
def calculate_inventory_value():
    total_value = 0
    for product in products:
        stock_quantity = stock.get(product["id"], 0)
        value = stock_quantity * product["price"]
        total_value += value
    return total_value

def calculate_gross_profit():
    total_profit = 0
    for product in products:
        profit_margin = product["price"] - product["cost"]
        total_profit += profit_margin
    return total_profit


def predict_sales(product_id, days_to_predict=7):
    """Uses LSTM to predict sales for a given product."""
    sales_history = sales_data[product_id]
    df = pd.DataFrame(sales_history)
    df['date'] = pd.to_datetime(df['date'])
    df = df.set_index('date')

    # Preprocessing
    scaler = MinMaxScaler(feature_range=(0, 1))
    scaled_data = scaler.fit_transform(df['sales'].values.reshape(-1, 1))

    # Prepare data for LSTM
    X, y = [], []
    for i in range(1, len(scaled_data)):
        X.append(scaled_data[i-1:i])
        y.append(scaled_data[i]) 
    X, y = np.array(X), np.array(y)  
    y = y.reshape(-1, 1)  # Reshape target data

    # Reshape input for LSTM [samples, time steps, features]
    X = np.reshape(X, (X.shape[0], 1, X.shape[1]))

    # Build LSTM model
    model = Sequential()
    model.add(LSTM(4, input_shape=(1, 1)))
    model.add(Dense(1))
    model.compile(loss='mean_squared_error', optimizer='adam')

    # Fit the model
    model.fit(X, y, epochs=50, batch_size=1, verbose=0)

    # Predict future sales
    last_day_sales = scaled_data[-1].reshape(1, 1, 1)
    predictions = []

    for _ in range(days_to_predict):
        next_day_prediction = model.predict(last_day_sales)
        predictions.append(next_day_prediction[0, 0])
        last_day_sales = next_day_prediction.reshape(1, 1, 1)

    # Inverse transform to get original scale
    predictions = scaler.inverse_transform(np.array(predictions).reshape(-1, 1))

    return predictions.flatten()

# --- Example Usage ---
inventory_value = calculate_inventory_value()
print("Total Inventory Value:", inventory_value)

gross_profit = calculate_gross_profit()
print("Gross Profit Margin:", gross_profit)

# --- Time Series Prediction (for T-Shirt) ---
predicted_sales = predict_sales(1)
print("Predicted Sales for T-Shirt (next 7 days):", predicted_sales)

# --- Visualization (for T-Shirt) ---
sales_history = sales_data[1]
df = pd.DataFrame(sales_history)
df['date'] = pd.to_datetime(df['date'])
df = df.set_index('date')

# Predict future sales
predicted_sales = predict_sales(1)

# Create a DataFrame for Excel output (CORRECTED VERSION)
output_df = pd.DataFrame({
    'Date': df.index.append(pd.to_datetime(df.index[-1] + pd.to_timedelta(range(1, len(predicted_sales) + 1), unit='d'))),
    'Actual Sales': df['sales'].values.tolist() + [np.nan] * len(predicted_sales),
    'Predicted Sales': [np.nan] * len(df['sales']) + list(predicted_sales)
})

# --- Create chart using matplotlib ---
plt.figure(figsize=(10, 6))
plt.plot(output_df['Date'], output_df['Actual Sales'], label='Actual Sales')
plt.plot(output_df['Date'], output_df['Predicted Sales'], label='Predicted Sales')

plt.title('T-Shirt Sales: Actual vs. Predicted')
plt.xlabel('Date')
plt.ylabel('Sales Quantity')
plt.legend()
plt.grid(True)

# Save the chart to a buffer
buf = io.BytesIO()
plt.savefig(buf, format="png")
buf.seek(0)

# --- Create Excel workbook and add data ---
wb = Workbook()
ws = wb.active
ws.title = "Sales Predictions"

# Write DataFrame to Excel sheet
for row in output_df.values.tolist():
    ws.append(row)

# Add chart to Excel sheet
# FIX: Pass the buffer directly to Image
img = Image(buf) 
ws.add_image(img, 'B10')  # Adjust position as needed

# Save Excel file
wb.save('sales_predictions.xlsx')
print("Sales data and chart saved to sales_predictions.xlsx")

# --- Stock Replenishment (Simple Example) ---
def replenish_stock(product_id, target_quantity=100):
    current_quantity = stock.get(product_id, 0)
    if current_quantity < target_quantity:
        stock[product_id] = target_quantity
        print(f"Replenished stock for product {product_id} to {target_quantity}")

# --- Cost Fluctuations (Example) ---
cost_fluctuations = {
    1: [10.0, 10.5, 10.2, 10.8, 10.0], # Example T-Shirt cost fluctuations
}

def update_cost(product_id, new_cost):
    """Updates the cost of a product."""
    for product in products:
        if product["id"] == product_id:
            product["cost"] = new_cost
            break

# --- Margin Analysis (Example) ---
def analyze_margins():
    """Calculates and prints margin analysis."""
    for product in products:
        margin = (product["price"] - product["cost"]) / product["price"] * 100
        print(f"{product['name']}: Margin - {margin:.2f}%")

# --- Example Run ---
replenish_stock(1) # Replenish T-Shirt stock
update_cost(1, 10.5) # Update T-Shirt cost
analyze_margins() 