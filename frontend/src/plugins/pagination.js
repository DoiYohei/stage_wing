const Pagination = {
  install(Vue) {
    const store = new Vue({
      data: {
        current: 1,
        total: 0,
        rowsPerPage: 0,
        displayContents: [],
      },
    });
    Vue.prototype.$page = {
      get current() {
        return store.current;
      },
      get total() {
        return store.total;
      },
      get displayContents() {
        return store.displayContents;
      },
      set current(number) {
        const current = number != null ? parseInt(number) : 1;
        store.current = Math.max(1, Math.min(current, store.total));
      },
      set rowsPerPage(number) {
        store.rowsPerPage = number != null ? parseInt(number) : 0;
      },
      set displayContents(contents) {
        store.displayContents = contents.slice(
          store.rowsPerPage * (store.current - 1),
          store.rowsPerPage * store.current
        );
        store.total = Math.ceil(contents.length / store.rowsPerPage);
      },
    };
  },
};
export default Pagination;
