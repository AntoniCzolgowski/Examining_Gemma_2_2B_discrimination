# ------------------------------------
# 1. Define the model intercept (constant)
# ------------------------------------
constant <- 6.849  # Model intercept value

# ------------------------------------
# 2. Define coefficients for predictor variables
#    Reference categories: USA, Female, Lower, Under 10,000, 20-39, Unemployed, 0 kids, Neutral
# ------------------------------------
country_levels <- c(
  "USA"        = 0,       
  "Argentyna"  = 0.381,
  "Australia"  = 0.225,
  "Czechy"     = -0.195,
  "Niemcy"     = 0.544,
  "Indie"      = -0.066,
  "Japonia"    = -0.641,
  "Libia"      = 0.434,
  "Nigeria"    = -1.523,
  "Filipiny"   = 0.069,
  "Rosja"      = -1.130
)

plec_levels <- c(
  "Female" = 0,      # reference category
  "Male"   = -0.142
)

wyksztalcenie_levels <- c(
  "Lower"  = 0,      # reference category
  "Middle" = 0.217,
  "Higher" = 0.550
)

city_size_levels <- c(
  "Under 10 000"      = 0,       # reference category
  "10 000 - 500 000"  = -0.177,
  "500 000 and more"  = -0.118
)

age_levels <- c(
  "20-39" = 0,       # reference category
  "40-59" = -0.118,
  "60-79" = 0.094
)

work_levels <- c(
  "Unemployed" = 0,   # reference category
  "Employed"   = 0.183
)

kids_levels <- c(
  "0 kids"          = 0,      # reference category
  "1-3 kids"        = 0.241,
  "4 and more kids" = 0.208
)

left_right_levels <- c(
  "Neutral" = 0,      # reference category
  "Left"    = -0.203,
  "Right"   = 0.369
)

# ------------------------------------
# 3. Generate all combinations of predictor variable levels
# ------------------------------------
combinations <- expand.grid(
  country       = names(country_levels),
  plec          = names(plec_levels),
  wyksztalcenie = names(wyksztalcenie_levels),
  city_size     = names(city_size_levels),
  age           = names(age_levels),
  work          = names(work_levels),
  kids          = names(kids_levels),
  left_right    = names(left_right_levels),
  stringsAsFactors = FALSE
)

# ------------------------------------
# 4. Calculate predicted satisfaction scores, including interaction effects
# ------------------------------------
combinations$predicted_satysfakcja <- apply(combinations, 1, function(row) {
  # Main effects
  main_effect <- constant +
    country_levels[ row["country"] ] +
    plec_levels[ row["plec"] ] +
    wyksztalcenie_levels[ row["wyksztalcenie"] ] +
    city_size_levels[ row["city_size"] ] +
    age_levels[ row["age"] ] +
    work_levels[ row["work"] ] +
    kids_levels[ row["kids"] ] +
    left_right_levels[ row["left_right"] ]
  
  # Interaction effects
  interaction_effect <- 0
  
  # Interaction: Nigeria * 1-3 kids
  if (row["country"] == "Nigeria" && row["kids"] == "1-3 kids") {
    interaction_effect <- interaction_effect + (-0.313)
  }
  # Interaction: Nigeria * age 60-79
  if (row["country"] == "Nigeria" && row["age"] == "60-79") {
    interaction_effect <- interaction_effect + 0.690
  }
  # Interaction: Libia * Middle education
  if (row["country"] == "Libia" && row["wyksztalcenie"] == "Middle") {
    interaction_effect <- interaction_effect + 0.386
  }
  # Interaction: Rosja * Male
  if (row["country"] == "Rosja" && row["plec"] == "Male") {
    interaction_effect <- interaction_effect + 0.397
  }
  # Interaction: Rosja * 4 and more kids
  if (row["country"] == "Rosja" && row["kids"] == "4 and more kids") {
    interaction_effect <- interaction_effect + 0.822
  }
  
  return(main_effect + interaction_effect)
})

