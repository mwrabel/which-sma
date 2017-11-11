rm(list = ls())
# load libraries
library(zoo)

# load data
df <- read.csv("data/mwig40_w.csv")

# ensure date format
df$Data <- as.Date(df$Data)

# create sample ma
ma52 <- rollmean(x = df$Zamkniecie, k = 52, align = "right")

# create prepared dataset
full <- df[52:nrow(df), ]
full$ma52 <- ma52

# compute return accounting for starting investing from next week
full$return52 <- 1
for (i in 2:nrow(full)) {
  full[i, ]$return52 = if (full[i-1, ]$Zamkniecie > full[i-1, ]$ma52) {
    full[i, ]$Zamkniecie/full[i-1, ]$Zamkniecie
  } else {
    1.04**(1/52) # 
  }
}

# compute product of return
prod(full$return52)**(1/as.numeric((full[nrow(full), ]$Data - full[1, ]$Data)/365))
