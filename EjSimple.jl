#---------------------------------------
# Pedro Caso
# 241286
# Programa simple
# Algoritmos y Estructuras de datos
#---------------------------------------

using Base.Threads
using Distributed
using Statistics
using GLM, DataFrames

# 1. Ejemplo de una repetición, en este caso se muestra un for
function mostrarNumeros(n)
    for i in 1:n # recorre los valores iterando desde 1 hasta n 
        println("numero recorrido por el for: ", i) # se imprime el numero
    end
end

# 2. Ejemplo de condicionales, en este caso se muestra de manera simple el uso del if, elseif y else
function comprobarNumero(x)
    if x < 0 # es la primera condicion que evalua si el numero es menor a 0
        println("El número es negativo")
    elseif x == 0 # en la segunda condicion evalua si es igual a 0
        println("El número es cero")
    else # si no se cumplen las condiciones anteriores se toma como numero positivo
        println("El número es positivo")
    end
end

# 3. Ejemplo de una funcion utilizando dispatch múltiple
# Julia utilizara el la funcion adecuada segun el valor que tome X
function datoX(x::Int) # se especifica el tipo de dato entero
    println("Es un entero")
end

function datoX(x::Float64) # se especifica el tiop te dato flotante
    println("Es un número de punto flotante")
end

function datoX(x::String) # se especifica el tipo de dato String
    println("Es un texto")
end

# 4. Ejemplo de una funcion cuadrática y su simplicidad
f(x) = x^2 + 2x + 1

# 5. Ejemplo de paralelización simple con Threads o hilos
function sumaEnParalelo(n)
    suma = Ref(0)  # Uso de Ref para evitar condiciones de carrera, crea una referencia mutable a un valor 0, se hace para evitar modificar la variable suma
    @threads for i in 1:n # threads divide el bucle en varios hilos para hacer la suma a la vez o en paralelo
        suma[] += i # accede al valor de ref y los va sumando
    end
    return suma[] # devuelve la suma
end

# 6. Ejemplo de paralelización simple con distributed
addprocs(4)  # Agrega procesos para ejecutar tareas en paralelo
function sumaConDistribucion(n)
    return @distributed (+) for i in 1:n # Divide el bucle en varios procesos distribuidos
        i
    end
end

# 7. Ejemplo matemático que muestra velocidad de análisis de datos
function velocidadDeAnalisis()
    datos = rand(10^6)  # genera un millón de datos de manera aleatoria 
    println("la media es: ", mean(datos)) # calcula la media del numero generado
    println("su desVest es: ", std(datos)) # calcula la desviacion estandar del numero 
end

# 8. Ejemplo estadistico utilizando un modelo lineal
# Datos de ejemplo siendo X: variable independiente y Y: variable dependiente
dif = DataFrame(X = [1, 2, 3, 4, 5], Y = [2, 4.1, 6.2, 8.1, 10.3])

# se crea un modelo de regresión lineal con la forma Y = a + b*X
regLineal = lm(@formula(Y ~ X), dif)

# -----------------------------------------------------------------------------------------------------------
# Prueba de las funcioanlidades

# mostrar la funcionalidad de la repeticion
println("Funcioamiento del bucle for:")
mostrarNumeros(7)

# mostrar la funcioañodad de las condiciones:
println("\nEjemplo de las condicionales:")
comprobarNumero(-5)
#comprobarNumero(0)
#comprobarNumero(5)

#Ejemplo de la eleccion de Julia utilizando el dispatch 
println("\nEjemplo de dispatch múltiple:")
#datoX(30)
datoX(2.11)
#datoX("HolaMundo")

# Ejemplo de una funcion matematica
println("\nEjemplo de función cuadrática:")
println("Para F(4): ", f(4))

# Ejemplo de la paralelizacion simple con threads y distributed
println("\nEjemplo de paralelizacion simple utilizando Threads:")
println("La suma en paralelo es: ", sumaEnParalelo(150))

println("\nEjemplo de paralelizacion simple utilizando Distributed:")
println("La suma distribuida es: ", sumaConDistribucion(150))

# Ejemplo de velocidad de Julia
println("\nEjemplo de velocidad en el analisis de datos:")
velocidadDeAnalisis()

# Mostrar resultados
println("\nCoeficientes: ", coef(regLineal))  # Muestra el intercepto y la pendiente
println("Resumen del modelo: ")
display(regLineal)