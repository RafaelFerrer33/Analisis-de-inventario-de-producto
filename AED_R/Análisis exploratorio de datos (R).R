library(tidyverse)
library(readr)
library(knitr)

retail <- read.csv("retail_limpio.csv")

# Primer objetivo:

# Filtramos para analizar por separado

ticket_h <- retail %>%
  filter(Genero == "Hombre")
ticket_m <- retail %>%
  filter(Genero == "Mujer")

# Calculamos las estadísticas descriptivas de c/u

estadisticas_descriptivas_h <- ticket_h %>%
  summarise(across(
    c(Cantidad, Precio_por_cantidad, Monto_total),
    list(
      media = \(x) mean(x),
      mediana = \(x) median(x),
      desviacion = \(x) sd(x)
         )))

print(estadisticas_descriptivas_h)

estadisticas_descriptivas_m <- ticket_m %>%
  summarise(across(
    c(Cantidad, Precio_por_cantidad, Monto_total),
    list(
      media = \(x) mean(x),
      mediana = \(x) median(x),
      desviacion = \(x) sd(x)
    )))

print(estadisticas_descriptivas_m)

# Hacemos gráficos para visualizar mejor el gasto de cada variable

ggplot(retail,
       aes(x = Categoria_producto,
           y = Monto_total,
           fill = Genero)) +
  geom_col() +

  # Facetas
  facet_wrap(~Genero, scales = "free_y") +

  # Escalas
  scale_y_continuous(expand = expansion(mult = c(0, 0.10)),
                     labels = scales::label_dollar(big_mark = ",")) +
  scale_fill_manual(
    values = c("Mujer" = "#4e3159", "Hombre" = "#0a1e36")
  ) +

  labs(title = "Análisis de gasto total",
       subtitle = "Compras hechas por hombres y mujeres separados por categoria",
       y = "Acumulado del monto total",
       x = "Producto comprado",
       fill = "Genero") +
  theme_minimal(base_size = 15) +
  theme(
    # Ajustando el titulo para que sea más legible
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 20, hjust = 0.5, color = "#2c3e50", margin = margin(b = 10)),
    plot.subtitle = element_text(face = "bold", size = 14, hjust = 0.5, margin = margin(b = 15), color = "#5a6366"),
    plot.margin = margin(t = 10, r = 10, b = 10, l = 0),
    
    #Ajustando la leyenda para dejarle más espacio al gráfico
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 12),
    legend.text = element_text(size = 12, face = "bold"),
    legend.box.spacing = unit(0, "pt"),
    

    panel.grid.major.x = element_blank(), # Eliminando las barras verticales para la limpieza visual
    
    # Ajustando las etiquetas para una mejor estética
    strip.background = element_rect(fill = "#babbcf", color = NA),
    strip.text = element_text(face = "bold", size = 12),
    
    # Limpiando el texto de los ejes para la limpieza visual
    axis.text.x = element_text(face = "bold", size = 10),
    axis.title.x = element_text(size = 14, face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(size = 14, face = "bold", margin = margin(r = 15), hjust = 0.5),
    axis.text = element_text(size = 11, color = "#424042"),
    axis.line.x = element_line(color = "#424042"))

# Boxplot

ggplot(retail,
       aes(y = Monto_total,
           fill = Genero)) +
  geom_boxplot(color = "black") +
  labs(title = "Análisis de la distribución del gasto total",
       subtitle = "Distribución del gasto total de hombres y mujeres",
       y = "Total gastado"
  ) +
  
  # Facetas
  facet_wrap(~Genero) +
  
  # Ajuste de las escalas
  scale_y_continuous(
    labels = scales::label_dollar(bigmark = ",")
  ) +
  scale_fill_manual(
    values = c(Mujer = "#4e3159", Hombre = "#0a1e36")
  ) +
  
  theme_minimal() + 
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", hjust = 0.5, color = "#2c3e50", size = 20),
    plot.subtitle = element_text(face = "bold", hjust = 0.5, color = "gray20", size = 14),
    
    legend.position = "bottom",
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 12, face = "bold"),
    legend.box.spacing = unit(0, "pt"),

    strip.background = element_rect(fill = "#babbcf", color = NA),
    strip.text = element_text(face = "bold", size = 12),
    
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),

    axis.title.y = element_text(size = 14, face = "bold"),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank())

