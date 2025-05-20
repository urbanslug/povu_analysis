Convert non numeric to numeric GFA

```
./to_numeric.py pangenes/data/t1-4.gfa > t1-4.num.gfa 
```

For all files in a dir run

```
in_dir.sh
```

### comparing vg and povu

Generate flubbles
```
povu deconstruct -t 1 -v 0 -i ~/src/hprc/povu/test_data/LPA.gfa -o ~/src/hprc/analysis/data/LPA
```

Generate snarls
```
vg stats -R test_data/real/LPA.gfa > lpa.vg.stats.tsv
```
