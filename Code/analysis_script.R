## Code/analysis_script.R 
library(tidyverse)
library(here)
library(ggcorrplot)
library(corrplot)
library(glmnet)
library(knitr)

## 1. read data 
sleep_data <- read_csv(here("Data", "Sleep_Efficiency.csv"), show_col_types = FALSE)
colnames(sleep_data) <- c(
  "ID","age","gender","bedtime","wakeup_time","sleep_duration",
  "sleep_efficiency","rem_sleep_percentage","deep_sleep_percentage",
  "light_sleep_percentage","awakenings","caffeine_consumption",
  "alchol_consumption","smoking_status","exercise_frequency"
)

## 2. clean
sleep1 <- sleep_data %>% drop_na()

## 3. Table 1
desc_stats <- sleep1 %>% summarise(
  Avg_Age            = mean(age),
  Min_Age            = min(age),
  Max_Age            = max(age),
  Avg_SleepDuration  = mean(sleep_duration),
  Avg_SleepEfficiency= mean(sleep_efficiency),
  Avg_DeepSleepPct   = mean(deep_sleep_percentage),
  Avg_REM_SleepPct   = mean(rem_sleep_percentage),
  Avg_Awakenings     = mean(awakenings)
)

write_csv(desc_stats, here("Output", "table1_desc_stats.csv"))

## 4.Figure 1
p1 <- sleep1 %>% 
  ggplot(aes(x = caffeine_consumption, y = sleep_efficiency, color = gender)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, aes(group = gender)) +
  theme_minimal()

ggsave(
  filename = here("Output", "figure1_caffeine_vs_eff.png"),
  plot = p1,
  width = 6, height = 4, dpi = 300
)


