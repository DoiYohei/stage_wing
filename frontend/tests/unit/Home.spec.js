import { shallowMount, createLocalVue } from "@vue/test-utils";
import Vuex from "vuex";
import Home from "@/views/Home";

const  localVue = createLocalVue();
localVue.use(Vuex);

describe("Displayed list", () => {
  let getters;
  let store;
  let wrapper;

  context("when user hasn't logged in", () => {
    beforeEach(() => {
      getters = {
        token: () => null
      };
      store = new Vuex.Store({
        getters
      });
      wrapper = shallowMount(Home, { store, localVue });
    });

    it("includes 'SIGN UP' and 'LOG IN'", () => {
      expect(wrapper.text()).toContain("SIGN UP");
      expect(wrapper.text()).toContain("LOG IN");
    });

    it("dosen't include 'MY MENU'", () => {
      expect(wrapper.text()).not.toContain("MY MENU");
    });
  });

  context("when user has logged in", () => {
    beforeEach(() => {
      getters = {
        token: () => "mockToken"
      };
      store = new Vuex.Store({
        getters
      });
      wrapper = shallowMount(Home, { store, localVue });
    });

    it("dosen't include 'SIGN UP' and 'LOG IN'", () => {
      expect(wrapper.text()).not.toContain("SIGN UP");
      expect(wrapper.text()).not.toContain("LOG IN");
    });

    it("includes 'MY MENU'", () => {
      expect(wrapper.text()).toContain("MY MENU");
    });
  });
});
