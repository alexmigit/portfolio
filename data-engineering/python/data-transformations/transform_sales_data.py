import pandas as pd

# Load data
df = pd.read_csv('sales_data.csv')

# Transform data
df['sale_date'] = pd.to_datetime(df['sale_date'])
df['amount'] = df['amount'].apply(lambda x: round(x, 2))

# Add a new calculated column
df['sales_tax'] = df['amount'] * 0.07

# Save the transformed data
df.to_csv('transformed_sales_data.csv', index=False)

