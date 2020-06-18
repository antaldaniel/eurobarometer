# eurobarometer 0.0.9
* Added a `NEWS.md` file to track changes to the package.
* Added `canonical_names()` to create a subjective canonical name for GESIS variables.

# eurobarometer 0.1.0
* The `gesis_vocabulary_create()` helper function is added to make variable label and value label harmonization easier.
* New `vignette(vocabulary)` is developed as a working article to start creating meaningful metadata files. This is at this stage intended for contributors. See [Working With Vocabularies](http://eurobarometer.danielantal.eu/articles/vocabulary.html).

# eurobarometer 0.1.1
* The [Harmonizing Variable Names](http://eurobarometer.danielantal.eu/articles/variable_names.html) vignette/article started for an early standardization of variable names. Thanks for the contribution from [Marta](https://github.com/mkolczynska).
* In the future, `canonical_names()` may be renamed, and it may receive a new functionality.
* The `gesis_vocabulary_create()` and The `gesis_metadata_create()` have better variable names.  The `normalize_names()` function is renamed to `label_normalize()`. 
* Internal function is renamed to `class_suggest()` from `suggest_conversion()`.
* The [Workflow](http://eurobarometer.danielantal.eu/articles/workflow.html) vignette is open for consultation.

# eurobarometer 0.1.2
* `label_normalize()` has unit tests, new documentation, and the inputs parameters are synchronized with the other variable name conventions (in metadata). Open question: what to do with non-standard latin characters? [To be resolved in 0.1.3].
* `canonical_names()` is renamed to `label_suggest()`
* `naming functions` is renamed to `labelling functions` with the British spelling. 
* Three new Eurobarometer sample files to be used in vignettes and unit testing: `ZA7489_sample`, `ZA7576_sample`, `ZA7562_sample`. These samples contain countries that require special attention (`DE`, `GB`, `CY`, `MK`), some metadata, some demograpy variables, some trending (trust) variables and some ad hoc variables. 
* `read_example_file()` is a simple wrapper around `utils::data()` to 
mimick the data importing workflow with `haven::read_spss()` or other
importing functions in vignette examples and unit tests.
* `panel_create()` creates a skeleton panel with a unique panel id made of selected ID variables, such as the individually unique case ID and the doi of the survey. 
* `gesis_metadata_create()` can now take either a list of surveys, or a single survey data frame as an input, and returns the `filename` in a column. 

# Foreseen changes

* `code_nuts1()` and `code_nuts2()` will be deprecated, and included in the [regions](http://regions.danielantal.eu/) package.  A vignette will connect the two packages.
