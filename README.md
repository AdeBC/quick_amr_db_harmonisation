# Crude AMR database harmonisation

We need a quick way to compare results between different AMR databases
While there are better ideas of dealing with this problem more robustly 
(...speak to me about genomically-informed nomenclature normalisation),
for mapping AMR databases (NCBI AMR, ResFinder, SARG, DeepARG, MEGARes, ARG-ANNOT) to CARD's ARO:

- Download these AMR databases

- Run them through RGI

- Using hits, create a mapping of each ARG to the ARO

- Highlight any situation of no hits/disconnect for manual curation

## Running

Run the following commands in your terminal.
```bash
conda env create -f env.yml
conda activate crude_harmonisation
bash crude_db_harmonisation.sh
```

Output mapping can be found at `resfinder_ncbi_sarg_deeparg_megares_argannot_ARO_mapping.tsv`

## Statistics

Proportion of genes mapped for each database.

```python
argannot        0.996
deeparg         0.976
megares         0.950
ncbi            0.969
resfinder       0.976
resfinder_fg    0.983
sarg            0.978
```

