import { createLocalVue, shallowMount } from "@vue/test-utils";
import Vuex from "vuex";
import TheBandsBiography from "@/components/TheBands/TheBandsBiography";

const localVue = createLocalVue();
localVue.use(Vuex);

describe("TheBandsBiography.vue", () => {
  let state;
  let getters;
  let store;
  let wrapper;

  beforeEach(() => {
    state = {
      bandId: null,
    };
    getters = {
      bandId: (state) => state.bandId,
    };
    store = new Vuex.Store({
      state,
      getters,
    });
    wrapper = shallowMount(TheBandsBiography, {
      localVue,
      store,
      propsData: {
        band: {
          id: 1,
        },
        isMyPage: false,
      },
    });
  });

  context("when user is not login band", () => {
    it("has not edit button, friendship button and chat button", () => {
      expect(wrapper.find("[data-jest='edit-btn']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='friendship-btn']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='chat-btn']").exists()).toBe(false);
    });
  });

  context("when user is login band but not owner and friend of this page band", () => {
    beforeEach(() => {
      store.state.bandId = 2;
      wrapper.setProps({
        band: {
          id: 1,
        },
        isMyPage: false,
      });
    });

    it("has not edit button and chat button", () => {
      expect(wrapper.find("[data-jest='edit-btn']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='chat-btn']").exists()).toBe(false);
    });
    it("has friendship button", () => {
      expect(wrapper.find("[data-jest='friendship-btn']").exists()).toBe(true);
    });
  });

  context("when user is login band and friend of this page band", () => {
    beforeEach(() => {
      store.state.bandId = 2;
      wrapper.setProps({
        band: {
          id: 1,
        },
        isMyPage: false,
        friendState: "friend",
      });
    });

    it("has not edit button", () => {
      expect(wrapper.find("[data-jest='edit-btn']").exists()).toBe(false);
    });
    it("has friendship button and chat button", () => {
      expect(wrapper.find("[data-jest='friendship-btn']").exists()).toBe(true);
      expect(wrapper.find("[data-jest='chat-btn']").exists()).toBe(true);
    });
  });

  context("when user is owner of this page band", () => {
    beforeEach(() => {
      store.state.bandId = 1;
      wrapper.setProps({
        band: {
          id: 1,
        },
        isMyPage: true,
      });
    });

    it("has edit button", () => {
      expect(wrapper.find("[data-jest='edit-btn']").exists()).toBe(true);
    });
    it("has not friendship button and chat button", () => {
      expect(wrapper.find("[data-jest='friendship-btn']").exists()).toBe(false);
      expect(wrapper.find("[data-jest='chat-btn']").exists()).toBe(false);
    });
  });
});
