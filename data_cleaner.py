import pandas as pd

# Reading CSV with encoding fallback
try:
    df = pd.read_csv("raw_data.csv", encoding="utf-8")
except UnicodeDecodeError:
    df = pd.read_csv("raw_data.csv", encoding="latin1")

# ── Date conversion ──────────────────────────────────────────
#### Convert dates - try both formats since real data can be inconsistent

df["Order Date"] = pd.to_datetime(df["Order Date"], dayfirst=True, errors="coerce")
df["Ship Date"] = pd.to_datetime(df["Ship Date"], dayfirst=True, errors="coerce")

#### Drop rows where Order Date is missing (critical field)
df = df.dropna(subset=["Order Date"])

# ── Null handling  ──────────────────────────────────────────
#### Only drop rows where CRITICAL columns are null
#### Sales, Quantity, Profit are required for analysis

critical_columns = ["Order ID", "Product ID", "Customer ID", "Sales", "Quantity", "Profit"]
df = df.dropna(subset=critical_columns)

# ── Data duplicate handling ─────────────────────────────────────
#### Only remove rows where EVERY column is identical (true duplicates)
#### DO NOT subset by Order ID alone - one order can have many products
df = df.drop_duplicates()

# ── Checking the output ──────────────────────────────────────────

print(f"Total rows after cleaning: {len(df)}")
print(f"Unique orders: {df['Order ID'].nunique()}")
print(f"Unique products: {df['Product ID'].nunique()}")
print(f"Date range: {df['Order Date'].min()} to {df['Order Date'].max()}")
print(f"Null counts:\n{df.isnull().sum()}")

# Save
df.to_csv("cleaned_data.csv", index=False)
print("\nCleaning complete. Saved as cleaned_data.csv")