# Gráfico de densidad
  
ggplot(retail,
       aes(x = Monto_total,
           fill = Genero
           )) +
  geom_density(adjust = 1.5, color = NA) +
  facet_wrap(~Genero) +
  scale_x_continuous(
    labels = scales::label_dollar(big.mark = ",")
  ) +
  scale_fill_manual(
    values = c(Mujer = "#4e3159", Hombre = "#0a1e36")
  ) +
  labs(title = "Relación entre la frecuencia de compra y el gasto total por género",
       subtitle = "Comparativa del comportamiento de gasto de la segmentación género",
       y = "Densidad",
       x = "Gasto total") +
  theme_minimal() + 
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 15, hjust = 0.5, color = "#2c3e50"),
    plot.subtitle = element_text(face = "bold", size = 13, hjust = 0.5, color = "gray20"),
    
    legend.position = "bottom",
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 12, face = "bold"),
    legend.box.spacing = unit(0, "pt"),
    
    strip.background = element_rect(fill = "#babbcf", color = NA),
    strip.text = element_text(size = 10, face = "bold"),

    axis.text.y = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.title.y = element_text(size = 15, face = "bold", margin = margin(r = 10)),
    axis.title.x = element_text(size = 15, face = "bold", margin = margin(t = 10)),

    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )

# Objetivo 2

# Separamos los grupos de edad para analizar cada segmento etario

max(retail$Edad)
min(retail$Edad)

cortes <- c(18, 27, 36, 45, 54, 64)
etiquetas <- c("Adulto joven (18-26)",
               "Adulto (27-35)",
               "Adulto Maduro (36-43)",
               "Mediana edad (44-53)",
               "Adulto Mayor (54-64)")

retail["Rango_edad"] <- cut(retail$Edad,
                   breaks = cortes,
                   labels = etiquetas,
                   include.lowest = TRUE)

table(retail$Rango_edad)

# Para ver quien representa un mayor porcentaje de gasto

porcentaje__ventas_edad <- retail %>%
  group_by(Rango_edad) %>%
  summarise(gasto_por_segmento = sum(Monto_total)) %>%
  mutate(Porcentaje = (gasto_por_segmento / sum(gasto_por_segmento)) * 100) %>%
  arrange(desc(Porcentaje))


# Hacemos un nuevo df que tenga todos el gasto acumulado por los grupos etarios por mes

retail$Fecha = as.Date(retail$Fecha)
class(retail$Fecha)

datos_mensual <- retail %>%
  mutate(mes = floor_date(Fecha, "month")) %>%
  group_by(mes, Rango_edad) %>%
  summarise(gasto_por_mes = sum(Monto_total), .groups = "drop")

# Para evaluar el gasto acumulado:

datos_mensual <- datos_mensual %>%
  arrange(mes) %>%
  group_by(Rango_edad) %>%
  mutate(Gasto_acumulado = cumsum(gasto_por_mes)) %>%
  ungroup() %>%
  filter(mes != "2024-01-01")

# Tabla para visualizar los porcentajes y el gasto exacto

kable(porcentaje__ventas_edad, 
      digits = 2, 
      format.args = list(big.mark = ","), 
      caption = "Distribución del Gasto Total y Porcentual por Segmento Etario",
      col.names = c("Rango de Edad", "Gasto Total ($)", "Participación (%)"))

# Gráfico de barras para analizar el gasto acumulado por segmento etario

