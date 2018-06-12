using NameToGender
using Base.Test
using Missings



@testset "Gender Usage Enum" begin
    names = ["Sally", "Tom", "Bill", "Ann"]
    genders = classify_gender.(names)
    @test names[genders .>= MostlyFemale] == ["Sally", "Ann"]
    @test names[genders .<= MostlyMale] == ["Tom", "Bill"]
end




@testset "Classify" begin
	@testset "Basic" begin
		@test classify_gender("Bob") == Male
		@test classify_gender("Sally") == Female
		@test classify_gender("Pauley") == Androgynous
	end

	@testset "unicode" begin
		@test classify_gender("Álfrún") == Female
		@test classify_gender("Ayşe") == Female
		@test classify_gender("Gavriliţă") == Female
		@test classify_gender("İsmet") == Male
		@test classify_gender("Snæbjörn") == Male
	end

	@testset "country" begin
		@test classify_gender("Jamie") == MostlyFemale
		@test classify_gender("Jamie", "great_britain") == MostlyMale
		@test classify_gender("Alžbeta", "slovakia") == Female
		@test classify_gender("Buğra", "turkey") == Male
	end
	
	@testset "composite_name" begin
		@test classify_gender("María del Rosario") == Female
		@test classify_gender("Maria de Jesus") == Female
		@test classify_gender("Maria") == Female
	end
    
    @testset "Missing Names" begin
        @test classify_gender("ZZZAAZZ") === missing
        @test classify_gender("Buğra", "great_britain") === missing
    end


	@testset "case" begin
		caseless_detector = GenderDetector(case_sensitive=false)
		
		@testset "basic" begin
			classify_gender("sally"; detector=caseless_detector) == Female
			classify_gender("Sally"; detector=caseless_detector) == Female
		end
		
		@testset "Unicode" begin
			classify_gender("aydın"; detector=caseless_detector) == Male
			classify_gender("Aydın"; detector=caseless_detector) == Male
		end
		
		@testset "country" begin
			@test classify_gender("Jamie"; detector=caseless_detector) == MostlyFemale
			@test classify_gender("Jamie", "great_britain"; detector=caseless_detector) == MostlyMale
			@test classify_gender("jamie"; detector=caseless_detector) == MostlyFemale
			@test classify_gender("jamie", "great_britain"; detector=caseless_detector) == MostlyMale
		end
	end
end
