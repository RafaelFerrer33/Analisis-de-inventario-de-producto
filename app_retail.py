import streamlit as st
import pandas as pd
import plotly.express as px

# 1. Configuración Inicial y Carga de Datos
st.set_page_config(page_title="Dashboard Retail", layout="wide")
st.title("Retail: Comportamiento del Cliente y Ventas")
st.write("Este proyecto presenta un análisis exploratorio y descriptivo de una base de datos del sector retail. El objetivo principal es examinar el impacto de las características demográficas de los clientes sobre el comportamiento de compra, la preferencia de categorías de productos y el volumen total de facturación.")


  # Creación de columnas y agrupación de datos
@st.cache_data
def columnasyrangos():
    df = pd.read_csv('Retail_Limpio.csv')

    # Objetivo 2: Preparación de columna Grupo Etario
    df['Grupo Etario'] = 'Mayor a 40'
    df.loc[df['Age'] <= 40, 'Grupo Etario'] = '40 o Menor'

    # Objetivo 3: Preparación de Rangos de Edad y Tipo de Producto
    df.loc[df['Age'] <= 25, 'Rango_Edad'] = '18-25'
    df.loc[(df['Age'] > 25) & (df['Age'] <= 35), 'Rango_Edad'] = '26-35'
    df.loc[(df['Age'] > 35) & (df['Age'] <= 50), 'Rango_Edad'] = '36-50'
    df.loc[df['Age'] > 50, 'Rango_Edad'] = '51+'

    df['Tipo de Producto'] = 'Económico'
    df.loc[df['Price per Unit'] > 300, 'Tipo de Producto'] = 'Premium'


    df['Gender'] = df['Gender'].replace({'Male': 'Masculino', 'Female': 'Femenino'})
    df['Product Category'] = df['Product Category'].replace({
        'Beauty': 'Belleza', 
        'Clothing': 'Ropa', 
        'Electronics': 'Electrónica'
    })

    return df

df = columnasyrangos()



# Creamos las 4 columnas
col1, col2, col3, col4 = st.columns(4)

# Tarjeta 1: Total de Transacciones
with col1:
    with st.container(border=True):
        total_transacciones = len(df)
        st.metric(label="Total de Transacciones", value=f"{total_transacciones:,}")
        st.caption("Registros válidos analizados")

# Tarjeta 2: Ingresos Totales
with col2:
    with st.container(border=True):
        ingresos_totales = df['Total Amount'].sum()
        st.metric(label="Ingresos Totales", value=f"${ingresos_totales:,.2f}")
        st.caption("Facturación global del periodo")

# Tarjeta 3: Ticket Promedio
with col3:
    with st.container(border=True):
        ticket_promedio = df['Total Amount'].mean()
        st.metric(label="Ticket Promedio", value=f"${ticket_promedio:,.2f}")
        st.caption("Gasto promedio por visita")

# Tarjeta 4: Categoría Top
with col4:
    with st.container(border=True):
        cat_estrella = df.groupby('Product Category')['Total Amount'].sum().idxmax()
        st.metric(label="Categoría Top", value=cat_estrella)
        st.caption("Mayor volumen de ingresos")

st.divider()


tab1, tab2, tab3, tab4, tab5, tab6 = st.tabs(["Tabla de datos", "Ticket Promedio por Género", "Edad y Categoría de Producto", "Tendencia a Productos Premium", "Ingresos Acumulados", "Transacciones vs Ingresos"])

with tab1:
    st.subheader("📋 Tabla de datos")
    # 1. Creamos el Selectbox con las opciones
    filtro_categoria = st.selectbox(
        "Filtrar transacciones por categoría:",
        ["Todas las categorías", "Belleza", "Ropa", "Electrónica"],
        key="filtro_cat"
        )

    if filtro_categoria == "Todas las categorías":
         df_filtrado = df
    else:
     #Filtramos el df original donde la columna coincida con la selección
         df_filtrado = df[df['Product Category'] == filtro_categoria]

    # Mostramos un pequeño texto indicando cuántos registros encontró
    st.caption(f"Mostrando {len(df_filtrado)} transacciones correspondientes a: **{filtro_categoria}**")
    df_Trad = df_filtrado.rename(columns={
        'Date': 'Fecha',
        'Gender': 'Género',
        'Age': 'Edad',
        'Product Category': 'Categoría',
        'Quantity': 'Cantidad',
        'Price per Unit': 'Precio Unitario ($)',
        'Total Amount': 'Monto Total ($)',
        'Rango_Edad': 'Rango de Edad'
    })



    # 4. Mostramos la tabla interactiva TRADUCIDA
    with st.container(border=True):
        st.dataframe(df_Trad, use_container_width=True)


    # -------------------------
    # Expander (información extra)
    # -------------------------
    with st.expander("Mostrar estadísticas descriptivas"):
        st.write(df.describe())
        st.divider()

    # -------------------------
    # # Expander
    # # -------------------------
    # st.header("Expander")

    with st.expander("Bibliografía"):
        st.write("https://plotly.com/python/bar-charts/")
        st.write("https://docs.streamlit.io/develop/tutorials")



