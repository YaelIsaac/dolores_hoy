# Dolores Hoy · Flutter + 5 APIs con buenas prácticas de seguridad (TDD)

**Materia:** Desarrollo Móvil Integral
**Universidad:** UTNG, Dolores Hidalgo
**Alumno:** González López Yael Isaac
**Fecha:** 6 de Noviembre de 2026

## Descripción

Tablero de información de Dolores Hidalgo que consume 5 APIs gratuitas con un mismo cliente HTTP seguro: clima (Open-Meteo), tipo de cambio (Frankfurter), días festivos (Nager.Date), resumen de Wikipedia y foto astronómica de la NASA (con clave). Todo se desarrolló con TDD y se probó con `MockClient`, sin internet. Si una API falla, las otras cuatro siguen funcionando.

## Estructura del proyecto

![Estructura del proyecto](capturas/01_estructura.jpeg)


## Evidencia de seguridad de secretos

### `.gitignore` con secretos y `git status` sin `secrets.json`
![git status](capturas/02_git_status.jpeg)


### Plantilla `secrets.json.example`
![Plantilla de secretos](capturas/03_secrets_example.jpeg)


### Pruebas del cliente seguro
![Pruebas del cliente seguro](capturas/04_pruebas_cliente.jpeg)


### Pruebas de seguridad
![Pruebas de seguridad](capturas/05_pruebas_seguridad.jpeg)


### Todas las pruebas en verde
![Todas las pruebas](capturas/06_pruebas_todas.jpeg)


## Evidencia de la aplicación

### Las 5 tarjetas cargadas
![Tablero con 5 tarjetas](capturas/07_app_tablero.jpeg)


### Sin conexión: las 5 tarjetas muestran un mensaje amable y la app no se cierra
![Sin conexión](capturas/08_app_sin_conexion.jpeg)


### Clave falsa de la NASA: solo esa tarjeta falla (403) y las otras 4 siguen bien
![Clave falsa](capturas/09_app_clave_falsa.jpeg)


## Ciclo TDD y reto (opcional)

Reto: cambiar temporalmente Open-Meteo a `http://` y ver qué prueba falla.

![Prueba en rojo](capturas/10_prueba_roja.jpeg)