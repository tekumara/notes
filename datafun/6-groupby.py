"""
select count(*) from customer group by c_nationkey;
"""
class Customer:
    pass


def read_customer(path: str) -> Customer:
    pass

def main():
    counts = {}
    for c in read_customer("cust1.parquet"):
        counts[c.nation] += 1
        print(c)

main()


# How to parallelise?