# ------------------------------------
# 5. Save the results to a CSV file
# ------------------------------------
output_filename <- "satysfakcja_predicted_1.csv"
write.csv(combinations, file = output_filename, row.names = FALSE)

cat("Results saved to file:", output_filename, "\n")
















# ------------------------------------
# 1. Define the model intercept (constant)
# ------------------------------------
constant <- 7.409  # Model intercept value

# ------------------------------------
# 2. Define coefficients for predictor variables
#    Reference categories: USA, Female, Lower, Under 10,000, 20-39, Unemployed, 0 kids, Neutral
# ------------------------------------
country_levels <- c(
  "USA"        = 0,       
  "Argentyna"  = 0.665,
  "Australia"  = 0.567,
  "Czechy"     = -0.250,
  "Niemcy"     = 1.170,
  "Indie"      = 0.337,
  "Japonia"    = 0.247,
  "Libia"      = 0.036,
  "Nigeria"    = 0.185,
  "Filipiny"   = -0.589,
  "Rosja"      = -1.001
)

plec_levels <- c(
  "Female" = 0,      # reference category
  "Male"   = 0.074
)

wyksztalcenie_levels <- c(
  "Lower"  = 0,      # reference category
  "Middle" = 0.198,
  "Higher" = 0.655
)

city_size_levels <- c(
  "Under 10 000"      = 0,       # reference category
  "10 000 - 500 000"  = -0.014,
  "500 000 and more"  = 0.166
)

age_levels <- c(
  "20-39" = 0,       # reference category
  "40-59" = 0.372,
  "60-79" = 0.420
)

work_levels <- c(
  "Unemployed" = 0,   # reference category
  "Employed"   = -0.020
)

kids_levels <- c(
  "0 kids"          = 0,      # reference category
  "1-3 kids"        = 0.033,
  "4 and more kids" = -0.083
)

left_right_levels <- c(
  "Neutral" = 0,      # reference category
  "Left"    = 0.214,
  "Right"   = 0.471
)

# ------------------------------------
# 3. Generate all combinations of predictor variable levels
# ------------------------------------
combinations <- expand.grid(
  country       = names(country_levels),
  plec          = names(plec_levels),
  wyksztalcenie = names(wyksztalcenie_levels),
  city_size     = names(city_size_levels),
  age           = names(age_levels),
  work          = names(work_levels),
  kids          = names(kids_levels),
  left_right    = names(left_right_levels),
  stringsAsFactors = FALSE
)

# ------------------------------------
# 4. Calculate predicted democracy scores, including interaction effects
# ------------------------------------
combinations$predicted_demokracja <- apply(combinations, 1, function(row) {
  # Main effects
  main_effect <- constant +
    country_levels[ row["country"] ] +
    plec_levels[ row["plec"] ] +
    wyksztalcenie_levels[ row["wyksztalcenie"] ] +
    city_size_levels[ row["city_size"] ] +
    age_levels[ row["age"] ] +
    work_levels[ row["work"] ] +
    kids_levels[ row["kids"] ] +
    left_right_levels[ row["left_right"] ]
  
  # Interaction effects
  interaction_effect <- 0
  
  # Interaction: Middle education * age 60-79
  if (row["wyksztalcenie"] == "Middle" && row["age"] == "60-79") {
    interaction_effect <- interaction_effect + 0.320
  }
  # Interaction: Australia * Left
  if (row["country"] == "Australia" && row["left_right"] == "Left") {
    interaction_effect <- interaction_effect + 0.314
  }
  # Interaction: Libia * city size 10,000 - 500,000
  if (row["country"] == "Libia" && row["city_size"] == "10 000 - 500 000") {
    interaction_effect <- interaction_effect + 0.349
  }
  # Interaction: Nigeria * Left
  if (row["country"] == "Nigeria" && row["left_right"] == "Left") {
    interaction_effect <- interaction_effect + (-0.601)
  }
  
  return(main_effect + interaction_effect)
})

# ------------------------------------
# 5. Save the results to a CSV file
# ------------------------------------
output_filename <- "demokracja_predicted_1.csv"
write.csv(combinations, file = output_filename, row.names = FALSE)

