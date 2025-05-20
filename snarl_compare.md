# povu
povu deconstruct -t 1 -v 0 -i ~/src/hprc/povu/test_data/LPA.gfa -o ~/src/hprc/analysis/data/LPA

# vg
vg stats -R test_data/real/LPA.gfa > lpa.vg.stats.tsv
