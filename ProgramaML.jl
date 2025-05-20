# ---------------------------------------------
# Pedro Caso - 241286
# Entrega 4 - Proyecto individual lenguajes 
# Algoritmos y Estructuras de Datos
# ---------------------------------------------

# librerías utilizadas
using Flux
using Random
using Plots

# constante gravitacional en m/s2
const g = 9.81

# Función para generar datos de alcance de proyectiles
function generar_datos(n)
    X = zeros(2, n) # Filas: velocidad y ángulo; Columnas: muestras
    Y = zeros(n) # Vector con los alcances correspondientes
    for i in 1:n
        v = rand(10.0:0.5:50.0) # genera veelocidad aleatoria entre 10 y 50 m/s
        θ = rand(15.0:0.5:75.0) * (π / 180) # Ángulo en radianes entre 15° y 75° para el lanzamiento
        x = v^2 * sin(2θ) / g # formula del proyectil
        X[:, i] .= [v, θ] # guarda la entrada de vel y el angulo
        Y[i] = x # guarda la salida del alncance
    end
    return X, Y
end

# Generar conjunto para entrenamiento del Machine Learning de 1000 ejemplos o muestras
X, Y = generar_datos(1000)

# Estructura de la red neuronal
modelo = Chain(
    Dense(2, 16, relu), # Capa de entrada 2 neuronas (velocidad, ángulo)
    Dense(16, 8, relu), # capas ocultas 16 y 8 neuronas con activación ReLU
    Dense(8, 1) # Capa de salida: 1 neurona (alcance estimado)
)

# error cuadrático medio entre predicción y valor real
loss(m, x, y) = Flux.Losses.mse(m(x), y)

# Optimizador moderno (usando Optimisers.jl)
opt = Flux.setup(Flux.Adam(0.01), modelo)

# Entrenamiento de la red neuronal 
for epoch in 1:300
    grads = Flux.gradient(modelo) do m
        loss(m, X, Y')  # Y' para usar como columna  en una matriz 1×n
    end
    Flux.update!(opt, modelo, grads) # Actualiza parámetros 
    if epoch % 50 == 0
        println("Epoch $epoch - Loss: ", loss(modelo, X, Y'))
    end
end

# funcion para graficar la trayectoria vs la prediccion del ML
function mostrar_trayectoria_vs_prediccion(modelo, v::Float64, θ_deg::Float64; g::Float64 = 9.81)
    θ = deg2rad(θ_deg)

    # Tiempo total estimado con datos físicos
    t_total = 2 * v * sin(θ) / g
    ts = range(0, t_total, length=200)

    # Coordenadas reales de la trayectoria
    x_real = v * cos(θ) .* ts
    y_real = v * sin(θ) .* ts .- 0.5 * g .* ts.^2

    # Predicción del alcance por el modelo
    alcance_predicho = modelo([v, θ])[1]

    # Graficar trayectoria
    plot(x_real, y_real,
        xlabel="Distancia horizontal (m)",
        ylabel="Altura (m)",
        title="Trayectoria real vs predicción ML",
        label="Trayectoria física",
        lw=2,
        legend=:topright)

    # alcance predicho
    scatter!([alcance_predicho], [0.0], 
        label="Alcance predicho por ML", 
        color=:red, 
        markersize=6, 
        marker=:circle)

    # alcance real 
    alcance_real = v^2 * sin(2θ) / g
    scatter!([alcance_real], [0.0], 
        label="Alcance real",
        color=:green,
        markersize=6,
        marker=:star5)
end

# Prueba del modelo con una velocidad de 30 m/s y ángulo de 45 grados
v_test = 30.0
θ_test_deg = 45.0 
mostrar_trayectoria_vs_prediccion(modelo, v_test, θ_test_deg)
