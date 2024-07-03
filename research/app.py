from flask import Flask, jsonify, send_file, request
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
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.chart import LineChart, Reference
import boto3
from botocore.exceptions import ClientError
import matplotlib
matplotlib.use('Agg')  # Set the backend
from datetime import datetime
import requests
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

# --- Data ---
def fetch_data_from_api(collection, branchId):
    url = "https://ap-south-1.aws.data.mongodb-api.com/app/data-kbpgj/endpoint/data/v1/action/find"
    headers = {
        "Content-Type": "application/json",
        "api-key": os.getenv('MONGODB_API_KEY')
    }
    payload = {
        "collection": collection,
        "database": "flipper",
        "dataSource": "Cluster0",
        "filter": {"branchId": branchId}
    }

    try:
        response = requests.post(url, json=payload, headers=headers)
        response.raise_for_status()  # Raises a HTTPError if the status is 4xx, 5xx
        return response.json().get('documents', [])
    except requests.RequestException as e:
        print(f"Error fetching {collection} data from API: {e}")
        return []

def fetch_products(branchId):
    products_data = fetch_data_from_api("Variant", branchId)
    return {
        doc.get('id'): {
            "id": doc.get('id'),
            "name": doc.get('productName'),
            "cost": doc.get('supplyPrice', 0),
            "price": doc.get('retailPrice', 0)
        }
        for doc in products_data
    }

def fetch_stock(branchId):
    stock_data = fetch_data_from_api("Stock", branchId)
    return {
        doc.get('variantId'): doc.get('currentStock', 0)
        for doc in stock_data
    }

def fetch_sales(branchId):
    sales_data = fetch_data_from_api("TransactionItem", branchId)
    processed_sales = {}
    
    for item in sales_data:
        date = pd.to_datetime(item.get('createdAt')).date()
        variant_id = item.get('variantId')
        quantity = item.get('qty', 0)
        
        if variant_id not in processed_sales:
            processed_sales[variant_id] = {'date': [], 'sales': []}
        
        if date in processed_sales[variant_id]['date']:
            index = processed_sales[variant_id]['date'].index(date)
            processed_sales[variant_id]['sales'][index] += quantity
        else:
            processed_sales[variant_id]['date'].append(date)
            processed_sales[variant_id]['sales'].append(quantity)
    
    return processed_sales

# --- Functions ---
def calculate_inventory_value():
    total_value = 0
    for product_id, product in products.items():
        stock_quantity = stock.get(product_id, 0)
        value = stock_quantity * product["price"]
        total_value += value
    return total_value

def calculate_gross_profit():
    total_profit = 0
    for product in products.values():
        profit_margin = product["price"] - product["cost"]
        total_profit += profit_margin
    return total_profit

def predict_sales(product_id, days_to_predict=7):
    """Uses LSTM to predict sales for a given product."""
    if product_id not in sales_data or len(sales_data[product_id]['date']) < 2:
        print(f"Insufficient sales data for product {product_id}")
        return []

    df = pd.DataFrame(sales_data[product_id])
    df['date'] = pd.to_datetime(df['date'])
    df = df.set_index('date')
    df = df.sort_index()  # Ensure the data is sorted by date

    scaler = MinMaxScaler(feature_range=(0, 1))
    scaled_data = scaler.fit_transform(df['sales'].values.reshape(-1, 1))

    X, y = [], []
    for i in range(1, len(scaled_data)):
        X.append(scaled_data[i-1:i])
        y.append(scaled_data[i]) 
    X, y = np.array(X), np.array(y)  
    y = y.reshape(-1, 1)

    X = np.reshape(X, (X.shape[0], 1, X.shape[1]))

    model = Sequential()
    model.add(LSTM(4, input_shape=(1, 1)))
    model.add(Dense(1))
    model.compile(loss='mean_squared_error', optimizer='adam')

    model.fit(X, y, epochs=50, batch_size=1, verbose=0)

    last_day_sales = scaled_data[-1].reshape(1, 1, 1)
    predictions = []

    for _ in range(days_to_predict):
        next_day_prediction = model.predict(last_day_sales)
        predictions.append(next_day_prediction[0, 0])
        last_day_sales = next_day_prediction.reshape(1, 1, 1)

    predictions = scaler.inverse_transform(np.array(predictions).reshape(-1, 1))

    return predictions.flatten()

