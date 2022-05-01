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
import actioncable from "./plugins/actioncable-vue";
import Pagination from "./plugins/pagination";
import VuetifyAudio from "vuetify-audio";

Vue.config.productionTip = false;
Vue.prototype.$axios = axios;
Vue.prototype.$dayjs = dayjs;
Vue.component("VueCtkDateTimePicker", VueCtkDateTimePicker);
Vue.component("VuetifyAudio", VuetifyAudio);
Vue.use(Pagination);

store.dispatch("autoLogin");

new Vue({
  actioncable,
  VueYoutube,
  store,
  router,
  vuetify,
  render: (h) => h(App),
}).$mount("#app");
