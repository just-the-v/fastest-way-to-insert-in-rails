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
       user     system      total        real
Using .save 98.482027   7.339702 105.821729 (174.001099)
Using .save! 82.036858   7.221731  89.258589 (145.422204)
Using .save! with transaction 38.410147   2.444573  40.854720 ( 68.257510)
Using .create105.934837   7.278972 113.213809 (185.792927)
Using .create with hashes118.748599   8.459169 127.207768 (204.100991)
Using .create!121.161595   7.396354 128.557949 (203.611114)
Using .create! with transaction 48.788214   2.510467  51.298681 ( 79.932584)
Using .insert_all  1.443989   0.047568   1.491557 (  3.156946)
Using .upsert_all  1.464735   0.056942   1.521677 (  2.795619)
Using activerecord-import  3.511353   0.082371   3.593724 (  4.778761)
```