def generate_excel_file():
    if not sales_data:
        raise ValueError("No sales data available")

    wb = Workbook()
    ws = wb.active
    ws.title = "Sales Predictions"
    headers = ['Date', 'Product Name', 'Actual Sales', 'Predicted Sales']
    ws.append(headers)
    
    for product_id, product in products.items():
        product_name = product['name']
        predicted_sales = predict_sales(product_id)
        sales_history = sales_data.get(product_id, {'date': [], 'sales': []})

        if not sales_history['date']:
            continue
        
        df = pd.DataFrame(sales_history)
        df['date'] = pd.to_datetime(df['date'])
        df = df.set_index('date')

        output_df = pd.DataFrame({
            'Date': df.index.append(pd.to_datetime(df.index[-1] + pd.to_timedelta(range(1, len(predicted_sales) + 1), unit='d'))),
            'Product Name': [product_name] * (len(df['sales']) + len(predicted_sales)),
            'Actual Sales': df['sales'].values.tolist() + [np.nan] * len(predicted_sales),
            'Predicted Sales': [np.nan] * len(df['sales']) + list(predicted_sales)
        })
        
        for row in output_df.itertuples(index=False, name=None):
            ws.append(row)
    
    for col in ws.columns:
        max_length = max(len(str(cell.value)) for cell in col)
        col_letter = col[0].column_letter
        ws.column_dimensions[col_letter].width = max_length + 2

    # Create chart
    chart = LineChart()
    chart.title = "Sales Predictions"
    chart.style = 10
    chart.y_axis.title = 'Sales Quantity'
    chart.x_axis.title = 'Date'

    data = Reference(ws, min_col=3, min_row=1, max_col=4, max_row=ws.max_row)
    categories = Reference(ws, min_col=1, min_row=2, max_row=ws.max_row)
    chart.add_data(data, titles_from_data=True)
    chart.set_categories(categories)

    ws.add_chart(chart, "F2")

    excel_buffer = io.BytesIO()
    wb.save(excel_buffer)
    excel_buffer.seek(0)

    return excel_buffer

def generate_file_name():
    current_date = datetime.now().strftime("%Y%m%d")
    return f"SALES_PREDICTIONS_{current_date}.xlsx".upper()

@app.route('/generate_s3_url', methods=['GET'])
def generate_s3_url():
    branchId = request.args.get('branchId')
    if not branchId:
        return jsonify({
            "status": "error",
            "message": "branchId is required"
        }), 400

    # Fetch data using the provided branchId
    global products, stock, sales_data
    products = fetch_products(int(branchId))
    stock = fetch_stock(int(branchId))
    sales_data = fetch_sales(int(branchId))

    if not sales_data:
        return jsonify({
            "status": "error",
            "message": "No sales data available for the given branchId"
        }), 404

    bucket_name = os.getenv('BUCKET_NAME')
    file_name = generate_file_name()

    try:
        excel_buffer = generate_excel_file()
    except ValueError as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 404
    
    # Save file locally
    with open(file_name, 'wb') as f:
        f.write(excel_buffer.getvalue())
    
    # Upload to S3
    s3_client = boto3.client('s3')
    try:
        s3_client.upload_file(file_name, bucket_name, file_name)
        print(f"File uploaded successfully to {bucket_name}/{file_name}")
        
        # Generate presigned URL
        try:
            response = s3_client.generate_presigned_url('get_object',
                                                        Params={'Bucket': bucket_name,
                                                                'Key': file_name},
                                                        ExpiresIn=3600)
            return jsonify({
                "status": "success",
                "message": "File uploaded and URL generated successfully",
                "download_url": response
            }), 200
        except ClientError as e:
            print(f"Error generating presigned URL: {str(e)}")
            return jsonify({
                "status": "error",
                "message": "Failed to generate downloadable URL"
            }), 500
    except Exception as e:
        print(f"Error uploading file to S3: {str(e)}")
        return jsonify({
            "status": "error",
            "message": "Failed to upload file to S3"
        }), 500

@app.route('/download_excel', methods=['GET'])
def download_excel():
    excel_buffer = generate_excel_file()
    return send_file(
        excel_buffer,
        as_attachment=True,
        download_name='sales_predictions.xlsx',
        mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )

if __name__ == '__main__':
    app.run(debug=True)
