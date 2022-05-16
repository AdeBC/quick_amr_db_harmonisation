# Crude AMR database harmonisation

We need a quick way to compare results between different AMR databases
While there are better ideas of dealing with this problem more robustly 
(...speak to me about genomically-informed nomenclature normalisation),
for mapping AMR databases (NCBI AMR, ResFinder, SARG, DeepARG) to CARD's ARO:

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

Output mapping can be found at `resfinder_ncbi_sarg_deeparg_ARO_mapping.tsv`

## Statistics

Proportion of genes mapped for each database.

```python
deeparg         0.976
ncbi            0.968
resfinder       0.978
resfinder_fg    0.983
sarg            0.494
```

_Mapping result for **sarg** to be optimized_.