ggplot(retail,
       aes(x = Rango_edad,
           y = Monto_total,
           fill = Rango_edad)) +
  geom_col() +
  scale_y_continuous(
    labels = scales::dollar_format(bigmark = ","),
    expand = expansion(mult = c(0, 0.20))
  ) +
  scale_x_discrete(expand = expansion(mult = c(0.1, 0.1))) + # Para separar más los textos de abajo
  scale_fill_manual(
    values = c("Adulto joven (18-26)" = "#152b45", 
               "Adulto (27-35)" = "#183557",
               "Adulto Maduro (36-43)" = "#19406e",
               "Mediana edad (44-53)" = "#1759a6",
               "Adulto Mayor (54-64)" = "#096fe6") 
  ) +
  labs(title = "Gasto acumulado por grupo de edad",
       subtitle = "Gasto acumulado en el año 2023 por segmento Etario",
       x = "Segmento Etario",
       y = "Total gastado",
       fill = "Rangos de edad:") +
  theme_minimal() + 
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 15, hjust = 0.5, color = "#081a26"),
    plot.subtitle = element_text(face = "bold", size = 12, hjust = 0.5, color = "#0c293d"),
    
    legend.position = "none",
    
    axis.title.y = element_text(face = "bold", size = 15),
    axis.title.x = element_text(face = "bold", size = 15, margin = margin(t = 10)),
    axis.text = element_text(color = "black"),
    axis.text.x = element_text(color = "black", size = 10),
    
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "left")) # Para que la leyenda ocupe 2 filas de espacio

retail$Fecha = as.Date(retail$Fecha)
class(retail$Fecha)

# Segundo grafico

ggplot(datos_mensual,
       aes(x = mes,
           y = Gasto_acumulado,
           color = Rango_edad)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = scales::label_dollar(bigmark = ",")) +
  scale_x_date(
    date_labels = "%b",
    date_breaks = "1 month") + # Para que el grafico solo evalue el gasto acumulado al final de mes
  scale_color_manual(
    values = c("Adulto joven (18-26)" = "#283D3B", 
               "Adulto (27-35)" = "#197278",
               "Adulto Maduro (36-43)" = "#C4A08C",
               "Mediana edad (44-53)" = "#C44536",
               "Adulto Mayor (54-64)" = "#501C15")
  ) +
  labs(title = "Tendencia de compras mensuales acumuladas por segmento Etario",
       subtitle = "Análisis de compra mensuales acumuladas por segmento Etario en el año 2023",
       x = "Mes",
       y = "Gasto acumulado",
       color = "Rangos de edad") +
  theme_minimal() +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 15, hjust = 0.5, color = "#081a26"),
    plot.subtitle = element_text(face = "bold", size = 12, hjust = 0.5, color = "#152d4f"),
    
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 9),
    legend.text = element_text(face = "bold", size = 9),
    legend.box.spacing = unit(0, "pt"),
    
    axis.title.y = element_text(face = "bold", size = 12),
    axis.title.x = element_text(face = "bold", size = 12),
    axis.text = element_text(color = "black")
  ) +
  guides(color = guide_legend(nrow = 2, byrow = TRUE, title.position = "left"))

# Tercer grafico:

ggplot(retail,
       aes(x = Rango_edad,
           y = Monto_total,
           fill = Rango_edad)) +
  geom_boxplot(color = "black") + 
  scale_y_continuous(labels = scales::label_dollar(bigmark = ",")) +
  scale_x_discrete(expand = expansion(mult = c(0.1, 0.1))) +
  scale_fill_manual(
    values = c("Adulto joven (18-26)" = "#003F5D", 
               "Adulto (27-35)" = "#00527C",
               "Adulto Maduro (36-43)" = "#00609C",
               "Mediana edad (44-53)" = "#006DB2",
               "Adulto Mayor (54-64)" = "#4E97D1")
  ) + 
  labs(title = "Distribución de gasto acumulado por segmento Etario",
       subtitle = "Análisis de la distribución del gasto acumulado por grupo Etario en el año 2023",
       x = "Segmento Etario",
       y = "Gasto acumulado",) +
  theme_minimal() +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 15, hjust = 0.5, color = "#182942"),
    plot.subtitle = element_text(face = "bold", size = 12, hjust = 0.5, color = "#152d4f"),
    
    legend.position = "none",
    
    axis.title.y = element_text(face = "bold", size = 15),
    axis.title.x = element_text(face = "bold", size = 15, margin = margin(t = 10)),
    axis.text = element_text(color = "black"),
    axis.text.x = element_text(size = 10, face = "bold"),
    
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  ) +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE, title.position = "left"))