cat("Results saved to file:", output_filename, "\n")










# ------------------------------------
# 1. Define the model intercept (constant)
# ------------------------------------
constant <- 6.521  # Model intercept value

# ------------------------------------
# 2. Define coefficients for predictor variables
#    Reference categories: USA, Female, Lower, Under 10,000, 20-39, Unemployed, 0 kids, Neutral
# ------------------------------------
country_levels <- c(
  "USA"        = 0,       
  "Argentyna"  = 0.114,
  "Australia"  = 0.149,
  "Czechy"     = -0.021,
  "Niemcy"     = 0.095,
  "Indie"      = 0.379,
  "Japonia"    = 0.372,
  "Libia"      = 1.928,
  "Nigeria"    = 1.032,
  "Filipiny"   = -0.173,
  "Rosja"      = 0.668
)

plec_levels <- c(
  "Female" = 0,      # reference category
  "Male"   = 0.170
)

wyksztalcenie_levels <- c(
  "Lower"  = 0,      # reference category
  "Middle" = 0.182,
  "Higher" = 0.651
)

city_size_levels <- c(
  "Under 10 000"      = 0,       # reference category
  "10 000 - 500 000"  = 0.000,
  "500 000 and more"  = 0.224
)

age_levels <- c(
  "20-39" = 0,       # reference category
  "40-59" = 0.087,
  "60-79" = 0.092
)

work_levels <- c(
  "Unemployed" = 0,   # reference category
  "Employed"   = 0.055
)

kids_levels <- c(
  "0 kids"          = 0,      # reference category
  "1-3 kids"        = -0.150,
  "4 and more kids" = -0.147
)

left_right_levels <- c(
  "Neutral" = 0,      # reference category
  "Left"    = 0.188,
  "Right"   = 0.427
)

# ------------------------------------
# 3. Generate all combinations of predictor variable levels
# ------------------------------------
combinations <- expand.grid(
  country       = names(country_levels),
  plec          = names(plec_levels),
  wyksztalcenie = names(wyksztalcenie_levels),
  city_size     = names(city_size_levels),
  age           = names(age_levels),
  work          = names(work_levels),
  kids          = names(kids_levels),
  left_right    = names(left_right_levels),
  stringsAsFactors = FALSE
)

# ------------------------------------
# 4. Calculate predicted technology scores, including interaction effects
# ------------------------------------
combinations$predicted_technologia <- apply(combinations, 1, function(row) {
  # Main effects
  main_effect <- constant +
    country_levels[ row["country"] ] +
    plec_levels[ row["plec"] ] +
    wyksztalcenie_levels[ row["wyksztalcenie"] ] +
    city_size_levels[ row["city_size"] ] +
    age_levels[ row["age"] ] +
    work_levels[ row["work"] ] +
    kids_levels[ row["kids"] ] +
    left_right_levels[ row["left_right"] ]
  
  # Interaction effects
  interaction_effect <- 0
  
  # Interaction: Libia * Left
  if (row["country"] == "Libia" && row["left_right"] == "Left") {
    interaction_effect <- interaction_effect + (-0.769)
  }
  # Interaction: Rosja * Higher education
  if (row["country"] == "Rosja" && row["wyksztalcenie"] == "Higher") {
    interaction_effect <- interaction_effect + (-0.360)
  }
  # Interaction: Argentyna * Middle education
  if (row["country"] == "Argentyna" && row["wyksztalcenie"] == "Middle") {
    interaction_effect <- interaction_effect + 0.780
  }
  
  return(main_effect + interaction_effect)
})

# ------------------------------------
# 5. Save the results to a CSV file
# ------------------------------------
output_filename <- "technologia_predicted_1.csv"
write.csv(combinations, file = output_filename, row.names = FALSE)

cat("Results saved to file:", output_filename, "\n")
















# ------------------------------------
# 1. Define the model intercept (constant)
# ------------------------------------
constant <- 4.393  # Model intercept value

