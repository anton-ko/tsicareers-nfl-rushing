import * as Vue  from 'vue'
import App from './App.vue'
import router from './router'

import axios from 'axios'
import VueAxios from 'vue-axios'

import './styles/app.css'
import './assets/tailwind.css'

Vue.createApp(App)
  .use(router)
  .use(VueAxios, axios)
  .mount('#app')
