# copy all this into a Streamlit in Snowflake app
# add refs to matplotlib+seaborn

import streamlit as st
from snowflake.snowpark.context import get_active_session
import matplotlib.pyplot as plt
import seaborn as sns

df = (get_active_session()
    .table('snowflake_sample_data.tpch_sf1.lineitem')
    .limit(100000)
    .to_pandas())
fig, ax = plt.subplots()
sns.heatmap(df.corr(numeric_only=True), ax=ax)
st.write(fig)