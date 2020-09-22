import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

path2xls = '../data/phoneme_stimuli_cut/Stimuli - acoustic properties.xlsx'

df1 = pd.read_excel(path2xls, 'CV')
df1 = df1.dropna()
df2 = pd.read_excel(path2xls, 'V')
df2 = df2.dropna()

# Merge into a single DataFrame
df = pd.DataFrame(columns=['Phoneme', 'Speaker', 'Serial num', 'Measure', 'Duration (msec)', 'consonant_vowel'])
for index, row in df1.iterrows():
    for measure in ['consonant duration', 'vowel duration', 'Formant Transition', 'total duration']:
        df = df.append({'consonant_vowel':'consonant', 'Phoneme': row['phoneme'], 'Speaker': row['speaker'], 'serial num': row['serial num'], 'Measure': measure, 'Duration (msec)': row[measure]}, ignore_index=True)

for index, row in df2.iterrows():
    for measure in ['total duration']:
        df = df.append({'consonant_vowel':'vowel', 'Phoneme': row['phoneme'], 'Speaker': row['speaker'], 'serial num': row['serial num'], 'Measure': measure, 'Duration (msec)': row[measure]}, ignore_index=True)

df = df.astype({'Speaker': 'int32'})
# Plot CV properties
df_temp = df.loc[(df['consonant_vowel'] == 'consonant') & (df['Measure'].isin(['consonant duration', 'vowel duration']))]
fig, ax = plt.subplots(figsize=(10,10))
sns.boxplot(x="Measure", y="Duration (msec)", hue='Speaker', data=df_temp, ax=ax)
# sns.swarmplot(x="measure", y="value", hue='speaker', data=df, color=".25", ax=ax)
# Cosmetics and save
ax.set_xlabel('')
ax.set_xticklabels(['Consonant', 'Vowel (/a/)'])
sns.set(font_scale=1)
plt.savefig('../figures/CV_acoustic_properties.png')


# Plot V properties
df_temp = df.loc[df['consonant_vowel'] == 'vowel']
fig, ax = plt.subplots(figsize=(10,10))
sns.boxplot(x="Measure", y="Duration (msec)", hue='Speaker', data=df_temp, ax=ax)
# sns.swarmplot(x="measure", y="value", hue='speaker', data=df, color=".25", ax=ax)
# Cosmetics and save
ax.set_xlabel('')
sns.set(font_scale=1)
plt.savefig('../figures/V_acoustic_properties.png')
