"""
SELECT * FROM CUSTOMER

but parallel

"""
from multiprocessing import Process

class Customer:
    pass

def read_customers(path: str) -> list[Customer]:
    pass

def predict(c: Customer) -> None:
    prediction = magic(c)

def scan():
    for c in read_customers("file1.parquet"):
        predict(c)
        insert_prediction(c)

p = Process(target=scan)
p.start()
p.join()

# Fault tolerance

