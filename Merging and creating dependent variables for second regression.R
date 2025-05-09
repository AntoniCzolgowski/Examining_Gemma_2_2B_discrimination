library(dplyr)
library(readr)

# 1. Generate (or load) the complete set of subgroup combinations
countries <- c("Nigeria", "Indie", "USA", "Libia", "Argentyna",
               "Czechy", "Niemcy", "Rosja", "Australia", "Filipiny", "Japonia")
plec <- c("Male", "Female")
wyksztalcenie <- c("Lower", "Middle", "Higher")

# Ensure the city_size format matches the files (e.g., "10 000-500 000" without spaces after the hyphen)
city_size <- c("Under 10 000", "10 000-500 000", "500 000 and more")

age <- c("20-39", "40-59", "60-79")
work <- c("Employed", "Unemployed")
kids <- c("0 kids", "1-3 kids", "4 and more kids")
left_right <- c("Left", "Neutral", "Right")

master_subgroups <- expand.grid(
  country        = countries,
  plec           = plec,
  wyksztalcenie  = wyksztalcenie,
  city_size      = city_size,
  age            = age,
  work           = work,
  kids           = kids,
  left_right     = left_right,
  KEEP.OUT.ATTRS = FALSE,
  stringsAsFactors = FALSE
)

cat("Number of subgroups (master_subgroups):", nrow(master_subgroups), "\n")
# Should be 10692

# Function to conditionally recode country names
recode_country <- function(df) {
  df %>% mutate(country = case_when(
    country == "Argentina"    ~ "Argentyna", # Note: These are Polish names, keeping them as is if they are keys.
    country == "Australia"    ~ "Australia",
    country == "Czechia"      ~ "Czechy",
    country == "Germany"      ~ "Niemcy",
    country == "India"        ~ "Indie",
    country == "Japan"        ~ "Japonia",
    country == "Libya"        ~ "Libia",
    country == "Nigeria"      ~ "Nigeria",
    country == "Philippines"  ~ "Filipiny",
    country == "Russia"       ~ "Rosja",
    country == "USA"          ~ "USA",
    TRUE                      ~ country
  ))
}

# Key columns for joining
key_cols <- c("country", "plec", "wyksztalcenie", "city_size", "age", "work", "kids", "left_right")

# List of topics and corresponding column names in the files
# Ensure 'predictedCol' names match the columns in the *_predicted.csv files
topics_info <- list(
  list(
    topic        = "satysfakcja",
    predictedCol = "predicted_satysfakcja",
    modelCol     = "model_answer"
  ),
  list(
    topic        = "demokracja",
    predictedCol = "predicted_demokracja",
    modelCol     = "model_answer"
  ),
  list(
    topic        = "korupcja",
    predictedCol = "predicted_korupcja",   # Adjust name to match korupcja_predicted.csv if needed
    modelCol     = "model_answer"
  ),
  list(
    topic        = "technologia",
    predictedCol = "predicted_technologia",
    modelCol     = "model_answer"
  ),
  list(
    topic        = "gospodarka",
    predictedCol = "predicted_gospodarka",
    modelCol     = "model_answer"
  )
)

# 2. Iterate through each topic
for (info in topics_info) {
  
  topic        <- info$topic
  predictedCol <- info$predictedCol
  modelCol     <- info$modelCol
  
  cat("Processing topic:", topic, "\n")
  
  # File names
  pred_file  <- paste0(topic, "_predicted_1.csv")
  model_file <- paste0(topic, "-model-1.csv")
  
  # Load the data files
  df_pred  <- read_csv(pred_file, show_col_types = FALSE)
  df_model <- read_csv(model_file, show_col_types = FALSE)
  
  # 3. Standardize city_size format in predicted and model dataframes
  #    to match "10 000-500 000"
  df_pred <- df_pred %>%
    mutate(city_size = case_when(
      city_size == "10 000 - 500 000" ~ "10 000-500 000",
      TRUE ~ city_size
    ))
  
  df_model <- df_model %>%
    mutate(city_size = case_when(
      city_size == "10 000 - 500 000" ~ "10 000-500 000",
      TRUE ~ city_size
    ))
  
  # Recode country names in df_model
  df_model <- recode_country(df_model)
  
  # Check if key columns are present in the dataframes
  if (!all(key_cols %in% names(df_pred))) {
    stop("Required key columns missing in file: ", pred_file)
  }
  if (!all(key_cols %in% names(df_model))) {
    stop("Required key columns missing in file: ", model_file)
  }
  
  # Check for the presence of value columns
  if (!(predictedCol %in% names(df_pred))) {
    stop("Column ", predictedCol, " not found in file ", pred_file)
  }
  if (!(modelCol %in% names(df_model))) {
    stop("Column ", modelCol, " not found in file ", model_file)
  }
  
  # Rename value columns for consistent merging into master_subgroups
  df_pred  <- df_pred  %>% rename(tmp_pred = all_of(predictedCol))
  df_model <- df_model %>% rename(tmp_model = all_of(modelCol))
  
  # Merge predicted data (left join)
  master_subgroups <- master_subgroups %>%
    left_join(
      df_pred %>% select(all_of(key_cols), tmp_pred),
      by = key_cols
    )
  
  # Merge model data
  master_subgroups <- master_subgroups %>%
    left_join(
      df_model %>% select(all_of(key_cols), tmp_model),
      by = key_cols
    )
  
  # Calculate the difference (predicted - model) and round to 2 decimal places
  diff_col_name <- paste0(topic, "-roznica") # This creates column names like "satysfakcja-roznica"
  master_subgroups[[diff_col_name]] <- round(master_subgroups$tmp_pred - master_subgroups$tmp_model, 2)
  
  # Remove temporary columns used for merging
  master_subgroups <- master_subgroups %>% select(-tmp_pred, -tmp_model)
}

# 4. Save the merged data
write_csv(master_subgroups, "merged.csv")
cat("Results saved to file merged.csv\n")

# 5. Count non-NA values in the difference columns (as a sanity check)
wynik <- read_csv("merged.csv", show_col_types = FALSE)
last5 <- tail(names(wynik), 5) # Assumes the last 5 columns are the difference columns
counts <- wynik %>% summarise(across(all_of(last5), ~ sum(!is.na(.))))
cat("Count of non-NA values in the last 5 columns (differences):\n")
print(counts)



library(dplyr)
library(readr)

# 1. Load the merged.csv file
input_file <- "merged.csv"
master_subgroups <- read_csv(input_file, show_col_types = FALSE)

# 2. Add new columns: natural logarithm of the absolute differences, rounded to 3 decimal places
#    Column names like `satysfakcja-roznica` are used directly here.
master_subgroups <- master_subgroups %>%
  mutate(
    `ln(|satysfakcja|)` = round(log(abs(`satysfakcja-roznica`)), 3),
    `ln(|demokracja|)` = round(log(abs(`demokracja-roznica`)), 3),
    `ln(|korupcja|)` = round(log(abs(`korupcja-roznica`)), 3),
    `ln(|technologia|)` = round(log(abs(`technologia-roznica`)), 3),
    `ln(|gospodarka|)` = round(log(abs(`gospodarka-roznica`)), 3)
  )

# 3. Save the dataframe with the new log-transformed columns to a new file
output_file <- "merged_with_ln.csv"
write_csv(master_subgroups, output_file)

cat("Results with new log-transformed columns saved to file", output_file, "\n")
