The purpose of this repo is to explore different alternative to concat strings in database

## Setup
```bash
bundle install
bundle exec rake db:create db:migrate db:seed
```

## Benchmark
```bash
bundle exec rake benchmark:run
bundle exec rake benchmark:memory
```

## Output of benchmark

*Results obtained with 650k records in db*

### Time
```text
       user     system      total        real
Using .map 10.848756   1.556344  12.405100 ( 12.750942)
Using .pluck  1.501343   0.159192   1.660535 (  1.809598)
Using Raw SQL  2.774949   0.409105   3.184054 (  3.425237)
Using Arel  2.602465   0.726804   3.329269 (  3.509664)
Using Scenic  0.358593   0.030825   0.389418 (  0.628602)
Using virtual column  0.295781   0.041697   0.337478 (  0.452611)
```

### Memory

```text
Calculating -------------------------------------
          Using .map     1.792B memsize (     1.530B retained)
                        14.987M objects (    12.969M retained)
                        50.000  strings (    50.000  retained)
        Using .pluck   620.559M memsize (    22.757k retained)
                         9.635M objects (   134.000  retained)
                        50.000  strings (    50.000  retained)
       Using Raw SQL   903.172M memsize (     2.488k retained)
                        10.504M objects (    24.000  retained)
                        50.000  strings (     9.000  retained)
          Using Arel   903.177M memsize (     3.100k retained)
                        10.504M objects (    18.000  retained)
                        50.000  strings (    11.000  retained)
        Using Scenic   273.213M memsize (    45.049k retained)
                         2.627M objects (   217.000  retained)
                        50.000  strings (    50.000  retained)
Using virtual column   273.161M memsize (    22.365k retained)
                         2.626M objects (   124.000  retained)
                        50.000  strings (    50.000  retained)

Comparison:
Using virtual column:  273160735 allocated
        Using Scenic:  273212736 allocated - 1.00x more
        Using .pluck:  620559199 allocated - 2.27x more
       Using Raw SQL:  903172270 allocated - 3.31x more
          Using Arel:  903176602 allocated - 3.31x more
          Using .map: 1792250836 allocated - 6.56x more
```