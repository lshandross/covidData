library(dplyr)
testthat::context("adjust_daily_incidence")

# read in data
data <- covidData::load_jhu_data(
  spatial_resolution = 'state',
  temporal_resolution = 'daily',
  measure = 'deaths', replace_negatives = FALSE,
  adjustment_cases = 'none'
  ) %>%
  dplyr::filter(location == '08')

# NY state 36
# NY-2020-04-19','NY-2020-06-12'
# negative obs is on 2020-04-19



adjustment_cases <- c('CO-2020-03-26', 'CO-2020-04-24')

adjustment_states <- sub('-.*', '', adjustment_cases)
adjustment_dates <- sub('^.*?-', '', adjustment_cases)
adjustment_state_fips <- unlist(lapply(
  adjustment_states, function(x) {
    covidData::fips_codes[which(covidData::fips_codes$abbreviation == x), ]$location
  }
))
adjustments <- data.frame(location = adjustment_state_fips, date = as.Date(adjustment_dates))

# negative obs is on 2020-03-26
new_inc_case_a <- covidData::adjust_daily_incidence(data, adjustments[1, ]$date, measure = 'deaths')

new_inc_case_b <- covidData::adjust_daily_incidence(data, adjustments[2, ]$date, measure = 'deaths')

# locations other than the adjustment location


# case a, 1
# observed is negative, replacement is imputed
test_that("negative diff, incidents are nonnegative before and on the adjustment date", {

  # negative obs is on 2020-03-26
  expect_true(all(new_inc_case_a[data$date <= '2020-03-26'] >= 0))
})

# case a, 2
# observed is negative, replacement is imputed
test_that("negative diff, incidents are unchanged after the adjustment date", {
  expect_true(all(new_inc_case_a[data$date > '2020-03-26'] ==
    data[data$date > '2020-03-26', ]$inc))
})

# case a, 3
# observed is negative, replacement is imputed
test_that("negative diff, cumulative countss are unchanged on and after the adjustment date", {
  cum = cumsum(new_inc_case_a)
  expect_true(all(cum[data$date >= '2020-03-26'] ==
                    data[data$date >= '2020-03-26', ]$cum))
})


# case b, 1
# observed is positive, replacement also positive but less than observed
test_that("positive diff, incidents are nonnegative before and on the adjustment date", {
  # 2020-04-24

  expect_true(all(new_inc_case_b[data$date <= '2020-04-24'] >= 0))
})


# case b, 2
# observed is positive, replacement also positive but less than observed
test_that("positive diff, incidents are unchanged after the adjustment date", {
  # 2020-04-24

  expect_true(all(new_inc_case_b[data$date > '2020-04-24'] ==
    data[data$date > '2020-04-24', ]$inc))
})

# case b, 3
# observed is negative, replacement is imputed
test_that("negative diff, cumulative counts are unchanged on and after the adjustment date", {
  cum = cumsum(new_inc_case_b)
  expect_true(all(cum[data$date >= '2020-04-24'] ==
                    data[data$date >= '2020-04-24', ]$cum))
})

