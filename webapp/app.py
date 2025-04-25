import streamlit as st
import pandas as pd
from sqlalchemy import create_engine

# Page title
st.title("📊 Amazon USA Sales Dashboard")

# PostgreSQL connection using SQLAlchemy + pg8000
@st.cache_resource
def get_connection():
    engine = create_engine("postgresql+pg8000://postgres:180068@localhost:5432/amazon")
    return engine.connect()

conn = get_connection()

# Sidebar for query selection
option = st.sidebar.selectbox(
    "Select a Query",
    (
        "Top 10 Best-Selling Products",
        "Revenue by Category",
        "Monthly Sales Trend",
        "Payment Status"
    )
)

# Query logic
if option == "Top 10 Best-Selling Products":
    query = """
    SELECT p.product_name, SUM(oi.quantity * oi.price_per_unit) AS total_sales
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_name
    ORDER BY total_sales DESC
    LIMIT 10;
    """
    df = pd.read_sql(query, conn)
    st.subheader("Top 10 Products by Revenue")
    st.dataframe(df)

elif option == "Revenue by Category":
    query = """
    SELECT c.category_name, SUM(oi.quantity * oi.price_per_unit) AS revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN category c ON p.category_id = c.category_id
    GROUP BY c.category_name
    ORDER BY revenue DESC;
    """
    df = pd.read_sql(query, conn)
    st.subheader("Revenue by Category")
    st.bar_chart(df.set_index("category_name"))

elif option == "Monthly Sales Trend":
    query = """
    SELECT DATE_TRUNC('month', o.order_date) AS month, SUM(oi.quantity * oi.price_per_unit) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month
    ORDER BY month;
    """
    df = pd.read_sql(query, conn)
    st.subheader("Monthly Revenue Trend")
    df["month"] = pd.to_datetime(df["month"])
    df.set_index("month", inplace=True)
    st.line_chart(df)

elif option == "Payment Status":
    query = "SELECT payment_status, COUNT(*) FROM payments GROUP BY payment_status;"
    df = pd.read_sql(query, conn)
    st.subheader("Payment Status Breakdown")
    st.bar_chart(df.set_index("payment_status"))
