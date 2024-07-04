import { createLocalVue, shallowMount } from "@vue/test-utils";
import { goHome } from "@/utils/routers";
import Vuex from "vuex";
import Vuetify from "vuetify";
import BandsEdit from "@/views/Bands/BandsEdit";

const propsData = { id: 1 };
const axiosGetMock = jest.fn(() => Promise.resolve({
  data:  {
    id: 1,
  },
}));
jest.mock("@/utils/routers", () => {
  return { goHome: jest.fn() };
});
afterEach(() => {
  goHome.mockClear();
  axiosGetMock.mockClear();
});

const localVue = createLocalVue();
localVue.use(Vuex);

describe("BandsEdit.vue", () => {
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
      wrapper = shallowMount(BandsEdit, {
        localVue,
        store,
        vuetify,
        propsData,
        mocks: {
          $axios: {
            get: axiosGetMock,
          },
        },
      });
    });

    it("goes home page", () => {
      expect(goHome).toHaveBeenCalled();
      expect(axiosGetMock).not.toHaveBeenCalled();
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
      wrapper = shallowMount(BandsEdit, {
        localVue,
        store,
        vuetify,
        propsData,
        mocks: {
          $axios: {
            get: axiosGetMock,
          },
        },
      });
    });

    it("renders this page", () => {
      expect(goHome).not.toHaveBeenCalled();
      expect(axiosGetMock).toHaveBeenCalled();
    });
  });
});
