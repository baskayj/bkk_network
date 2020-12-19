import pandas as pd

# Before any real work, some unwanted string pieces have to be removed, in order to correctly identify
# routes that share stops. The biggest cause of headache is the fact that if a metro station is called
# "Sesame street" then the corresponding bus station is called "Sesame street M" with no id or
# parent station that can connect the two

# I also did some cleaning by hand for rare occurrences, that are extremely hard to catch otherwise
unwanted = [' M+H',' M', ' H',
            ' [A]',' [B]',' [C]',
            ' [D]',' [E]',' [F]',
            ' [G]',' [H]',' [I]',
            ' [J]',' [K]',' [L]',
            ' [M]',' [N]', ' [2]',
            ' [3]',' [4]',' [5]',
            ' [6]',' [7]',' [8]',
            ' [9]',' [10]'' [11]',
            ' P+R']

df = pd.read_csv('stops.txt',header=0)

for i in range(len(df)):
    for u in unwanted:
        if u in df.iloc[i,1]:
            df.iloc[i,1] = df.iloc[i,1].replace(u,'')  # Replace unwanted strings with nothing

df.to_csv('stops.csv',index=False)