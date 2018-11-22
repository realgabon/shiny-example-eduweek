
# printing to console

print("Hello World!")

# single value

a <- 3
b <- 5

result <- a + b
print(result)

comparison <- result > 5
print(comparison)

# vector

numbers <- c(1, 3, 5, 7, 9)
result <- numbers + 1
print(result)

comparison <- result > 5
print(comparison)

greetings <- c("Hello", "Hi", "Hey", "Yo")
result <- paste(greetings, "Daniel")
print(result)

# data frame

name <- c("Michal", "Janka", "Daniel", "John")
age <- c(28, 28, 26, 99)
greeting <- c("Nazdar", "Serus", "Cau", "Hello")
country <- c("Slovakia", "Slovakia", "Slovakia", "United States")

my_df <- data.frame(name, age, country, greeting)

head(my_df)
colnames(my_df)

# dplyr and dataframes

library(dplyr)

my_df %>% head()
my_df %>% count()

my_df %>% colnames()

new_df <- my_df %>%
  filter(age > 26) %>% 
  filter(substr(name, 1, 1) == "J") %>%
  filter(country == "United States") %>% 
  rename(first_name = name) %>% 
  mutate(full_greeting = paste(greeting, first_name)) %>% 
  select(full_greeting)

new_df %>% print()
