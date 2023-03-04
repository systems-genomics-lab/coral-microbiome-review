raxml-ng --seed 123456 --redo --threads 192 --all --msa coral-microbiome.aln --model GTR+G pars{10} --brlen scaled --bs-metric tbe --bs-trees autoMRE{100} --prefix coral-microbiome-raxml
