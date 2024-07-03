from flask import Flask, jsonify
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
import matplotlib.pyplot as plt
import numpy as np

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
        X.append(scaled_data[i - 1:i])
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

# --- Flask App ---
app = Flask(__name__)

@app.route('/predict_sales/<product_id>')
def get_predicted_sales(product_id):
    """Endpoint to get predicted sales for a product."""
    try:
        product_id = int(product_id)
        predictions = predict_sales(product_id)
        return jsonify({'predictions': predictions.tolist()})
    except ValueError:
        return jsonify({'error': 'Invalid product ID'}), 400

if __name__ == '__main__':
    app.run(debug=True)