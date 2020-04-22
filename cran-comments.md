## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results

There were no ERRORs or WARNINGs. 
  
There was 1 NOTE: 
  
- Possibly mis-spelled words in DESCRIPTION:
   
    - BitMEX (3:25, 10:50)
    - cryptocurrency (10:57)


Spellings are acceptable given package context

# bitmexr 0.2.2 - Resubmission 2

CRAN notes:

1. Update copyright holder
2. Please replace \dontrun{} with \donttest{}.
3. Enable messages printed to the console to be easily suppressed

Action taken:

1. Updated "cph" in description
2. Replaced \dontrun with \donttest
3. Added verbose option to functions that printed information to the console. Now no information is printed by default.

# bitmexr 0.2.1 - Resubmission 1

CRAN notes from initial submission:

>    Found the following (possibly) invalid file URI:
     URI: CODE_OF_CONDUCT.md
       From: README.md

Action taken:

- Specified full URL link to code of conduct in readme.md file.

Additional changes:

- Minor edits to documentation to improve clarity
- Included additional filter step within map_* functions to return specified end date.

# bitmexr 0.2.0

Initial CRAN submission
