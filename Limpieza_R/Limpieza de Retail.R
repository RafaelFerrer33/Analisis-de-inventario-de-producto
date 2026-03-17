library(readr)
library(tidyverse)
datos_retail <- read_csv("venta-minorista.csv")

# Buscando datos nulos y duplicados

sum(is.na(datos_retail))

anyDuplicated(datos_retail)

# Clases de las columnas

str(datos_retail)

# Verificando outliers

table(datos_retail$Quantity*datos_retail$`Price per Unit` == datos_retail$`Total Amount`)

boxplot(datos_retail$Age)
boxplot.stats(datos_retail$Age)$out
boxplot(datos_retail$Quantity)
boxplot.stats(datos_retail$Quantity)$out
boxplot(datos_retail$`Price per Unit`)
boxplot.stats(datos_retail$`Price per Unit`)$out
boxplot(datos_retail$`Total Amount`)
boxplot.stats(datos_retail$`Total Amount`)$out

table(datos_retail$Gender)
table(datos_retail$`Product Category`)

# Convirtiendo la columna Date de texto a formato fecha

library(lubridate)
datos_retail$Date <- ymd(datos_retail$Date)
class(datos_retail$Date)

datos_limpios <- datos_retail %>% 
  drop_na() %>% 
  distinct()

write.csv(datos_limpios, "retail_limpio.csv", row.names = FALSE)
