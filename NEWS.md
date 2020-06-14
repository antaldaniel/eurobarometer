# eurobarometer 0.0.9

* Added a `NEWS.md` file to track changes to the package.
* Added `canonical_names()` to create a subjective canonical name for GESIS variables.

# eurobarometer 0.1.0
* The `gesis_vocabulary_create()` helper function is added to make variable label and value label harmonization easier.
* New `vignette(vocabulary)` is developed as a working article to start creating meaningful metadata files. This is at this stage intended for contributors. See [Working With Vocabularies](http://eurobarometer.danielantal.eu/articles/vocabulary.html).

# eurobarometer 0.1.1
* The [Harmonizing Variable Names](http://eurobarometer.danielantal.eu/articles/variable_names.html) vignette/article started for an early standardization of variable names. 
* In the future, `canonical_names()` may be renamed, and it may receive a new functionality.
* The `gesis_vocabulary_create()` and The `gesis_metadata_create()` have better variable names.  The `normalize_names()` function is renamed to `label_normalize()`. 
* Internal function is renamed to `class_suggest()` from `suggest_conversion()`.
* The [Workflow](http://eurobarometer.danielantal.eu/articles/workflow.html) vignette is open for consultation.

# Foreseen changes

* `code_nuts1()` and `code_nuts2()` will be deprecated, and included in the [regions](http://regions.danielantal.eu/) package.  A vignette will connect the two packages.
