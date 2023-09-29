import { createLocalVue, shallowMount } from "@vue/test-utils";
import Vuetify from "vuetify";
import Vuex from "vuex";
import TheAppNavigationDrawer from "@/components/TheApps/TheAppNavigationDrawer";

const localVue = createLocalVue();
localVue.use(Vuetify);
localVue.use(Vuex);

describe("TheAppNavigationDrawer.vue", () => {
  let vuetify;
  let state;
  let getters;
  let actions;
  let store;
  let wrapper;

  beforeEach(() => {
    vuetify = new Vuetify();
    state = {
      bandId: null,
      audienceId: null,
      token: null,
      userNmae: null,
      userImage: null,
    };
    getters = {
      bandId: (state) => state.bandId,
      audienceId: (state) => state.audienceId,
      token: (state) => state.token,
      userName: (state) => state.userName,
      userImage: (state) => state.userImage,
    };
    actions = {
      logout: jest.fn(),
      deleteAccount: jest.fn(),
    };
    store = new Vuex.Store({
      state,
      getters,
      actions,
    });
    wrapper = shallowMount(TheAppNavigationDrawer, {
      localVue,
      vuetify,
      store,
      propsData: { value: true },
    });
  });

  context("when user is not logged in", () => {
    it("has not login user menues", () => {
      expect(wrapper.text()).toContain("未ログイン");
      expect(wrapper.text()).toContain("アカウント作成");
      expect(wrapper.text()).toContain("ログイン");
      expect(wrapper.text()).not.toContain("マイページ");
      expect(wrapper.text()).not.toContain("新規Event作成");
      expect(wrapper.text()).not.toContain("新規Post作成");
      expect(wrapper.text()).not.toContain("Friendリスト");
      expect(wrapper.text()).not.toContain("チャット");
      expect(wrapper.text()).not.toContain("チケット取り置き状況");
      expect(wrapper.text()).not.toContain("お気に入り");
      expect(wrapper.text()).not.toContain("アカウント編集");
      expect(wrapper.text()).not.toContain("取り置きしているチケット");
      expect(wrapper.text()).not.toContain("ログアウト");
      expect(wrapper.text()).not.toContain("退会する");
    });
  });

  context("when user is login band", () => {
    beforeEach(() => {
      store.state.bandId = 1;
      store.state.token = "token";
      store.state.userName = "bandName";
      store.state.userImage = "url";
    });
    
    it("has login band menues", () => {
      expect(wrapper.text()).toContain("bandName");
      expect(wrapper.text()).toContain("マイページ");
      expect(wrapper.text()).toContain("新規Event作成");
      expect(wrapper.text()).toContain("新規Post作成");
      expect(wrapper.text()).toContain("Friendリスト");
      expect(wrapper.text()).toContain("チャット");
      expect(wrapper.text()).toContain("チケット取り置き状況");
      expect(wrapper.text()).toContain("お気に入り");
      expect(wrapper.text()).toContain("アカウント編集");
      expect(wrapper.text()).toContain("ログアウト");
      expect(wrapper.text()).toContain("退会する");
      expect(wrapper.text()).not.toContain("アカウント作成");
      expect(wrapper.text()).not.toContain("ログイン");
      expect(wrapper.text()).not.toContain("取り置きしているチケット");
    });
  });

  context("when user is login audience", () => {
    beforeEach(() => {
      store.state.audienceId = 1;
      store.state.token = "token";
      store.state.userName = "audienceName";
      store.state.userImage = "url";
    });

    it("has login audience menues", () => {
      expect(wrapper.text()).toContain("audienceName");
      expect(wrapper.text()).toContain("お気に入り");
      expect(wrapper.text()).toContain("取り置きしているチケット");
      expect(wrapper.text()).toContain("アカウント編集");
      expect(wrapper.text()).toContain("ログアウト");
      expect(wrapper.text()).toContain("退会する");
      expect(wrapper.text()).not.toContain("マイページ");
      expect(wrapper.text()).not.toContain("新規Event作成");
      expect(wrapper.text()).not.toContain("新規Post作成");
      expect(wrapper.text()).not.toContain("Friendリスト");
      expect(wrapper.text()).not.toContain("チャット");
      expect(wrapper.text()).not.toContain("チケット取り置き状況");
      expect(wrapper.text()).not.toContain("アカウント作成");
      expect(wrapper.text()).not.toContain("ログイン");
    });
  });
});
