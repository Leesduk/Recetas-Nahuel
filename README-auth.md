# Google Sign-In - Integración rápida

## Resumen
Archivos añadidos:
- public/index.html — UI mínima para login/logout.
- public/auth.js — lógica de autenticación con Firebase (v9 modular).
- src/firebase.config.js — placeholders para tus credenciales.

## Pasos en Firebase Console
1. Entrá a la consola de Firebase y seleccioná tu proyecto.
2. Authentication → Sign-in method → habilitá Google.
3. En Authorized domains agregá:
   - http://localhost
   - http://localhost:3000 (si usás otro puerto, agregalo)
4. Copiá las credenciales del proyecto y pegálas en src/firebase.config.js.

## Probar localmente
1. Serví la carpeta public con un servidor estático:
   cd public
   python3 -m http.server 3000
2. Abrí http://localhost:3000 y probá "Iniciar con Google".

## Notas de seguridad
- No subas credenciales reales a repositorios públicos.
- Si necesitás endpoints protegidos, validá el ID token en el backend.
