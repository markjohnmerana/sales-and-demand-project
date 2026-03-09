import pandas as pd
import pyodbc

# ── CONNECTION ─────────────────────────────────────────────
conn = pyodbc.connect(
    "DRIVER={SQL Server};"
    "SERVER=MSI\\SQLEXPRESS;"
    "DATABASE=sales_dw;"
    "Trusted_Connection=yes;"
)
cursor = conn.cursor()

# ── LOAD CSV ───────────────────────────────────────────────
df = pd.read_csv("cleaned_data.csv", encoding="utf-8")

df_raw = pd.read_csv("cleaned_data.csv", encoding="utf-8")
print(f"Raw rows: {len(df_raw)}")
print(f"Sample Order Dates:\n{df_raw['Order Date'].head(10)}")
print(f"Null Order Dates: {df_raw['Order Date'].isnull().sum()}")

# Dates are already in YYYY-MM-DD format in the CSV - no dayfirst needed
df["Order Date"] = pd.to_datetime(df["Order Date"], format="%Y-%m-%d", errors="coerce")
df["Ship Date"]  = pd.to_datetime(df["Ship Date"],  format="%Y-%m-%d", errors="coerce")

# Drop rows where Order Date failed to parse
df = df.dropna(subset=["Order Date"])

print(f"Total usable rows: {len(df)}")

# Convert to string for SQL Server
df["Order Date"] = df["Order Date"].dt.strftime("%Y-%m-%d")
df["Ship Date"]  = df["Ship Date"].dt.strftime("%Y-%m-%d")

# ── HELPER FUNCTION ────────────────────────────────────────
def insert_dataframe(cursor, table, dataframe):
    skipped = 0
    for _, row in dataframe.iterrows():
        placeholders = ", ".join(["?"] * len(row))
        columns      = ", ".join(dataframe.columns)
        sql          = f"INSERT INTO {table} ({columns}) VALUES ({placeholders})"
        try:
            cursor.execute(sql, tuple(row))
        except pyodbc.IntegrityError as e:
            skipped += 1
            if skipped <= 3:  # only print first 3 so console doesn't flood
                print(f"⚠️ Skipped row in {table}: {e}")
    if skipped > 0:
        print(f"⚠️ Total skipped in {table}: {skipped}")


# ── DIM_DATE ───────────────────────────────────────────────
dim_date = df[["Order Date"]].drop_duplicates().copy()
dim_date.columns = ["order_date"]

# Drop any NaT/null dates before extraction
dim_date = dim_date.dropna(subset=["order_date"])

temp = pd.to_datetime(dim_date["order_date"])
dim_date["day"]        = temp.dt.day.astype(int)
dim_date["month"]      = temp.dt.month.astype(int)
dim_date["month_name"] = temp.dt.strftime("%B")
dim_date["quarter"]    = temp.dt.quarter.astype(int)
dim_date["year"]       = temp.dt.year.astype(int)

# Verify before inserting
print(dim_date.dtypes)
print(dim_date.isnull().sum())
print(dim_date.head(5))

insert_dataframe(cursor, "dim_date", dim_date)
print("✅ dim_date loaded")
# ── DIM_CUSTOMER ───────────────────────────────────────────

dim_customer = df[["Customer ID", "Customer Name", "Segment"]].drop_duplicates(subset=["Customer ID"]).copy()
dim_customer.columns = ["customer_id", "customer_name", "segment"]

insert_dataframe(cursor, "dim_customer", dim_customer)
print("dim_customer loaded")

# ── DIM_PRODUCT ────────────────────────────────────────────

dim_product = df[["Product ID", "Category", "Sub-Category", "Product Name"]].drop_duplicates(subset=["Product ID"]).copy()
dim_product.columns = ["product_id", "category", "sub_category", "product_name"]

insert_dataframe(cursor, "dim_product", dim_product)
print("dim_product loaded")

# ── DIM_LOCATION ───────────────────────────────────────────

dim_location = df[["Postal Code", "Country", "City", "State", "Region"]].drop_duplicates(subset=["Postal Code"]).copy()
dim_location.columns = ["postal_code", "country", "city", "state", "region"]

insert_dataframe(cursor, "dim_location", dim_location)
print("dim_location loaded")

# ── DIM_ORDER ──────────────────────────────────────────────
dim_order = df[["Order ID", "Ship Date", "Ship Mode"]].drop_duplicates(subset=["Order ID"]).copy()
dim_order.columns = ["order_id", "ship_date", "ship_mode"]

# Replace NaT with None so SQL Server accepts NULL instead of float
dim_order["ship_date"] = dim_order["ship_date"].where(
    dim_order["ship_date"].notna(), other=None
)

insert_dataframe(cursor, "dim_order", dim_order)
print("✅ dim_order loaded")

# ── FACT_SALES ─────────────────────────────────────────────
fact_sales = df[[
    "Order Date", "Order ID", "Product ID",
    "Customer ID", "Postal Code",
    "Sales", "Quantity", "Discount", "Profit"
]].copy()
fact_sales.columns = [
    "order_date", "order_id", "product_id",
    "customer_id", "postal_code",
    "sales", "quantity", "discount", "profit"
]

print(f"Before dropna: {len(fact_sales)} rows")
print(f"Null counts:\n{fact_sales.isnull().sum()}")
fact_sales = fact_sales.dropna(subset=["order_date"])
print(f"After dropna: {len(fact_sales)} rows")

# Drop rows where order_date is null
fact_sales = fact_sales.dropna(subset=["order_date"])

insert_dataframe(cursor, "fact_sales", fact_sales)
print("✅ fact_sales loaded")

# ── COMMIT & CLOSE ─────────────────────────────────────────

conn.commit()
cursor.close()
conn.close()

print("\n Tables loaded successfully")