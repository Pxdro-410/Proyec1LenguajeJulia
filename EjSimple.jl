#---------------------------------------
# Pedro Caso
# 241286
# Programa simple
# Algoritmos y Estructuras de datos
#---------------------------------------

using Base.Threads
using Distributed
using Statistics

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
function tipo_dato(x::Int) # se especifica el tipo de dato entero
    println("Es un entero")
end

function tipo_dato(x::Float64) # se especifica el tiop te dato flotante
    println("Es un número de punto flotante")
end

function tipo_dato(x::String) # se especifica el tipo de dato String
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
    datos = rand(10^6)  # Un millón de datos aleatorios
    println("la media es: ", mean(datos))
    println("su desVest es: ", std(datos))
end

# Llamadas de prueba
println("Ejemplo de bucle for:")
mostrarNumeros(5)

println("\nEjemplo de condicional:")
comprobarNumero(-3)
comprobarNumero(0)
comprobarNumero(7)

println("\nEjemplo de dispatch múltiple:")
#tipo_dato(42)
tipo_dato(3.14)
#tipo_dato("Hola")

println("\nEjemplo de función cuadrática:")
println("f(3) = ", f(3))

println("\nEjemplo de paralelización con Threads:")
println("Suma paralela: ", sumaEnParalelo(100))

println("\nEjemplo de paralelización con Distributed:")
println("Suma distribuida: ", sumaConDistribucion(100))

println("\nEjemplo de análisis de datos:")
velocidadDeAnalisis()