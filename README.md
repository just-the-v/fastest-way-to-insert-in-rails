The purpose of this repo is to explore different alternative to create a LOT of records using Ruby On Rails

## Setup
```bash
bundle install
bundle exec rake db:create db:migrate
```

## Benchmark
```bash
bundle exec rake benchmark:run
```

## Output of benchmark

### Time
```text
Benchmark #1
       user     system      total        real
Using .insert_all 31.707424   0.844759  32.552183 ( 48.743438)
Using activerecord-import 63.274812   1.663752  64.938564 ( 79.300245)
Using activerecord-copy 10.105706   0.361419  10.467125 ( 14.350178)

Benchmark #2
       user     system      total        real
Using .insert_all 31.526318   0.927514  32.453832 ( 47.779763)
Using activerecord-import 56.123897   1.177271  57.301168 ( 68.371764)
Using activerecord-copy 10.740848   0.363664  11.104512 ( 15.078548)

Benchmark #3
       user     system      total        real
Using .insert_all 31.152110   0.972743  32.124853 ( 49.563133)
Using activerecord-import 56.540865   0.938884  57.479749 ( 74.021863)
Using activerecord-copy 10.464371   0.335493  10.799864 ( 15.708497)

Benchmark #4
       user     system      total        real
Using .insert_all 31.834859   0.918198  32.753057 ( 46.912982)
Using activerecord-import 56.626079   0.975648  57.601727 ( 73.399805)
Using activerecord-copy 10.530644   0.356448  10.887092 ( 15.325899)

Benchmark #5
       user     system      total        real
Using .insert_all 31.050703   0.953167  32.003870 ( 46.740079)
Using activerecord-import 56.509416   0.959998  57.469414 ( 74.079795)
Using activerecord-copy 10.536898   0.375703  10.912601 ( 17.460426)

Benchmark #6
       user     system      total        real
Using .insert_all 31.511638   0.958565  32.470203 ( 52.140827)
Using activerecord-import 56.450128   0.964469  57.414597 ( 70.560207)
Using activerecord-copy 10.216616   0.200879  10.417495 ( 11.536544)

Benchmark #7
       user     system      total        real
Using .insert_all 31.079327   0.951225  32.030552 ( 46.091406)
Using activerecord-import 56.663603   0.973654  57.637257 ( 73.077108)
Using activerecord-copy 10.464950   0.336646  10.801596 ( 16.188408)

Benchmark #8
       user     system      total        real
Using .insert_all 31.020684   0.983104  32.003788 ( 46.696405)
Using activerecord-import 56.804588   0.917702  57.722290 ( 75.216409)
Using activerecord-copy 10.570237   0.372596  10.942833 ( 16.592656)

Benchmark #9
       user     system      total        real
Using .insert_all 31.944497   0.944894  32.889391 ( 51.704265)
Using activerecord-import 57.292759   0.949740  58.242499 ( 71.106733)
Using activerecord-copy 10.314941   0.201107  10.516048 ( 11.420511)

Benchmark #10
       user     system      total        real
Using .insert_all 31.312820   0.949659  32.262479 ( 50.738421)
Using activerecord-import 58.143859   1.004976  59.148835 ( 75.129934)
Using activerecord-copy 10.413540   0.251213  10.664753 ( 14.512139)

```
