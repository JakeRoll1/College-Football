# Install pacman and cfbfastr
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load_current_gh("sportsdataverse/cfbfastR", dependencies = TRUE, update = TRUE)

# Install cfbplotr
if (!require("remotes")) install.packages("remotes")
remotes::install_github("sportsdataverse/cfbplotR")

# Load necessary packages
library(cfbfastR)
library(tidyverse)
library(gt)
library(gtExtras)
library(cfbplotR)
library(cbbplotR)

# Filter College Football data so it is only the two QB's we want
UK_USC <- cfbfastR::cfbd_game_player_stats(year = 2024, week = 1, conference = "SEC") %>%
  # Replace NA values as 0
  replace(is.na(.), 0) %>%
  # Create Completion % Column 
  mutate(CMP_PCT = passing_completions / passing_attempts *100) %>%
  # Create TO column
  mutate(TO = (passing_int + fumbles_lost)) %>%
  # Filter our two QB's
  filter(athlete_name == c("Lanorris Sellers" ,"Brock Vandagriff")) %>%
  # Correct name capitalization.
  mutate(athlete_name = str_replace(athlete_name, "Lanorris", "LaNorris")) %>%
  # Filter the statistics we want
  select(team, athlete_id, athlete_name, passing_yds, CMP_PCT, passing_td, rushing_yds, rushing_avg, rushing_td, TO, passing_qbr) 

UK_USC %>%
  # Create gt table from our dataframe
  gt() %>%
  # Get team logos
  gt_fmt_cfb_logo("team") %>%
  # Get player headshots
  gt_fmt_cfb_headshot("athlete_id") %>%
  # Set a NY times theme
  gt_theme_nytimes() %>%
  # Set table font
  gt_set_font("Roboto") %>%
  
  # Rename columns
  cols_label(athlete_name = "Name", athlete_id = "QB", passing_yds = "Pass YDs", CMP_PCT = "CMP %", passing_td = "Pass TDs", rushing_yds = "Rush YDs", rushing_avg = "Rush AVG", rushing_td = "Rush TDs", passing_qbr = "QBR") %>%
  cols_align(columns = everything(), "center") %>%
  # Create table title and subtitles
  tab_header(
    title = "Kentucky vs. South Carolina QB Preview",
    subtitle = "QB's Week One Performances")  %>%
  tab_source_note("Data by CollegeFootballData & cfbfastr - Table by @JakesBBN") %>%
  
  # Add table style to make columns bold and add dividers between columns
  tab_style(locations = cells_column_labels(everything()), style = cell_text(weight = 'bold', color = "black")) %>%
  gt_add_divider(team, include_labels = FALSE, color = 'black', weight = px(1.5)) %>% 
  gt_add_divider(athlete_name, include_labels = FALSE, color = 'black', weight = px(1.5)) %>%
  gt_add_divider(passing_yds, include_labels = FALSE, color = 'black', weight = px(1.5)) %>%
  gt_add_divider(CMP_PCT, include_labels = FALSE, color = 'black', weight = px(1.5)) %>%
  gt_add_divider(passing_td, include_labels = FALSE, color = 'black', weight = px(1.5)) %>%
  gt_add_divider(rushing_yds, include_labels = FALSE, color = 'black', weight = px(1.5)) %>% 
  gt_add_divider(rushing_avg, include_labels = FALSE, color = 'black', weight = px(1.5)) %>%
  gt_add_divider(rushing_td, include_labels = FALSE, color = 'black', weight = px(1.5)) %>%
  gt_add_divider(TO, include_labels = FALSE, color = 'black', weight = px(1.5)) %>%
  gt_add_divider(passing_qbr, include_labels = FALSE, color = 'black', weight = px(1.5)) %>%
  
  # Limit Completion % column to only 2 values after the decimal.
  fmt_number(columns = CMP_PCT, decimals = 2) %>%
  # Theme for cell fill in on QBR column
  gt_hulk_col_numeric(passing_qbr) %>%
  # Add larger spaces in cells
  opt_horizontal_padding(2.5) %>%
  # Lower source notes
  tab_options(source_notes.padding = px(12))




