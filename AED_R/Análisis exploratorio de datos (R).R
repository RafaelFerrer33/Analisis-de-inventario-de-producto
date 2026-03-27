library(tidyverse)
library(readr)

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
    c(Cantidad, Precio_por_unidad, Monto_total),
    list(
      media = \(x) mean(x),
      mediana = \(x) median(x),
      desviacion = \(x) sd(x)
         )))

print(estadisticas_descriptivas_h)

estadisticas_descriptivas_m <- ticket_m %>%
  summarise(across(
    c(Cantidad, Precio_por_unidad, Monto_total),
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
    
    # Ajustes al titulo y al subtitulo para que sea más legible
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", hjust = 0.5, color = "#2c3e50", size = 20),
    plot.subtitle = element_text(face = "bold", hjust = 0.5, color = "gray20", size = 14),
    
    # Ajustando a la leyenda para dejar más espacio al gráfico
    legend.position = "bottom",
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 12, face = "bold"),
    legend.box.spacing = unit(0, "pt"),
    
    # Ajustes a las etiquetas "Hombre" y "Mujer" para que sean más legibles
    strip.background = element_rect(fill = "#babbcf", color = NA),
    strip.text = element_text(face = "bold", size = 12),
    
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    
    # Ajustes al texto de los ejes para la limpieza visual
    axis.title.y = element_text(size = 14, face = "bold"),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank())

# Gráfico de densidad
  
ggplot(retail,
       aes(x = Monto_total,
           fill = Genero
           )) +
  
  geom_density(adjust = 1.5, color = NA) +
  
  # Facetas
  facet_wrap(~Genero) +
  
  # Ajuste en las escalas
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
    
    # Ajuste al título para que esté más centrado y más legible
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 15, hjust = 0.5, color = "#2c3e50"),
    plot.subtitle = element_text(face = "bold", size = 13, hjust = 0.5, color = "gray20"),
    
    # Ajustando la leyenda para abajo para darle más espacio al gráfico
    legend.position = "bottom",
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 12, face = "bold"),
    legend.box.spacing = unit(0, "pt"),
    
    # Ajustando las etiquetas para la limpieza visual
    strip.background = element_rect(fill = "#babbcf", color = NA),
    strip.text = element_text(size = 10, face = "bold"),
    
    # Ajustando los titulos y textos en "x" y "y" para la limpieza visual
    axis.text.y = element_text(size = 10, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.title.y = element_text(size = 15, face = "bold", margin = margin(r = 10)),
    axis.title.x = element_text(size = 15, face = "bold", margin = margin(t = 10)),
    
    # Eliminando las lineas horizontales y verticales para una mejor claridad visual
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )


         