# ------------------------------------
# 2. Define coefficients for predictor variables
#    Reference categories: USA, Female, Lower, Under 10,000, 20-39, Unemployed, 0 kids, Neutral
# ------------------------------------
country_levels <- c(
  "USA"        = 0,       
  "Argentyna"  = 0.796,
  "Australia"  = 1.021,
  "Czechy"     = 1.725,
  "Niemcy"     = 1.161,
  "Indie"      = 2.426,
  "Japonia"    = 0.536,
  "Libia"      = 1.676,
  "Nigeria"    = 2.643,
  "Filipiny"   = 1.301,
  "Rosja"      = 1.684
)

plec_levels <- c(
  "Female" = 0,      # reference category
  "Male"   = 0.194
)

wyksztalcenie_levels <- c(
  "Lower"  = 0,      # reference category
  "Middle" = 0.335,
  "Higher" = 0.533
)

city_size_levels <- c(
  "Under 10 000"      = 0,       # reference category
  "10 000 - 500 000"  = -0.140,
  "500 000 and more"  = -0.301
)

age_levels <- c(
  "20-39" = 0,       # reference category
  "40-59" = 0.035,
  "60-79" = -0.024
)

work_levels <- c(
  "Unemployed" = 0,   # reference category
  "Employed"   = 0.139
)

kids_levels <- c(
  "0 kids"          = 0,      # reference category
  "1-3 kids"        = 0.187,
  "4 and more kids" = 0.212
)

left_right_levels <- c(
  "Neutral" = 0,      # reference category
  "Left"    = -0.817,
  "Right"   = 0.439
)

# ------------------------------------
# 3. Generate all combinations of predictor variable levels
# ------------------------------------
combinations <- expand.grid(
  country       = names(country_levels),
  plec          = names(plec_levels),
  wyksztalcenie = names(wyksztalcenie_levels),
  city_size     = names(city_size_levels),
  age           = names(age_levels),
  work          = names(work_levels),
  kids          = names(kids_levels),
  left_right    = names(left_right_levels),
  stringsAsFactors = FALSE
)

# ------------------------------------
# 4. Calculate predicted economy scores, including interaction effects
# ------------------------------------
combinations$predicted_gospodarka <- apply(combinations, 1, function(row) {
  # Main effects
  main_effect <- constant +
    country_levels[ row["country"] ] +
    plec_levels[ row["plec"] ] +
    wyksztalcenie_levels[ row["wyksztalcenie"] ] +
    city_size_levels[ row["city_size"] ] +
    age_levels[ row["age"] ] +
    work_levels[ row["work"] ] +
    kids_levels[ row["kids"] ] +
    left_right_levels[ row["left_right"] ]
  
  # Interaction effects
  interaction_effect <- 0
  
  # Interaction: Indie * Male
  if (row["country"] == "Indie" && row["plec"] == "Male") {
    interaction_effect <- interaction_effect + (-0.390)
  }
  # Interaction: Higher education * age 60-79
  if (row["wyksztalcenie"] == "Higher" && row["age"] == "60-79") {
    interaction_effect <- interaction_effect + (-0.207)
  }
  # Interaction: city_size "500,000 and more" * Right
  if (row["city_size"] == "500 000 and more" && row["left_right"] == "Right") {
    interaction_effect <- interaction_effect + 0.369
  }
  # Interaction: Australia * Right
  if (row["country"] == "Australia" && row["left_right"] == "Right") {
    interaction_effect <- interaction_effect + 0.829
  }
  # Interaction: Indie * Left
  if (row["country"] == "Indie" && row["left_right"] == "Left") {
    interaction_effect <- interaction_effect + (-1.150)
  }
  # Interaction: Nigeria * age 60-79
  if (row["country"] == "Nigeria" && row["age"] == "60-79") {
    interaction_effect <- interaction_effect + 1.421
  }
  
  return(main_effect + interaction_effect)
})

# ------------------------------------
# 5. Save the results to a CSV file
# ------------------------------------
output_filename <- "gospodarka_predicted_1.csv"
write.csv(combinations, file = output_filename, row.names = FALSE)

