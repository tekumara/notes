"""
SELECT * FROM CUSTOMER
"""
class Customer:
    pass


def read_batch(path: str) -> list[Customer]:
    pass

def main():
    for c in read_batch("cust1.parquet"):
        print(c)
    for c in read_batch("cust2.parquet"):
        print(c)

main()



# Batch for IO efficiency, but means more memory

# Memory complexity?

# file bigger than mem?

# Uneven batches?

# For more info: See repartition_batches function