with tab2:
# 1. Creamos el menú de selección múltiple (por defecto mostramos ambos)
    generos_seleccionados = st.multiselect(   "Selecciona el género a visualizar:",
         options=["Femenino", "Masculino"],
         default=["Femenino", "Masculino"] )
# 2. Calculamos los datos
    ticket_genero = df.groupby('Gender')['Total Amount'].mean().round(2).reset_index()


# 4. Hacemos el gráfico con la tabla filtrada
    fig1 = px.bar(
        ticket_genero, # Usamos la nueva tabla filtrada
        x='Gender',
        y='Total Amount',
        color='Gender',
        text_auto='.2f',
        title='Gasto Promedio por Género',
        color_discrete_map={'Femenino': 'lightpink', 'Masculino': 'darkblue'},
        labels={'Gender': 'Género', 'Total Amount': 'Ticket Promedio ($)'})

    # 3. Filtramos la tabla según lo que el usuario eligió en el menú
    ticket_genero_filtrado = ticket_genero[ticket_genero['Gender'].isin(generos_seleccionados)]

    st.plotly_chart(fig1)

    st.info( "📊 **Observación de datos:** El ticket promedio de compra es prácticamente idéntico entre hombres (\\$455.43) y mujeres (\\$456.55).")

    with st.expander("Conclusión"):
        st.success("Tras analizar las transacciones, se concluye que el género del cliente no es un factor que determine o altere el monto promedio gastado por visita.")

    st.divider()

with tab3:
    # --- OBJETIVO 2: Edad y Categoría de Producto ---
    st.header("2. Preferencias de categoría por edad")

    Catogorias_seleccionadas = st.multiselect(   "Selecciona la categoria a visualizar:",
         options=["Ropa", "Electrónica", "Belleza"],
         default=["Ropa", "Electrónica", "Belleza"])



    pref_edades = df.groupby('Grupo Etario')['Product Category'].value_counts(normalize=True).reset_index(name='Porcentaje')
    pref_edades['Porcentaje'] = (pref_edades['Porcentaje'] * 100).round(2)

    pref_edades_filtrado = pref_edades[pref_edades['Product Category'].isin(Catogorias_seleccionadas)]


    fig2 = px.bar(pref_edades_filtrado, x='Product Category', y='Porcentaje', color='Grupo Etario',
                barmode='group', text_auto='.2f', title='Preferencia por Categoría (%)',
                labels={'Product Category': 'Categoría de Producto', 'Porcentaje': 'Porcentaje (%)'} 
    )


    st.plotly_chart(fig2)

    st.info("📊 **Observación de datos:** Los clientes de 40 años o menos compran de forma equitativa (Ropa 33.69%, Electrónica 33.48%, Belleza 32.83%). Los mayores de 40 reducen sus compras de Belleza al 28.84%.")

    with st.expander("💡 Ver Conclusión"):
        st.success("La edad influye directamente en las preferencias de consumo. Existe un cambio generacional claro donde el interés por los artículos de belleza disminuye significativamente al superar los 40 años en favor de otras categorías.")


    st.divider()



