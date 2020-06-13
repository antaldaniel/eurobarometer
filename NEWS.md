# eurobarometer 0.0.9

* Added a `NEWS.md` file to track changes to the package.
* Added `canonical_names()` to create a subjective canonical name for GESIS variables.

# eurobarometer 0.1.0
* The `gesis_vocabulary_create()` helper function is added to make variable label and value label harmonization easier.
* New `vignette(vocabulary)` is developed as a working article to start creating meaningful metadata files. This is at this stage intended for contributors. See [Working With Vocabularies](http://eurobarometer.danielantal.eu/articles/vocabulary.html).

# eurobarometer 0.1.1
* The [Harmonizing Variable Names](http://eurobarometer.danielantal.eu/articles/variable_names.html) vignette/article started for an early standardization of variable names. 
* `canonical_names()` will be deprecated, because the metadata tables will be used to suggest canonical names.
* The `gesis_vocabulary_create()` and The `gesis_metadata_create()` have better variable names.  The `normalize_names()` function is renamed to `label_normalize`
