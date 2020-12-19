# This script is to plot the network to visually check for errors
# Also, it looks cool

import networkx as nx
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import scipy

df = pd.read_csv('route_w_links_daytime.csv', header=0)
df_2 = pd.read_csv('routes.txt', header = 0)
df_3 = pd.read_csv('route_degrees_daytime.csv', header = 0)
df_2 = df_2.set_index('route_id').join(df_3.set_index('route_1'), how="right")

G = nx.Graph()

for i in range(len(df)):
    G.add_edge(df.iloc[i,0],df.iloc[i,1],weight = df.iloc[i,2]/2)

pos = nx.kamada_kawai_layout(G)

plt.figure(figsize=(100,100))

for i in range(len(df_2)):
    nx.draw_networkx_nodes(G,pos,nodelist=[df_2.index[i]],node_color=f'#{df_2.iloc[i,5]}',alpha=0.6, node_size=300*(df_2.iloc[i,9]))
    labels = {}
    labels[df_2.index[i]] = df_2.iloc[i,1]
    size = 10*(1+np.log(df_2.iloc[i,9]))
    nx.draw_networkx_labels(G,pos,labels=labels,font_size=int(size),font_color="white")
nx.draw_networkx_edges(G,pos)

plt.title('Network of daytime Budapest Public Transit routes', fontdict={'fontsize':100})
plt.savefig('route_links_daytime.png')