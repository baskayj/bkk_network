# This script is to plot the network to visually check for errors
# Also, it looks cool

import networkx as nx
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import scipy

df = pd.read_csv('stop_w_links_daytime.csv', header=0)
df_2 = pd.read_csv('stops.csv', header = 0)
df_3 = pd.read_csv('stop_degrees_daytime.csv', header = 0)
df_2 = df_2.set_index('stop_name').join(df_3.set_index('stop_1'), how="right")

G = nx.Graph()

for i in range(len(df)):
    G.add_edge(df.iloc[i,0],df.iloc[i,1],weight = df.iloc[i,2]/2)


pos = nx.kamada_kawai_layout(G)

plt.figure(figsize=(100,100))

for i in range(len(df_2)):
    nx.draw_networkx_nodes(G,pos,nodelist=[df_2.index[i]],alpha=0.6, node_size=30*(df_2.iloc[i,8]))

nx.draw_networkx_edges(G,pos)

plt.title('Network of the Budapest Public Transit stops', fontdict={'fontsize':100})
plt.savefig('stop_links_daytime.png')