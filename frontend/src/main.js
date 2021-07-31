import Vue from "vue";
import App from "./App";
import router from "./routes";
import store from "./store";
import axios from "./plugins/axios";
import vuetify from "./plugins/vuetify";
import VueYoutube from "./plugins/vue-youtube";
import VueCtkDateTimePicker from "vue-ctk-date-time-picker";
import "vue-ctk-date-time-picker/dist/vue-ctk-date-time-picker.css";
import dayjs from "dayjs";

Vue.config.productionTip = false;
Vue.prototype.$axios = axios;
Vue.prototype.$dayjs = dayjs;
Vue.component("VueCtkDateTimePicker", VueCtkDateTimePicker);

store.dispatch("autoLogin");

new Vue({
  VueYoutube,
  store,
  router,
  vuetify,
  render: (h) => h(App),
}).$mount("#app");
