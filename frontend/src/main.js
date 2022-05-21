import Vue from "vue";
import App from "./App";
import router from "./routes";
import store from "./store";
import vuetify from "./plugins/vuetify";
import veevalidate from "./plugins/vee-validate";
import actioncable from "./plugins/actioncable-vue";
import axios from "./plugins/axios";
import dayjs from "dayjs";
import VueYoutube from "vue-youtube";
import Pagination from "./plugins/pagination";

Vue.config.productionTip = false;
Vue.prototype.$axios = axios;
Vue.prototype.$dayjs = dayjs;
Vue.use(VueYoutube);
Vue.use(Pagination);

store.dispatch("autoLogin");

new Vue({
  router,
  store,
  vuetify,
  veevalidate,
  actioncable,
  render: (h) => h(App),
}).$mount("#app");
