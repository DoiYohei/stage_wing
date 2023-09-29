import { createLocalVue, shallowMount } from "@vue/test-utils";
import Vuex from "vuex";
import TheHomeSmallList from "@/components/TheHomes/TheHomeSmallList";

const localVue = createLocalVue();
localVue.use(Vuex);

describe("TheHomeSmallList.vue", () => {
  let state;
  let getters;
  let store;
  let wrapper;

  beforeEach(() => {
    state = {
      token: null,
    };
    getters = {
      token: (state) => state.token,
    };
    store = new Vuex.Store({
      state,
      getters,
    });
    wrapper = shallowMount(TheHomeSmallList, {
      localVue,
      store,
      propsData: {
        value: false,
        cardItems: [
          {
            text: "test",
          },
        ],
        textStyle: "textStyle",
      },
    });
  });

  context("when user is not logged in", () => {
    it("does not have MY MENU and LOG OUT", () => {
      expect(wrapper.html()).not.toContain("MY MENU");
      expect(wrapper.html()).not.toContain("LOG OUT");
    });
  });

  context("when user is logged in", () => {
    beforeEach(() => {
      store.state.token = "testToken";
    });

    it("has MY MENU and LOG OUT", () => {
      expect(wrapper.html()).toContain("MY MENU");
      expect(wrapper.html()).toContain("LOG OUT");
    });
  });
});
