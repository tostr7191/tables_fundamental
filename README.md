# GUE Fundamentals Table Generator

Disclaimer: Don't believe everything you find on the internet. It might kill you.

Tool to generate tables in PDF format.
  * Minimum Gas Table (when to surface from a given depth/tank combo)
  * Estimated Gas Usage (how much bar you will use within 5 minutes with a given depth/tank combo)

## Requirements

  * ruby
  * rake
  * LaTeX

## How to run

```
$ vim generate.rb
# change SAC, Depths and Liters
$ rake
# output will be under ./pdf/
```
