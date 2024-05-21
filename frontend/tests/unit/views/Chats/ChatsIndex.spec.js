import { createLocalVue, shallowMount } from "@vue/test-utils";
import { goHome } from "@/utils/routers";
import { fetchRooms } from "@/utils/chats";
import Vuex from "vuex";
import Vuetify from "vuetify";
import ChatsIndex from "@/views/Chats/ChatsIndex";

const propsData = { id: 1 };
jest.mock("@/utils/routers", () => {
  return { goHome: jest.fn() };
});
jest.mock("@/utils/chats", () => {
  return { fetchRooms: jest.fn(() => {
    return { data: ["data"] };
  }) };
});
afterEach(() => {
  goHome.mockClear();
  fetchRooms.mockClear();
});

const localVue = createLocalVue();
localVue.use(Vuex);

describe("ChatsIndex.vue", () => {
  let store;
  let getters;
  let vuetify;
  let wrapper;

  context("when user is not this page owner", () => {
    beforeEach(() => {
      getters = {
        bandId: () => 2,
        headers: () => "headers",
      };
      store = new Vuex.Store({
        getters,
      });
      vuetify = new Vuetify();
      wrapper = shallowMount(ChatsIndex, {
        localVue,
        store,
        vuetify,
        propsData,
      });
    });

    it("goes home page", () => {
      expect(goHome).toHaveBeenCalled();
      expect(fetchRooms).not.toHaveBeenCalled();
    });
  });

  context("when user is this page owner", () => {
    beforeEach(() => {
      getters = {
        bandId: () => 1,
        headers: () => "headers",
      };
      store = new Vuex.Store({
        getters,
      });
      vuetify = new Vuetify();
      wrapper = shallowMount(ChatsIndex, {
        localVue,
        store,
        vuetify,
        propsData,
      });
    });

    it("renders this page", () => {
      expect(goHome).not.toHaveBeenCalled();
      expect(fetchRooms).toHaveBeenCalled();
    });
  });
});
