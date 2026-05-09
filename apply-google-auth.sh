#!/usr/bin/env bash
set -e

REPO_DIR="${1:-.}"
BRANCH="feature/google-auth"

echo "Usando repo en: $REPO_DIR"
cd "$REPO_DIR"

git fetch origin
git checkout -B "$BRANCH"

mkdir -p public src

cat > public/index.html <<'HTML'
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Recetas - Login Google</title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;padding:24px}
    #userInfo{margin-top:16px}
    button{margin-right:8px;padding:8px 12px}
  </style>
</head>
<body>
  <h2>Iniciar sesión</h2>
  <button id="btnGoogle">Iniciar con Google</button>
  <button id="btnSignOut" style="display:none">Cerrar sesión</button>
  <div id="userInfo">No hay sesión</div>
  <script type="module" src="./auth.js"></script>
</body>
</html>
HTML

cat > public/auth.js <<'JS'
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.22.0/firebase-app.js";
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
  signOut,
  onAuthStateChanged
} from "https://www.gstatic.com/firebasejs/9.22.0/firebase-auth.js";
import { firebaseConfig } from "../src/firebase.config.js";

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const provider = new GoogleAuthProvider();

const btnGoogle = document.getElementById('btnGoogle');
const btnSignOut = document.getElementById('btnSignOut');
const userInfo = document.getElementById('userInfo');

btnGoogle.addEventListener('click', async () => {
  try {
    const result = await signInWithPopup(auth, provider);
    console.log('Login exitoso', result.user);
  } catch (err) {
    console.error('Error en signInWithPopup', err);
    if (err.code === 'auth/account-exists-with-different-credential') {
      alert('Ya existe una cuenta con ese correo usando otro proveedor.');
    } else {
      alert('Error al iniciar sesión: ' + err.message);
    }
  }
});

btnSignOut.addEventListener('click', async () => {
  try {
    await signOut(auth);
  } catch (err) {
    console.error('Error al cerrar sesión', err);
  }
});

onAuthStateChanged(auth, user => {
  if (user) {
    userInfo.textContent = `Conectado: ${user.displayName} (${user.email})`;
    btnGoogle.style.display = 'none';
    btnSignOut.style.display = 'inline-block';
  } else {
    userInfo.textContent = 'No hay sesión';
    btnGoogle.style.display = 'inline-block';
    btnSignOut.style.display = 'none';
  }
});
JS

cat > src/firebase.config.js <<'JS'
// Rellená estos valores con los de tu proyecto Firebase.
// No subas credenciales reales a repositorios públicos.
export const firebaseConfig = {
  apiKey: "TU_API_KEY",
  authDomain: "TU_AUTH_DOMAIN",
  projectId: "TU_PROJECT_ID",
  storageBucket: "TU_STORAGE_BUCKET",
  messagingSenderId: "TU_MESSAGING_SENDER_ID",
  appId: "TU_APP_ID"
};
JS

cat > README-auth.md <<'MD'
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
MD

git add public/index.html public/auth.js src/firebase.config.js README-auth.md
git commit -m "feat(auth): add Google Sign-In (signInWithPopup) + auth UI"
git push -u origin "$BRANCH"

echo "Hecho. Rama '$BRANCH' creada y pusheada."
