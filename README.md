# reproducibleRchunks


## Demo

Install the package and render `test.Rmd` to assess reproducibility of its R code chunks. Each code chunk will render a reproducibility report. One chunk is set up to fail to demonstrate the package.

## Mechanics

The package executes reproducibleR code chunks as regular R code and gathers information about all variables that are newly defined in the chunk. The contents of those variables are stored in a separate JSON data file (which is labelled according to the original Markdown file and the chunk label). Once the document is re-generated and JSON data files exist, their content is checked against the newly computed chunk variables for identity.

Here is an example of how the contents of two objects are stored, which is a single variable called `numbers` with a vector of five numbers `[0.874094, -1.6943659, -0.8961591, 1.00840087, 1.61713635]` (rounded to a specified precision):

```{json}
{
  "type": "list",
  "attributes": {
    "names": {
      "type": "character",
      "attributes": {},
      "value": ["numbers"]
    }
  },
  "value": [
    {
      "type": "double",
      "attributes": {},
      "value": [0.874094, -1.6943659, -0.8961591, 1.00840087, 1.61713635]
    }
  ]
}
```
## Notes

Do not store critical and/or large data in reproducibleR chunks. In particular, do not store raw data (too large and possible breach of data protection laws), passwords (security risk as they are stored in clear text), etc.
