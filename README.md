# NameToGender

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaText.github.io/NameToGender.jl/stable)
[![Latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaText.github.io/NameToGender.jl/latest)
[![Build Status](https://travis-ci.org/JuliaText/NameToGender.jl.svg?branch=master)](https://travis-ci.org/JuliaText/NameToGender.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/JuliaText/NameToGender.jl?svg=true)](https://ci.appveyor.com/project/JuliaText/NameToGender-jl)
[![CodeCov](https://codecov.io/gh/JuliaText/NameToGender.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaText/NameToGender.jl)
[![Coveralls](https://coveralls.io/repos/github/JuliaText/NameToGender.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaText/NameToGender.jl?branch=master)

* NB: This is a generally terrible idea and should generally be avoided.*

Since there is not direct mapping, and even names we have as `Male` or `Female` are still by no means fully certain.
And while there are names as `Androgynous` this does not reflect anywhere near the reality of nonbinary genders.
If designing data collection for demographic purposes, and you want a gender field, include one (and be sure to also allow a free-text option).

You definately should not use this package to make inferences about individual names.
With that said, for some basic statistics of large populations, particularly for with-in countries that we have data for (using the 2 arg form), its probably not completely misleading.
For example (and the reason this was created), when looking at a dataset of all papers published for a field, then this could be used to judge statistics like the portion of papers that have all male authors, vs all female authors.
Even in such large scale population statistics, this should still not be used as actual data for purposes of study or policy.

## Usage


NameToGender exports 1 function with two methods: `classify_gender(name)` and `classify_gender(name, country)`.
The latter is country sensitive. See the doc strings for more information on that.

`classify_gender` returns a value from the `GenderUsage` Enum:

```
@enum GenderUsage Male=-2 MostlyMale=-1 Androgynous=0 MostlyFemale=1 Female=2
```

You can use that directly e.g.
```
julia> classify_gender("Billie")
MostlyFemale::NameToGender.GenderUsage = 1

julia> classify_gender("Ada")
Female::NameToGender.GenderUsage = 2
```

or  via comparason (though that does man remembering the Enum's order)

```
julia> people = ["Billie", "Ada", "Tom", "Jon", "Sally"]
5-element Array{String,1}:
 "Billie"
 "Ada"
 "Tom"
 "Jon"
 "Sally"

julia> prob_ladies = people[classify_gender.(people) .>= MostlyFemale ]
3-element Array{String,1}:
 "Billie"
 "Ada"
 "Sally"
```

If a name is not found in the database of names then `missing` is returned.

```
julia> using Missings # Required in julia 0.6 for ismissing etc.

julia> classify_gender("Linden")
missing

julia> ismissing.(classify_gender.(["Linden", "Lyndon"]))
2-element BitArray{1}:
  true
  false
```


## License and Origin
This code is liscenced GPLv3+. See license.txt.
This code is based on 
 - 2016 Lead Ratings --  gender-guesser (Python)
 - 2013 Ferhat Elmas --  SexMachine (Python)
 - 2007 Jörg Michael -- gender.c (C)


Note: 
The data file nam_dict.txt is released under the GNU Free Documentation License.