# Cuarto Objetivo

preferencias <- retail %>%
  group_by(Genero, Rango_edad, Categoria_producto) %>%
  summarise(total_elecciones = n(), .groups = "drop") %>%
  mutate(Porcentaje_preferencia = (total_elecciones / sum(total_elecciones) * 100))

ggplot(preferencias,
       aes(x = Categoria_producto,
           y = Rango_edad,
           fill = Porcentaje_preferencia)) +
  geom_tile(color = "black", linewidth = 0.1) +
  geom_text(aes(label = sprintf("%.2f%%", Porcentaje_preferencia)),
            color = ifelse(preferencias$Porcentaje_preferencia > 3.25, "black", "white"),
            size = 3, fontface = "bold",) +
  facet_wrap(~Genero) +
  scale_fill_gradient2(
    low = "#02093d",
    mid = "gray90",
    high = "#941929",
    midpoint = 3.25,
    labels = function(x) paste0(x, "%")
  ) + 
  labs(title = "Intensidad de preferencia",
       subtitle = "Intensidad de preferencia por segmento demográfico en el año 2023",
       y = "Segmento Etario",
       x = "Categoria de Producto",
       fill = "Porcentaje de preferencia") +
  theme_minimal() +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 15, hjust = 0.5, color = "#07073d"),
    plot.subtitle = element_text(face = "bold", size = 12, hjust = 0.5, color = "#08084d"),
 
    legend.title = element_text(face = "bold", size = 9, hjust = 0.5),
    legend.text = element_text(face = "bold", size = 9, hjust = 0.5),
    legend.title.align = 0.5,
    
    strip.background = element_rect(fill = "gray80", color = NA),
    strip.text = element_text(face = "bold", size = 12),
    
    axis.title.x = element_text(face = "bold", size = 13),
    axis.title.y = element_text(face = "bold", size = 13),
    axis.text = element_text(face = "plain", color = "black"),
    
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  ) 

# Quinto objetivo:

retail <- retail %>%
  mutate(segmento = ifelse(Monto_total >= 300, "Premium", "Estandar"))

perfiles_premium <- retail %>%
  group_by(Rango_edad, segmento) %>%
  summarise(
    Total_ventas = n(),
    Monto_total = sum(Monto_total),
    .groups = 'drop'
  ) %>%
  group_by(Rango_edad) %>%
  mutate(Porcentaje_por_segmento = (Monto_total / sum(Monto_total)) * 100) %>%
  ungroup() %>%
  mutate(Porcentaje_global = (Monto_total / sum(Monto_total)) * 100)

ggplot(perfiles_premium,
       aes(x = Rango_edad,
           y = Monto_total,
           fill = segmento)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = scales::label_dollar(bigmark = ","),
                     expand = expansion(mult = c(0, 0.05))) +
  scale_x_discrete(expand = expansion(mult = c(0.1, 0.1))) +
  scale_fill_manual(
    values = c(Estandar = "#436EEE", Premium = "#27408B")) +
  labs(title = "Contraste de Total gastado por Rango de edad y segmentación",
       subtitle = "Análisis del contraste que hay entre las compras Premium y el Rango de edad en el año 2023",
       x = "Segmento Etario",
       y = "Total gastado",
       fill = "Segmento:") +
  theme_minimal() +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 15, hjust = 0.5),
    plot.subtitle = element_text(face = "bold", size = 12, hjust = 0.5),
    
    legend.position = "bottom",
    legend.title = element_text(face = "bold", size = 9),
    legend.text = element_text(face = "bold", size = 9),
    legend.box.spacing = unit(0, "pt"),
    
    axis.title.x = element_text(face = "bold", size = 14, margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", size = 14),
    axis.text = element_text(face = "plain", color = "black"),
    axis.line.x = element_line(color = "#4876FF", size = 0.8),
    
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  )
  
