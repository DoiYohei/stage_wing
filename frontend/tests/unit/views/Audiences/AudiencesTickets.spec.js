import { createLocalVue, shallowMount } from "@vue/test-utils";
import { goHome } from "@/utils/routers";
import Vuex from "vuex";
import Vuetify from "vuetify";
import AudiencesTickets from "@/views/Audiences/AudiencesTickets";

const propsData = { id: 1 };
const axiosGetMock = jest.fn(() => Promise.resolve({
  data:  [
    {
      id: 1,
      event_name: "test",
      band_name: "test",
    },
  ],
}));
jest.mock("@/utils/routers", () => {
  return { goHome: jest.fn() };
});
jest.mock("@/utils/searches", () => {
  return { popFutureItems: jest.fn((tickets) => {
    return tickets;
  }) };
});
afterEach(() => {
  goHome.mockClear();
  axiosGetMock.mockClear();
});

const localVue = createLocalVue();
localVue.use(Vuex);

describe("AudiencesTickets.vue", () => {
  let store;
  let getters;
  let vuetify;
  let wrapper;

  context("when user is not this page owner", () => {
    beforeEach(() => {
      getters = {
        audienceId: () => 2,
        headers: () => "headers",
      };
      store = new Vuex.Store({
        getters,
      });
      vuetify = new Vuetify();
      wrapper = shallowMount(AudiencesTickets, {
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
        audienceId: () => 1,
        headers: () => "headers",
      };
      store = new Vuex.Store({
        getters,
      });
      vuetify = new Vuetify();
      wrapper = shallowMount(AudiencesTickets, {
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

  describe("regarding shortenName method", () => {
    context("when argument is over 42 half-width characters", () => {
      const half = "a".repeat(43);
      const halfAndFull = "a".repeat(41) + "あ";
      const full = "あ".repeat(22);
      it("returns shortened name", () => {
        expect(wrapper.vm.shortenName(half)).toBe("a".repeat(42) + "...");
        expect(wrapper.vm.shortenName(halfAndFull)).toBe("a".repeat(41) + "...");
        expect(wrapper.vm.shortenName(full)).toBe("あ".repeat(21) + "...");
      });
    });

    context("when argument is 42 half-width characters", () => {
      const half = "a".repeat(42);
      const halfAndFull = "a".repeat(40) + "あ";
      const full = "あ".repeat(21);
      it("returns full name", () => {
        expect(wrapper.vm.shortenName(half)).toBe("a".repeat(42));
        expect(wrapper.vm.shortenName(halfAndFull)).toBe("a".repeat(40) + "あ");
        expect(wrapper.vm.shortenName(full)).toBe("あ".repeat(21));
      });
    });

    context("when argument is under 42 half-width characters", () => {
      const half = "a".repeat(41);
      const halfAndFull = "a".repeat(39) + "あ";
      const full = "あ".repeat(20);
      it("returns full name", () => {
        expect(wrapper.vm.shortenName(half)).toBe("a".repeat(41));
        expect(wrapper.vm.shortenName(halfAndFull)).toBe("a".repeat(39) + "あ");
        expect(wrapper.vm.shortenName(full)).toBe("あ".repeat(20));
      });
    });
  });
});
