Rscripts supporting filemaker pro demo.


Example command line use (use from project working directory)
```
Rscript -e "rmarkdown::render('output.Rmd'), params = list(\
    filepath = 'PATH_TO_DATA', \
    address = 'YOUR_ADDRESS', \
    name = 'NAME_OF_ACCOUNT' \
  )"

open output.html
```

```
Rscript -e "rmarkdown::render('output.Rmd', params = list(\
    filepath = 'data/TheButton-0x2b0ec0993a00b2ea625e3b37fcc74742f43a72fe.csv', \
    address = '0x2b0ec0993a00b2ea625e3b37fcc74742f43a72fe', \
    name = 'The Button' \
  ))"
open output.html
```



Other ideas:

- see WHERE on a contract your activity took place. E.g. line chart of activity on a contract, with red dots on your transactions. Would require a different script with "highlighted account" parameter.