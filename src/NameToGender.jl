__precompile__()
module NameToGender
export GenderUsage, classify_gender, GenderDetector
export Female, Male, MostlyFemale, MostlyMale, Androgynous

COUNTRIES = """great_britain ireland usa italy malta portugal spain france
			   belgium luxembourg the_netherlands east_frisia germany austria
			   swiss iceland denmark norway sweden finland estonia latvia
			   lithuania poland czech_republic slovakia hungary romania
			   bulgaria bosniaand croatia kosovo macedonia montenegro serbia
			   slovenia albania greece russia belarus moldova ukraine armenia
			   azerbaijan georgia the_stans turkey arabia israel china india
			   japan korea vietnam other_countries
			 """|>split


@enum GenderUsage Male=-2 MostlyMale=-1 Androgynous=0 MostlyFemale=1 Female=2

struct GenderDetector
    case_sensitive::Bool
    names::Dict{String, Dict{GenderUsage, Vector{Int8}}}
end




function parse_country_values(country_values::Vector{Char})
    vals = ifelse.(country_values.==' ', '0', country_values)
    parse.(Int8, vals, 16)
end

function GenderDetector(;
    case_sensitive=true,
    datapath = joinpath(@__DIR__, "..", "deps", "data", "nam_dict.txt")
)

    names = Dict{String, Dict{GenderUsage, Vector{Int8}}}()
	function add_name(name, gender, country_values)
	    if !case_sensitive
            name=lowercase(name)
        end

     	if '+' in name
            for altname in replace.(name, "+", [""," ", "-"])
                add_name(altname, gender, country_values)
            end
		else
            genders = get!(Dict{GenderUsage, Vector{Int8}}, names, name)
            genders[gender] = parse_country_values(country_values)
		end
	end


    for line in eachline(datapath)
		(line[1]=='#' || line[1]=='=') && continue #skip comments
        country_values = collect(line)[31:end-1]
        marker, name, _ = split(line, ' '; limit=3, keep=false)

		if (marker == "M")
			add_name(name, Male, country_values)
        elseif (marker == "1M") || (marker == "?M")
			add_name(name, MostlyMale, country_values)
		elseif (marker == "F")
			add_name(name, Female, country_values)
        elseif (marker == "1F") || (marker == "?F")
			add_name(name, MostlyFemale, country_values)
		elseif (marker == "?")
			add_name(name, Androgynous, country_values)
		else
			error("Not sure what to do with a gender from $line")
		end
    end

    GenderDetector(case_sensitive, names)
end


const GENDER_DETECTOR = GenderDetector()

###########################################

function get_country_ind(country)
    country_ind = findfirst(COUNTRIES, country)
    if country_ind==0
        warn("Country $country not found. Defaulting to other_countries")
        country_ind = endof(COUNTRIES)
    end
    country_ind
end

function _classify_gender(cscore_fun, name, detector)
    if !detector.case_sensitive
       name=lowercase(name)
    end


    local most_likely_gender
    max_score = 0
    for (gender, c_scores) in detector.names[name]
        score = cscore_fun(c_scores)
        if score > max_score
            max_score = score
            most_likely_gender = gender
        end
    end
    if max_score == 0
        throw(BoundsError(name))
    end
    most_likely_gender
end

########################
"""
    classify_gender(name, detector = GENDER_DETECTOR)

Classify gender based on the name.
(Gender usage demographics are summed across all countries (without normalisation))
"""
function classify_gender(name; detector = GENDER_DETECTOR)
    _classify_gender(sum, name, detector)
end


"""
    classify_gender(name, country,  detector = GENDER_DETECTOR)

Classify the gender based on the usage in the given country.
Country can be any country from the list:
$COUNTRIES
"""
function classify_gender(name, country;  detector = GENDER_DETECTOR)
    country_ind = get_country_ind(country)
    _classify_gender(name, detector) do c_score
        c_score[country_ind]
    end
end



end
