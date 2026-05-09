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
