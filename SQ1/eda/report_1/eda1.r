# Exploratory Data Analysis - Edmonton Cafes
# Loading required libraries
library(RSQLite)
library(ggplot2)
library(dplyr)
library(tidyr)

# Connect to the SQLite database
con <- dbConnect(SQLite(), "SQ1/data/edmonton_cafes.sqlite")

# Read the data
cafes <- dbReadTable(con, "cafes")

# Close the database connection
dbDisconnect(con)

# Create prints directory if it doesn't exist
if (!dir.exists("prints")) {
  dir.create("prints", recursive = TRUE)
}

# Display basic info about the dataset
cat("Dataset shape:", dim(cafes), "\n")
cat("Column names:\n")
print(names(cafes))

# 1. Bar chart of cafe types
type_counts <- cafes %>%
  count(Type, sort = TRUE)

p1 <- ggplot(type_counts, aes(x = reorder(Type, n), y = n, fill = Type)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Distribution of Cafe Types in Edmonton",
       x = "Cafe Type",
       y = "Number of Brands") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("SQ1/eda/report_1/prints/01_cafe_types_distribution.png", p1, width = 10, height = 6, dpi = 300)
cat("Saved: 01_cafe_types_distribution.png\n")

# 2. Histogram of number of locations per brand
p2 <- cafes %>%
    filter(NumberOfLocations <= 20) %>%
    select(BrandName, NumberOfLocations) %>%
    arrange(-NumberOfLocations) %>%
    ggplot(aes(y = NumberOfLocations, x = BrandName)) +
    geom_col() +
    theme(axis.text.x = element_blank())  

ggsave("SQ1/eda/report_1/prints/02_locations_histogram.png", p2, width = 10, height = 6, dpi = 300)
cat("Saved: 02_locations_histogram.png\n")
print(p2)

# 3. Violin plot of locations by cafe type
p3 <- ggplot(cafes, aes(x = Type, y = NumberOfLocations, fill = Type)) +
  geom_violin() +
  coord_flip() +
  labs(title = "Number of Locations by Cafe Type",
       x = "Cafe Type",
       y = "Number of Locations") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("SQ1/eda/report_1/prints/03_locations_by_type_violin.png", p3, width = 10, height = 6, dpi = 300)
cat("Saved: 03_locations_by_type_violin.png\n")

# 4. Stacked bar chart of sector distribution
# Prepare sector data
sector_data <- cafes %>%
  select(BrandName, Type, MatureArea, NorthSector, NortheastSector, 
         NorthwestSector, SoutheastSector, SouthwestSector, WestSector) %>%
  pivot_longer(cols = MatureArea:WestSector, 
               names_to = "Sector", 
               values_to = "Count") %>%
  filter(Count > 0) %>%
  group_by(Sector) %>%
  summarise(Total = sum(Count), .groups = 'drop')

p4 <- ggplot(sector_data, aes(x = reorder(Sector, Total), y = Total, fill = Sector)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Total Cafe Locations by Sector",
       x = "Sector",
       y = "Number of Locations") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("SQ1/eda/report_1/prints/04_sector_distribution.png", p4, width = 10, height = 6, dpi = 300)
cat("Saved: 04_sector_distribution.png\n")

# 5. Time series analysis (using historical data from 2000-2025)
# Prepare time series data
years_cols <- paste0("Y", 2000:2025)
time_data <- cafes %>%
  select(all_of(years_cols)) %>%
  summarise_all(sum, na.rm = TRUE) %>%
  pivot_longer(everything(), names_to = "Year", values_to = "TotalLocations") %>%
  mutate(Year = as.numeric(gsub("Y", "", Year)))

p5 <- ggplot(time_data, aes(x = Year, y = TotalLocations)) +
  geom_line(color = "darkgreen", size = 1.2) +
  geom_point(color = "darkgreen", size = 2) +
  labs(title = "Edmonton Cafe Locations Over Time (2000-2025)",
       x = "Year",
       y = "Total Number of Locations") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(2000, 2025, 5))

ggsave("SQ1/eda/report_1/prints/05_time_series_analysis.png", p5, width = 12, height = 6, dpi = 300)
cat("Saved: 05_time_series_analysis.png\n")

# 6. Top 10 brands by number of locations
top_brands <- cafes %>%
  arrange(desc(NumberOfLocations)) %>%
  head(10)

p6 <- ggplot(top_brands, aes(x = reorder(BrandName, NumberOfLocations), 
                             y = NumberOfLocations, 
                             fill = Type)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 10 Cafe Brands by Number of Locations",
       x = "Brand Name",
       y = "Number of Locations",
       fill = "Type") +
  theme_minimal()

ggsave("SQ1/eda/report_1/prints/06_top_10_brands.png", p6, width = 12, height = 8, dpi = 300)
cat("Saved: 06_top_10_brands.png\n")

# 7 HIstogram, numberof locatoins per current type of the brand

p7 <- cafes %>%
    # filter(Type == "Independent") %>%
    select(BrandName, NumberOfLocations, Type) %>%
    arrange(-NumberOfLocations)


g7_2 <- p7 %>% 
    filter(Type == "Chain") %>%
    ggplot(aes(y = NumberOfLocations, x = BrandName)) +
    geom_col() +
    labs(title = "Histogram of Locations for Independent Cafe Brands",
         x = "Number of Locations",
         y = "Count of Brands") %>%
         print()

g7_3 <- p7 %>% 
    filter(Type == "Local Chain") %>%
    ggplot(aes(y  = NumberOfLocations, x = BrandName)) +
    geom_col()
    labs(title = "Histogram of Locations for Franchise Cafe Brands",
         x = "Number of Locations",
         y = "Count of Brands") %>%
         print()

g7_4 <- p7 %>% 
    filter(Type == "Local Roaster/Chain") %>%
    ggplot(aes(y = NumberOfLocations, x = BrandName)) +
    geom_col(binwidth = 1, fill = "red", color = "black") +
    labs(title = "Histogram of Locations for Franchise Cafe Brands",
         x = "Number of Locations",
         y = "Count of Brands") %>%
         print()

# Save the plots
ggsave("SQ1/eda/report_1/prints/07_chain_brands_locations.png", g7_2, width = 10, height = 6, dpi = 300)
ggsave("SQ1/eda/report_1/prints/07_local_chain_brands_locations.png", g7_3, width = 10, height = 6, dpi = 300)
ggsave("SQ1/eda/report_1/prints/07_local_roaster_chain_brands_locations.png", g7_4, width = 10, height = 6, dpi = 300)

# Summary statistics
cat("\nSummary Statistics:\n")
cat("Total number of cafe brands:", nrow(cafes), "\n")
cat("Total number of locations:", sum(cafes$NumberOfLocations), "\n")
cat("Average locations per brand:", round(mean(cafes$NumberOfLocations), 2), "\n")
cat("Most common cafe type:", type_counts$Type[1], "(", type_counts$n[1], "brands)\n")

# All plots saved to prints/ folder
cat("\nAll graphs have been saved to the 'prints' folder!\n")