cat("Results saved to file:", output_filename, "\n")









# ------------------------------------
# 1. Define the model intercept (constant)
# ------------------------------------
constant <- 7.527  # Model intercept value

# ------------------------------------
# 2. Define coefficients for predictor variables
#    Reference categories: USA, Female, Lower, Under 10,000, 20-39, Unemployed, 0 kids, Neutral
# ------------------------------------
country_levels <- c(
  "USA"        = 0,       
  "Argentyna"  = 0.964,
  "Australia"  = -0.450,
  "Czechy"     = -0.621,
  "Niemcy"     = -2.295,
  "Indie"      = 0.258,
  "Japonia"    = -0.735,
  "Libia"      = 1.409,
  "Nigeria"    = 1.049,
  "Filipiny"   = -0.869,
  "Rosja"      = 0.081
)

plec_levels <- c(
  "Female" = 0,      # reference category
  "Male"   = -0.034
)

wyksztalcenie_levels <- c(
  "Lower"  = 0,      # reference category
  "Middle" = 0.149,
  "Higher" = -0.057
)

city_size_levels <- c(
  "Under 10 000"      = 0,       # reference category
  "10 000 - 500 000"  = 0.185,
  "500 000 and more"  = -0.178
)

age_levels <- c(
  "20-39" = 0,       # reference category
  "40-59" = 0.123,
  "60-79" = 0.027
)

work_levels <- c(
  "Unemployed" = 0,   # reference category
  "Employed"   = -0.054
)

kids_levels <- c(
  "0 kids"          = 0,      # reference category
  "1-3 kids"        = 0.040,
  "4 and more kids" = -0.072
)

left_right_levels <- c(
  "Neutral" = 0,      # reference category
  "Left"    = 0.161,
  "Right"   = 0.003
)

# ------------------------------------
# 3. Generate all combinations of predictor variable levels
# ------------------------------------
combinations <- expand.grid(
  country       = names(country_levels),
  plec          = names(plec_levels),
  wyksztalcenie = names(wyksztalcenie_levels),
  city_size     = names(city_size_levels),
  age           = names(age_levels),
  work          = names(work_levels),
  kids          = names(kids_levels),
  left_right    = names(left_right_levels),
  stringsAsFactors = FALSE
)

# ------------------------------------
# 4. Calculate predicted corruption scores, including interaction effects
# ------------------------------------
combinations$predicted_korupcja <- apply(combinations, 1, function(row) {
  # Main effects
  main_effect <- constant +
    country_levels[ row["country"] ] +
    plec_levels[ row["plec"] ] +
    wyksztalcenie_levels[ row["wyksztalcenie"] ] +
    city_size_levels[ row["city_size"] ] +
    age_levels[ row["age"] ] +
    work_levels[ row["work"] ] +
    kids_levels[ row["kids"] ] +
    left_right_levels[ row["left_right"] ]
  
  # Interaction effects
  interaction_effect <- 0
  
  # Interaction: Australia * Higher education
  if (row["country"] == "Australia" && row["wyksztalcenie"] == "Higher") {
    interaction_effect <- interaction_effect + (-0.809)
  }
  # Interaction: Australia * Male
  if (row["country"] == "Australia" && row["plec"] == "Male") {
    interaction_effect <- interaction_effect + (-0.482)
  }
  # Interaction: Indie * Left (political view)
  if (row["country"] == "Indie" && row["left_right"] == "Left") {
    interaction_effect <- interaction_effect + (-1.220)
  }
  # Interaction: Niemcy * age 60-79
  if (row["country"] == "Niemcy" && row["age"] == "60-79") {
    interaction_effect <- interaction_effect + 0.446
  }
  
  return(main_effect + interaction_effect)
})

# ------------------------------------
# 5. Save the results to a CSV file
# ------------------------------------
output_filename <- "korupcja_predicted_1.csv"
write.csv(combinations, file = output_filename, row.names = FALSE)

cat("Results saved to file:", output_filename, "\n")
