import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider, signInWithRedirect, getRedirectResult, signOut } from "firebase/auth";
import { firebaseConfig } from '../src/firebase.config.js';

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const provider = new GoogleAuthProvider();

// Al cargar la página, revisar si viene del redirect
getRedirectResult(auth)
  .then((result) => {
    if (result && result.user) {
      const user = result.user;
      console.log("Usuario logueado por redirect:", user);
      const infoEl = document.getElementById('user-info');
      if (infoEl) infoEl.textContent = user.email || user.displayName || 'Usuario';
    }
  })
  .catch((error) => {
    console.error("Error en getRedirectResult:", error);
  });

// Botón login
const btnLogin = document.getElementById('btn-login');
if (btnLogin) {
  btnLogin.addEventListener('click', () => {
    signInWithRedirect(auth, provider);
  });
}

// Botón logout
const btnLogout = document.getElementById('btn-logout');
if (btnLogout) {
  btnLogout.addEventListener('click', () => {
    signOut(auth).then(() => {
      console.log("Desconectado");
      const infoEl = document.getElementById('user-info');
      if (infoEl) infoEl.textContent = '';
    });
  });
}