with tab4:
    # --- OBJETIVO 3: Tendencia a Productos Premium ---
    st.header("3. Tendencia de Consumo Premium por Edad")
    porcentaje_tipo = df.groupby('Rango_Edad')['Tipo de Producto'].value_counts(normalize=True).reset_index(name='Porcentaje')
    porcentaje_tipo['Porcentaje'] = (porcentaje_tipo['Porcentaje'] * 100).round(2)

    tipo_prod = st.multiselect(
        "Selecciona el tipo de producto a visualizar:",
        options=["Económico", "Premium"],
        default=["Económico", "Premium"]
        )

    porcentaje_tipo_filtrado = porcentaje_tipo[porcentaje_tipo['Tipo de Producto'].isin(tipo_prod)]

    fig3 = px.bar(porcentaje_tipo_filtrado, x='Rango_Edad', y='Porcentaje', color='Tipo de Producto',
                barmode='group', text_auto='.2f', title='Económico vs Premium por Rango',
                labels={'Rango_Edad': 'Rango de Edad', 'Porcentaje': 'Porcentaje (%)', 'Tipo de Producto': 'Gama de Producto'},
                color_discrete_map={'Económico': 'Green', 'Premium': 'darkblue'}
                )


    st.plotly_chart(fig3)

    st.info("📊 **Observación de datos:** El segmento de 18-25 años concentra la mayor proporción de compras Premium (21.89%). Esta cifra disminuye gradualmente con la edad, cayendo al 18.21% en el grupo de 36-50 años.")

    with st.expander("💡 Ver Conclusión"):
        st.success("Se refuta la hipótesis inicial: a mayor edad no existe una mayor tendencia a comprar artículos de lujo. De hecho, el público más joven es el que proporcionalmente destina más compras a la gama Premium.")


    st.divider()


with tab5:
    # --- OBJETIVO 4: Ingresos Acumulados ---
    st.header("4. Distribución de ingresos por edad")
    fig4 = px.pie(df, values='Total Amount', names='Rango_Edad', hole=0.4,
                title='Volumen de Ingresos Acumulados',
                labels={'Rango_Edad': 'Rango de Edad', 'Total Amount': 'Ingresos Acumulados ($)'}
                )

    st.plotly_chart(fig4)

    st.info("📊 **Observación de datos:** El grupo de adultos entre 36 y 50 años generó el mayor volumen de facturación total (\\$139,660), superando ampliamente al segmento de 18-25 años (\\$84,550).")

    with st.expander("💡 Ver Conclusión"):
        st.success("Aunque los jóvenes compran más artículos Premium en proporción, los adultos de 36 a 50 años se consolidan como el verdadero motor financiero del negocio gracias a un mayor volumen operativo de transacciones.")


    st.divider()



with tab6:
    # --- OBJETIVO 5: Transacciones vs Ingresos ---
    st.header("5. Actividad vs Rentabilidad por Segmento")

    transacciones = df.groupby(['Rango_Edad', 'Gender']).size().reset_index(name='Cantidad')

    ingresos = df.groupby(['Rango_Edad', 'Gender'])['Total Amount'].sum().reset_index()

    generos_seleccionados = st.multiselect(
        "Selecciona el género a visualizar en ambos gráficos:",
        options=["Femenino", "Masculino"],
        default=["Femenino", "Masculino"]
    )


    trans_filtradas = transacciones[transacciones['Gender'].isin(generos_seleccionados)]
    ingresos_filtrados = ingresos[ingresos['Gender'].isin(generos_seleccionados)]

    col1, col2 = st.columns(2)

    with col1:
        fig5_1 = px.bar(trans_filtradas, x='Rango_Edad', y='Cantidad', color='Gender',
                        barmode='group', title='Volumen de Transacciones',
                        labels={'Rango_Edad': 'Rango de Edad', 'Cantidad': 'N.° de Transacciones', 'Gender': 'Género'}
                        ) 
        st.plotly_chart(fig5_1, use_container_width=True)

    with col2:

        fig5_2 = px.bar(ingresos_filtrados, x='Rango_Edad', y='Total Amount', color='Gender',
                        barmode='group', title='Ingresos Totales ($)',
                        labels={'Rango_Edad': 'Rango de Edad', 'Total Amount': 'Ingresos ($)', 'Gender': 'Género'}
                )
        st.plotly_chart(fig5_2)



    st.info("📊 **Observación de datos:** Las mujeres de 36 a 50 años lideran de forma absoluta en número de transacciones (164) e ingresos generados (\\$70,790). En contraste, en el segmento joven (18-25) los hombres compran más.")

    with st.expander("💡 Ver Conclusión"):
        st.success("Existe una correlación directa entre la cantidad de visitas y la rentabilidad. El perfil demográfico clave de la tienda es la mujer adulta, mientras que en la demografía juvenil el consumo es impulsado principalmente por los hombres.")

    st.divider()
