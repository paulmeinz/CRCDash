
g <-c('Female','Male','Unknown')
gender <- sample(g, 1000, replace = TRUE, c(.49,.49,.02))

e <- c('African American','Hispanic/Latino','Asian/Pacific Is.','Native American','White')
ethnicity <- sample(e, 1000, replace = TRUE, c(.2,.25,.30,.5,.20))

s <- c(0,100)
success <- sample(s, 1000, replace = TRUE)

crs <-c('ECON','CISW','CISN', 'ACCT','ECE')
course <- sample(crs, 1000, replace = TRUE)

term <- rep(c('Fall, 2014','Spring, 2015','Fall, 2015','Spring, 2016'), each = 250)

data <- data.frame(term, crs, gender, ethnicity, success)

write.csv(data, 'data.csv')
