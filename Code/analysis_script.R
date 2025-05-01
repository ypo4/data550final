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

## 5. Other analyses

sleep2 <- sleep1
sleep2$smoking_status <- as.factor(ifelse(sleep2$smoking_status == "Yes", "0", "1"))
sleep2$gender <- as.factor(ifelse(sleep2$gender == "Female", "0", "1"))

# Fit the multiple linear regression model
f1 <- lm(sleep_efficiency ~ deep_sleep_percentage, data = sleep2)
f2 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings, data = sleep2)
f3 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption, data = sleep2)
f4 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption + smoking_status, data = sleep2)
f5 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption + smoking_status + exercise_frequency, data = sleep2)
f6 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption + smoking_status + exercise_frequency + age, data = sleep2)
f7 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption + smoking_status + exercise_frequency + age + caffeine_consumption, data = sleep2)
f8 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption + smoking_status + exercise_frequency + age + caffeine_consumption + rem_sleep_percentage, data = sleep2)
f9 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption + smoking_status + exercise_frequency + age + caffeine_consumption + rem_sleep_percentage + sleep_duration, data = sleep2)
f10 <- lm(sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption + smoking_status + exercise_frequency + age + caffeine_consumption + rem_sleep_percentage + sleep_duration + gender, data = sleep2)


regression_results <- tibble::tibble(
  Model = paste0("f", 1:10),
  Formula = c(
    "sleep_efficiency ~ deep_sleep_percentage",
    "sleep_efficiency ~ deep_sleep_percentage + awakenings",
    "sleep_efficiency ~ deep_sleep_percentage + awakenings + alchol_consumption",
    "sleep_efficiency ~ ... + smoking_status",
    "sleep_efficiency ~ ... + exercise_frequency",
    "sleep_efficiency ~ ... + age",
    "sleep_efficiency ~ ... + caffeine_consumption",
    "sleep_efficiency ~ ... + rem_sleep_percentage",
    "sleep_efficiency ~ ... + sleep_duration",
    "sleep_efficiency ~ ... + gender"
  ),
  Adj_R2 = c(
    summary(f1)$adj.r.squared,
    summary(f2)$adj.r.squared,
    summary(f3)$adj.r.squared,
    summary(f4)$adj.r.squared,
    summary(f5)$adj.r.squared,
    summary(f6)$adj.r.squared,
    summary(f7)$adj.r.squared,
    summary(f8)$adj.r.squared,
    summary(f9)$adj.r.squared,
    summary(f10)$adj.r.squared
  )
)

write_csv(regression_results, here("Output", "regression_results.csv"))


## 6. Correlation Analysis chart
cor_data <- sleep1 %>%
  select(sleep_efficiency, rem_sleep_percentage, deep_sleep_percentage, 
         light_sleep_percentage, awakenings, caffeine_consumption, 
         alchol_consumption, smoking_status, exercise_frequency, age, 
         sleep_duration)

# Only numeric columns are retained
cor_matrix <- cor(select_if(cor_data, is.numeric), use = "complete.obs")

# Save the correlation coefficient matrix
write_csv(as.data.frame(cor_matrix), here("Output", "correlation_matrix.csv"))

# visualization
ggcorrplot::ggcorrplot(cor_matrix,
                       method = "circle",
                       type = "lower",
                       lab = TRUE,
                       lab_size = 3)
ggsave(here("Output", "corrplot_matrix.png"), width = 7, height = 6)


corrplot(cor(cor_data[c("sleep_efficiency", "deep_sleep_percentage", "rem_sleep_percentage",
                        "light_sleep_percentage", "awakenings")], use = "complete.obs"),
         method = "number", type = "upper")
ggsave(here("Output", "corrplot_sleep_factors.png"), width = 6, height = 5)

## 7. Alcohol Consumption vs. Bedtime
p2 <- ggplot(data = sleep1, aes(x = alchol_consumption, y = bedtime)) +
  geom_point() +
  stat_smooth(method = "lm", se = TRUE) +
  theme_minimal()

ggsave(
  filename = here("Output", "figure2_alcohol_vs_bedtime.png"),
  plot = p2,
  width = 6, height = 4, dpi = 300
)
