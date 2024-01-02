# pandas

Create a dummy dataframe:

```python
import pandas as pd
import numpy as np
import random

df = pd.DataFrame(np.random.random((50000, 2)), columns=["a", "b"])
df['gender'] = df.apply(lambda x: random.choice(['male', 'female']), axis=1)
```

## Create list of dicts

To dict:

```python
df.to_dict(orient='records')
```

To dict manually (very marginally slower):

```python
[dict(zip(df.columns, r)) for r in zip(*[df[col] for col in df.columns])]
```

## Display

Display at least 20 rows:

```python
pd.set_option("display.min_rows", 20)
```

Don't truncate columns:

```python
pd.set_option('display.max_colwidth', None)
```
