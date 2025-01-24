from flytekit import task, workflow
from sqlalchemy import create_engine, text
import pandas as pd

# Configuration for the source and target databases
SOURCE_DB_URI = "postgresql://postgres:postgres2025!@104.155.158.148:5432/sandbox_db"
TARGET_DB_URI = "postgresql://postgres:postgres2025!@104.155.158.148:5432/olap"

@task
def extract_chunk(offset: int, chunk_size: int) -> pd.DataFrame:
    """Extracts a chunk of data from the source Postgres database."""
    source_engine = create_engine(SOURCE_DB_URI)
    query = f"""
        SELECT * 
        FROM airports
        OFFSET {offset}
        LIMIT {chunk_size}
    """
    with source_engine.connect() as connection:
        df = pd.read_sql_query(query, connection)
    return df

@task
def transform(data: pd.DataFrame) -> pd.DataFrame:
    """Transforms the data (if needed)."""
    # Example transformation: Add a new column
    data['processed_at'] = pd.Timestamp.now()
    return data

@task
def load(data: pd.DataFrame):
    """Loads the transformed data into the target Postgres database."""
    target_engine = create_engine(TARGET_DB_URI)
    with target_engine.connect() as connection:
        data.to_sql('your_table_name', connection, if_exists='append', index=False)

@workflow
def etl_workflow(total_rows: int, chunk_size: int):
    """Executes the ETL workflow in chunks."""
    for offset in range(0, total_rows, chunk_size):
        data_chunk = extract_chunk(offset=offset, chunk_size=chunk_size)
        transformed_data = transform(data=data_chunk)
        load(data=transformed_data)

if __name__ == "__main__":
    # Example execution of the workflow
    # Replace total_rows with the actual number of rows in your source table
    total_rows = 100000  # Example row count
    etl_workflow(total_rows=total_rows, chunk_size=10000)